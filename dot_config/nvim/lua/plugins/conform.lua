return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fb",
				function()
					require("conform").format({ async = true, lsp_format = "never" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = true,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "never",
			},
			formatters_by_ft = {
				javascript = { "oxfmt", "biome", "biome-organize-imports" },
				javascriptreact = { "oxfmt", "biome", "biome-organize-imports" },
				typescript = { "oxfmt", "biome", "biome-organize-imports" },
				typescriptreact = { "oxfmt", "biome", "biome-organize-imports" },
				go = { "gofumpt", "goimports" },
				lua = { "stylua" },
				rust = { "rustfmt", "maudfmt", lsp_format = "fallback" },
			},
			formatters = {
				maudfmt = {
					command = "maudfmt",
					args = { "-s" },
				},
				oxfmt = {
					command = "oxfmt",
					args = { "$FILENAME" },
					stdin = false,
				},
				sql = { "sleek" },
			},
		},
	},
}
