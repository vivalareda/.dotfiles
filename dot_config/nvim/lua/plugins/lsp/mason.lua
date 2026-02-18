return {
	"williamboman/mason.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		-- Install everything via Mason (these are Mason package names)
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSP servers
				"biome",
				"lua-language-server",
				"eslint-lsp",
				"vtsls",
				"html-lsp",
				"css-lsp",
				"tailwindcss-language-server",
				"svelte-language-server",
				"graphql-language-service-cli",
				"prisma-language-server",
				"pyright",
				"terraform-ls",
				"oxlint",
				-- Tools
				"prettier",
				"eslint_d",
			},
		})

		-- Enable LSP servers using the native vim.lsp.config API (Neovim 0.11+)
		-- Base configs come from nvim-lspconfig's lsp/*.lua files on the runtimepath.
		-- Custom overrides live in ~/.config/nvim/after/lsp/*.lua
		vim.lsp.enable({
			"biome",
			"lua_ls",
			"eslint",
			"vtsls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"graphql",
			"prismals",
			"pyright",
			"terraformls",
			"oxlint",
		})
	end,
}
