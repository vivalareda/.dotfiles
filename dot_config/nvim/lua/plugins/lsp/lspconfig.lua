return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library",   words = { "vim%.uv" } },
            -- Add these to match your current config
            { path = vim.env.VIMRUNTIME },
            { path = "${3rd}/busted/library" },
          },
          -- Pass your existing lua_ls settings to lazydev
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              workspace = {
                checkThirdParty = false,
              }
            }
          },
        },
      },
    },
    config = function()
      local keymap = vim.keymap

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(args)
          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = args.buf, silent = true }
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- set keybinds
          opts.desc = "Go to declaration"
          keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

          opts.desc = "Go to definition"
          keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition

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

          -- if client.supports_method("textDocument/formatting") then
          --   opts.desc = "Format buffer"
          --   keymap.set("n", "<leader>fm", function()
          --     vim.lsp.buf.format({ async = true })
          --   end, opts)
          -- end
        end,
      })
    end,
  }
}
