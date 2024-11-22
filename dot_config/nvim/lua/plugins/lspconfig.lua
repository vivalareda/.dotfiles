-- LSP configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local lspconfig = require "lspconfig"

    -- Function to handle `on_attach` (for keybindings, etc.)
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end

    -- General LSP settings (capabilities, etc.)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Configure `pyright` (Python LSP)
    lspconfig.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    }

    -- Configure `lua_ls` (Lua LSP)
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }, -- Recognize `vim` as a global
          },
        },
      },
    }
  end,
}
