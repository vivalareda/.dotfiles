-- LSP configuration
return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require('lspconfig')

    -- Function to handle `on_attach` (for keybindings, etc.)
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    end

    -- General LSP settings (capabilities, etc.)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Configure `pyright` (Python LSP)
    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Configure `lua_ls` (Lua LSP)
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }, -- Recognize `vim` as a global
          },
        },
      },
    })
  end,
}

