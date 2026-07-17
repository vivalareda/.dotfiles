import { type ChildProcess, spawn } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

type Candidate = {
  id: string;
  branch: string;
  status:
    | "starting"
    | "ready"
    | "running"
    | "done"
    | "preview-starting"
    | "preview-ready"
    | "failed";
  dir: string;
  process?: ChildProcess;
  devProcess?: ChildProcess;
  result?: string;
  error?: string;
  previewUrl?: string;
  packageManager?: "npm" | "pnpm" | "bun";
  startedAt?: number;
  finishedAt?: number;
};

export default function (pi: ExtensionAPI) {
  let activeRun: {
    prompt: string;
    candidates: Candidate[];
    runId: string;
    packageManager: "npm" | "pnpm" | "bun";
  } | null = null;
  let portlessProxyStarted = false;
  let portlessProxyStarting: Promise<void> | null = null;
  let projectPackageManager: "npm" | "pnpm" | "bun" | null = null;

  const slugify = (value: string) =>
    value
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
      .slice(0, 24) || "task";

  const detectPackageManager = (dir: string): "npm" | "pnpm" | "bun" => {
    if (
      fs.existsSync(path.join(dir, "bun.lock")) ||
      fs.existsSync(path.join(dir, "bun.lockb"))
    ) {
      return "bun";
    }
    if (fs.existsSync(path.join(dir, "pnpm-lock.yaml"))) {
      return "pnpm";
    }
    return "npm";
  };

  const getProjectPackageManager = (dir: string): "npm" | "pnpm" | "bun" => {
    if (!projectPackageManager) {
      projectPackageManager = detectPackageManager(dir);
    }
    return projectPackageManager;
  };

  const runCommand = async (
    command: string,
    args: string[],
    cwd: string,
  ): Promise<string> =>
    new Promise((resolve, reject) => {
      const child = spawn(command, args, {
        cwd,
        env: process.env,
        stdio: ["ignore", "pipe", "pipe"],
      });

      let stdout = "";
      let stderr = "";

      child.stdout?.on("data", (chunk) => {
        stdout += chunk.toString();
      });

      child.stderr?.on("data", (chunk) => {
        stderr += chunk.toString();
      });

      child.on("error", reject);
      child.on("close", (code) => {
        if (code === 0) {
          resolve(stdout);
        } else {
          reject(
            new Error(
              stderr.trim() ||
                stdout.trim() ||
                `${command} exited with code ${code}`,
            ),
          );
        }
      });
    });

  const installDependencies = async (
    dir: string,
    packageManager: "npm" | "pnpm" | "bun",
  ) => {
    const argsByManager: Record<typeof packageManager, string[]> = {
      npm: ["install"],
      pnpm: ["install"],
      bun: ["install"],
    };

    await runCommand(packageManager, argsByManager[packageManager], dir);
  };

  const linkOrCopyWorktreeAssets = (sourceDir: string, targetDir: string) => {
    const sharedNodeModules = path.join(sourceDir, "node_modules");
    const targetNodeModules = path.join(targetDir, "node_modules");

    if (fs.existsSync(sharedNodeModules) && !fs.existsSync(targetNodeModules)) {
      fs.symlinkSync(sharedNodeModules, targetNodeModules, "junction");
    }

    const copyIfPresent = (relativePath: string) => {
      const from = path.join(sourceDir, relativePath);
      const to = path.join(targetDir, relativePath);
      if (!fs.existsSync(from) || fs.existsSync(to)) {
        return;
      }

      const stat = fs.statSync(from);
      if (stat.isDirectory()) {
        fs.cpSync(from, to, { recursive: true });
      } else {
        fs.copyFileSync(from, to);
      }
    };

    [
      ".env",
      ".env.local",
      ".env.development",
      ".env.development.local",
      ".npmrc",
    ].forEach(copyIfPresent);
  };

  const ensurePortlessDevScript = (dir: string) => {
    const packageJsonPath = path.join(dir, "package.json");
    if (!fs.existsSync(packageJsonPath)) {
      throw new Error(`No package.json found in ${dir}`);
    }

    const raw = fs.readFileSync(packageJsonPath, "utf8");
    const packageJson = JSON.parse(raw) as {
      scripts?: Record<string, unknown>;
    };

    if (!packageJson || typeof packageJson !== "object") {
      throw new Error(`Invalid package.json in ${dir}`);
    }

    const scripts = packageJson.scripts;
    if (!scripts || typeof scripts !== "object") {
      throw new Error(`No scripts section found in ${packageJsonPath}`);
    }

    const devCommand = scripts.dev;
    if (typeof devCommand !== "string" || devCommand.trim().length === 0) {
      throw new Error(`No dev script found in ${packageJsonPath}`);
    }

    if (!devCommand.startsWith("portless run ")) {
      const cleaned = devCommand
        .replace(/--port[=\s]+\d+/g, "")
        .replace(/\s+/g, " ")
        .trim();

      scripts.dev = `portless run ${cleaned}`;
      fs.writeFileSync(
        packageJsonPath,
        `${JSON.stringify(packageJson, null, 2)}\n`,
      );
    }
  };

  const ensurePortlessProxy = async () => {
    if (portlessProxyStarted) {
      return;
    }
    if (portlessProxyStarting) {
      await portlessProxyStarting;
      return;
    }

    portlessProxyStarting = new Promise<void>((resolve, reject) => {
      const child = spawn("portless", ["proxy", "start"], {
        env: process.env,
        stdio: ["ignore", "pipe", "pipe"],
      });

      let stderr = "";
      child.stderr?.on("data", (chunk) => {
        stderr += chunk.toString();
      });

      child.on("error", reject);
      child.on("close", (code) => {
        if (code === 0) {
          portlessProxyStarted = true;
          resolve();
          return;
        }

        const message = stderr.trim();
        if (
          message.toLowerCase().includes("already") ||
          message.toLowerCase().includes("running")
        ) {
          portlessProxyStarted = true;
          resolve();
          return;
        }

        reject(
          new Error(message || `portless proxy start exited with code ${code}`),
        );
      });
    });

    try {
      await portlessProxyStarting;
    } finally {
      portlessProxyStarting = null;
    }
  };

  const extractUrl = (text: string) => {
    const match = text.match(/https?:\/\/\S+/);
    return match?.[0]?.replace(/[)\]>'".,;]+$/, "");
  };

  const openUrl = (url: string) => {
    const opener =
      process.platform === "darwin"
        ? "open"
        : process.platform === "win32"
          ? "cmd"
          : "xdg-open";
    const args =
      process.platform === "win32" ? ["/c", "start", "", url] : [url];
    const child = spawn(opener, args, {
      env: process.env,
      stdio: "ignore",
      detached: true,
    });
    child.unref();
  };

  pi.registerCommand("compar", {
    description: "Create two comparison worktrees and run two workers",
    handler: async (args, ctx) => {
      const prompt = args.trim();
      if (!prompt) {
        ctx.ui.notify("Usage: /compar <prompt>", "warning");
        return;
      }
      if (activeRun) {
        ctx.ui.notify("A compare run is already active", "warning");
        return;
      }

      const cwd = ctx.cwd;
      const parentDir = path.dirname(cwd);
      const repoName = path.basename(cwd);
      const slug = slugify(prompt);
      const runId = `${slug}-${Date.now().toString().slice(-6)}`;
      const selectedModel = ctx.model as
        | {
            provider?: string;
            id?: string;
          }
        | undefined;
      const packageManager = getProjectPackageManager(cwd);

      const candidates: Candidate[] = [
        {
          id: "a",
          branch: `compar-${runId}-a`,
          dir: path.join(parentDir, `${repoName}-compar-${runId}-a`),
          status: "starting",
        },
        {
          id: "b",
          branch: `compar-${runId}-b`,
          dir: path.join(parentDir, `${repoName}-compar-${runId}-b`),
          status: "starting",
        },
      ];

      const maybeNotifyAllFinished = () => {
        if (!activeRun) return;
        const allFinished = activeRun.candidates.every((candidate) =>
          ["done", "preview-starting", "preview-ready", "failed"].includes(
            candidate.status,
          ),
        );
        if (!allFinished) return;
        ctx.ui.notify(
          "Both comparison workers finished. Preview servers will start automatically when possible. Run /compar-list to inspect results.",
          "info",
        );
      };

      const startPreview = async (candidate: Candidate) => {
        try {
          await ensurePortlessProxy();
          const packageManager =
            activeRun?.packageManager ??
            getProjectPackageManager(candidate.dir);
          ensurePortlessDevScript(candidate.dir);
          candidate.packageManager = packageManager;
          candidate.status = "preview-starting";

          ctx.ui.notify(
            `Installing dependencies for candidate ${candidate.id.toUpperCase()}`,
            "info",
          );
          await installDependencies(candidate.dir, packageManager);

          const argsByManager: Record<
            NonNullable<Candidate["packageManager"]>,
            string[]
          > = {
            npm: ["run", "dev"],
            pnpm: ["run", "dev"],
            bun: ["run", "dev"],
          };

          const child = spawn(
            candidate.packageManager,
            argsByManager[candidate.packageManager],
            {
              cwd: candidate.dir,
              env: process.env,
              stdio: ["ignore", "pipe", "pipe"],
            },
          );

          candidate.devProcess = child;

          let combinedOutput = "";
          const onData = (chunk: Buffer | string) => {
            combinedOutput += chunk.toString();
            const url = extractUrl(combinedOutput);
            if (url && !candidate.previewUrl) {
              candidate.previewUrl = url;
              candidate.status = "preview-ready";
              ctx.ui.notify(
                `Candidate ${candidate.id.toUpperCase()} preview ready: ${url}`,
                "info",
              );
              try {
                openUrl(url);
              } catch {}
            }
          };

          child.stdout?.on("data", onData);
          child.stderr?.on("data", onData);

          child.on("error", (error) => {
            if (!candidate.previewUrl) {
              candidate.status = "failed";
              candidate.error = `Preview failed to start: ${error.message}`;
              ctx.ui.notify(
                `Candidate ${candidate.id.toUpperCase()} preview failed`,
                "error",
              );
            }
          });

          child.on("close", (code) => {
            candidate.devProcess = undefined;
            if (!candidate.previewUrl) {
              candidate.status = "failed";
              candidate.error =
                combinedOutput.trim() || `Preview exited with code ${code}`;
              ctx.ui.notify(
                `Candidate ${candidate.id.toUpperCase()} preview exited (code ${code}): ${combinedOutput.slice(0, 200)}`,
                "warning",
              );
            }
          });
        } catch (error) {
          candidate.status = "failed";
          candidate.error =
            error instanceof Error ? error.message : String(error);
          ctx.ui.notify(
            `Candidate ${candidate.id.toUpperCase()} preview setup failed`,
            "error",
          );
        }
      };

      const launchWorker = (candidate: Candidate) => {
        const workerPrompt = [
          `You are comparison candidate ${candidate.id.toUpperCase()} working in an isolated git worktree.`,
          "Complete the user's task in this repository.",
          "",
          "Rules:",
          "- Make the changes directly in the repo.",
          "- Be concise in the final response.",
          "- End with a short summary and list of key files changed.",
          "",
          "Task:",
          prompt,
        ].join("\n");

        const args = ["-p", "--no-session"];
        if (selectedModel?.provider && selectedModel?.id) {
          args.push("--model", `${selectedModel.provider}/${selectedModel.id}`);
        }
        args.push(workerPrompt);

        const child = spawn("pi", args, {
          cwd: candidate.dir,
          env: process.env,
          stdio: ["ignore", "pipe", "pipe"],
        });

        candidate.process = child;
        candidate.status = "running";
        candidate.startedAt = Date.now();

        let stdout = "";
        let stderr = "";

        child.stdout?.on("data", (chunk) => {
          stdout += chunk.toString();
        });

        child.stderr?.on("data", (chunk) => {
          stderr += chunk.toString();
        });

        child.on("error", (error) => {
          candidate.status = "failed";
          candidate.error = error.message;
          candidate.finishedAt = Date.now();
          ctx.ui.notify(
            `Candidate ${candidate.id.toUpperCase()} failed to start`,
            "error",
          );
          maybeNotifyAllFinished();
        });

        child.on("close", (code) => {
          candidate.process = undefined;
          candidate.finishedAt = Date.now();
          if (code === 0) {
            candidate.status = "done";
            candidate.result = stdout.trim();
            ctx.ui.notify(
              `Candidate ${candidate.id.toUpperCase()} finished`,
              "info",
            );
            void startPreview(candidate);
          } else {
            candidate.status = "failed";
            candidate.error =
              stderr.trim() || stdout.trim() || `Exited with code ${code}`;
            ctx.ui.notify(
              `Candidate ${candidate.id.toUpperCase()} failed`,
              "error",
            );
          }
          maybeNotifyAllFinished();
        });
      };

      try {
        for (const candidate of candidates) {
          if (fs.existsSync(candidate.dir)) {
            throw new Error(`Directory already exists: ${candidate.dir}`);
          }
          await pi.exec("git", [
            "worktree",
            "add",
            "-b",
            candidate.branch,
            candidate.dir,
          ]);
          linkOrCopyWorktreeAssets(cwd, candidate.dir);
          candidate.status = "ready";
        }

        activeRun = { prompt, runId, candidates, packageManager };

        for (const candidate of candidates) {
          launchWorker(candidate);
        }

        ctx.ui.notify(
          [
            "Created two comparison worktrees and started both workers",
            `Candidate A: ${candidates[0].dir}`,
            `Candidate B: ${candidates[1].dir}`,
          ].join("\n"),
          "info",
        );
      } catch (error) {
        for (const candidate of candidates) {
          try {
            candidate.process?.kill("SIGTERM");
          } catch {}

          try {
            if (fs.existsSync(candidate.dir)) {
              await pi.exec("git", [
                "worktree",
                "remove",
                "--force",
                candidate.dir,
              ]);
            }
          } catch {}

          try {
            await pi.exec("git", ["branch", "-D", candidate.branch]);
          } catch {}
        }

        ctx.ui.notify(
          `Failed to create worktrees: ${error instanceof Error ? error.message : String(error)}`,
          "error",
        );
      }
    },
  });

  pi.registerCommand("cleanup", {
    description: "Remove comparison worktrees",
    handler: async (_, ctx) => {
      if (!activeRun) {
        ctx.ui.notify("No active compare run", "warning");
        return;
      }

      const run = activeRun;
      activeRun = null;

      const failures: string[] = []; // was implicitly `any[]`
      for (const candidate of run.candidates) {
        try {
          candidate.process?.kill("SIGTERM");
        } catch {}

        try {
          candidate.devProcess?.kill("SIGTERM");
        } catch {}

        try {
          await pi.exec("git", [
            "worktree",
            "remove",
            "--force",
            candidate.dir,
          ]);
        } catch (error) {
          failures.push(
            `remove ${candidate.id}: ${error instanceof Error ? error.message : String(error)}`,
          );
        }
        try {
          await pi.exec("git", ["branch", "-D", candidate.branch]);
        } catch (error) {
          failures.push(
            `delete branch ${candidate.id}: ${error instanceof Error ? error.message : String(error)}`,
          );
        }
      }

      if (failures.length > 0) {
        ctx.ui.notify(
          ["Cleanup completed with issues", ...failures].join("\n"),
          "warning",
        );
        return;
      }

      ctx.ui.notify("Comparison worktrees cleaned up", "info"); // "success" doesn't exist
    },
  });

  pi.registerCommand("compar-list", {
    description: "Show the current comparison run",
    handler: async (_args, ctx) => {
      if (!activeRun) {
        ctx.ui.notify("No active compare run", "warning");
        return;
      }

      const lines = [
        "Active comparison run",
        `Prompt: ${activeRun.prompt}`,
        `Run ID: ${activeRun.runId}`,
        `Package manager: ${activeRun.packageManager}`,
        "",
        ...activeRun.candidates.flatMap((candidate) => {
          const lines = [
            `Candidate ${candidate.id.toUpperCase()}`,
            `- status: ${candidate.status}`,
            `- branch: ${candidate.branch}`,
            `- dir: ${candidate.dir}`,
          ];
          if (candidate.startedAt) {
            lines.push(
              `- started: ${new Date(candidate.startedAt).toLocaleTimeString()}`,
            );
          }
          if (candidate.finishedAt) {
            lines.push(
              `- finished: ${new Date(candidate.finishedAt).toLocaleTimeString()}`,
            );
          }
          if (candidate.packageManager) {
            lines.push(`- package manager: ${candidate.packageManager}`);
          }
          if (candidate.previewUrl) {
            lines.push(`- preview: ${candidate.previewUrl}`);
          }
          if (candidate.result) {
            lines.push("- result:");
            lines.push(
              ...candidate.result
                .split("\n")
                .slice(0, 8)
                .map((line) => `  ${line}`),
            );
          }
          if (candidate.error) {
            lines.push("- error:");
            lines.push(
              ...candidate.error
                .split("\n")
                .slice(0, 8)
                .map((line) => `  ${line}`),
            );
          }
          lines.push("");
          return lines;
        }),
      ];

      ctx.ui.notify(lines.join("\n"), "info");
    },
  });
}
