return {
	{
		"neovim/nvim-lspconfig",
		-- nvim-lspconfig is loaded for its lsp/*.lua server configs on the runtimepath.
		-- Server activation is handled via vim.lsp.enable() in mason.lua.
		dependencies = {
			"saghen/blink.cmp",
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						-- Add these to match your current config
						{ path = vim.env.VIMRUNTIME },
						{ path = "${3rd}/busted/library" },
					},
					-- Pass your existing lua_ls settings to lazydev
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
							},
						},
					},
				},
			},
		},
		config = function()
			local keymap = vim.keymap

			do
				local ok, fte = pcall(require, "format-ts-errors")
				if not ok then
					return
				end

				fte.setup({ add_markdown = true, start_indent_level = 0 })

				local default = vim.lsp.handlers["textDocument/publishDiagnostics"]

				vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
					if result and result.diagnostics and ctx and ctx.client_id then
						local client = vim.lsp.get_client_by_id(ctx.client_id)

						-- scope to TS server(s)
						if
							client and (client.name == "vtsls" or client.name == "tsserver" or client.name == "ts_ls")
						then
							local i = 1
							while i <= #result.diagnostics do
								local d = result.diagnostics[i]

								-- optional: drop annoying diagnostics
								if d.code == 80001 then
									table.remove(result.diagnostics, i)
								else
									local code = d.code
									local formatter = fte[code] or fte[tonumber(code) or -1] or fte[tostring(code)]
									if formatter and d.message then
										d.message = formatter(d.message)
									end
									i = i + 1
								end
							end
						end
					end

					return default(err, result, ctx, config)
				end
			end

			vim.filetype.add({
				extension = {
					qc = "qc",
				},
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "qc",
				callback = function()
					vim.lsp.start({
						name = "qc_lsp",
						cmd = { "bun", "/Users/lilflare/github/lsp-tj/index.ts" },
					})
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(args)
					local opts = { buffer = args.buf, silent = true }
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					pcall(function()
						require("core.vtsls_tsdk").ensure(client, args.buf)
					end)

					if client and client.name == "vtsls" then
						opts.desc = "Go to source definition"
						keymap.set("n", "gd", "<cmd>VtsExec goto_source_definition<cr>", opts)
						return
					end

					local has_vtsls = #vim.lsp.get_clients({ bufnr = args.buf, name = "vtsls" }) > 0
					if not has_vtsls then
						opts.desc = "Go to definition"
						keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					end

					-- set keybinds
					opts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.implementation, opts) -- go to declaration

					opts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

					opts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>k", vim.diagnostic.open_float, opts) -- show diagnostics for line

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

					opts.desc = "Restart LSP"
					keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

					opts.desc = "Show LSP code actions"
					keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts) -- show code actions

					opts.desc = "Select typescript version"
					keymap.set("n", "<leader>cv", function()
						local clients = vim.lsp.get_clients({ name = "vtsls" })
						if clients[1] then
							clients[1]:exec_cmd({
								command = "typescript.selectTypeScriptVersion",
								title = "Select TypeScript Version",
							})
						end
					end, opts)
				end,
			})
		end,
	},
}
