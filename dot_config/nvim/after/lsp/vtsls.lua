-- Override vtsls config for monorepo root detection and workspace TypeScript
return {
	root_markers = { "pnpm-workspace.yaml", "turbo.json", "lerna.json", ".git" },
	settings = {
		vtsls = {
			autoUseWorkspaceTsdk = true,
			tsserverRestartOnTsdkChange = true,
			separateDiagnosticServer = { enable = true },
			tsserverMaxMemory = 4096,
			tsserverWatchOptions = { watchFile = "useFsEventsOnSubdir" },
		},
	},
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
}
