import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

export default function (pi) {
  let activeRun = null;

  pi.registerCommand("compar", {
    description: "Run two comparison agents on the same prompt",
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

      activeRun = {
        prompt,
        candidates: [
          { id: "a", status: "starting" },
          { id: "b", status: "starting" },
        ],
      };

      ctx.ui.notify(`Started compare run: ${prompt}`, "info");
      ctx.ui.notify("Candidates: a, b", "info");
    },
  });
}
