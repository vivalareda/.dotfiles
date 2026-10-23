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
				javascript = { "oxfmt" },
				javascriptreact = { "oxfmt" },
				typescript = { "oxfmt" },
				typescriptreact = { "oxfmt" },
				json = { "oxfmt" },
				jsonc = { "oxfmt" },
				markdown = { "oxfmt" },
				css = { "oxfmt" },
				scss = { "oxfmt" },
				html = { "oxfmt" },
				yaml = { "oxfmt" },
				go = { "gofumpt", "goimports" },
				lua = { "stylua" },
				rust = { "rustfmt", "maudfmt", lsp_format = "fallback" },
			},
			formatters = {
				maudfmt = {
					command = "maudfmt",
					args = { "-s" },
				},
				sql = { "sleek" },
			},
		},
	},
}
