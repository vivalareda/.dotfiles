-- LSP and Mason configuration
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local lspconfig = require "lspconfig"
    local mason = require "mason"
    local mason_lspconfig = require "mason-lspconfig"
    local mason_tool_installer = require "mason-tool-installer"
    local lsp_keymaps = require("core.keymaps").lsp_keymaps

    -- Mason setup
    mason.setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    -- Mason LSPConfig setup
    mason_lspconfig.setup {
      ensure_installed = {
        "pyright",
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "graphql",
        "emmet_ls",
        "prismals",
        "terraformls",
      },
    }

    -- Mason Tool Installer setup
    mason_tool_installer.setup {
      ensure_installed = {
        "prettier", -- Formatter
        "stylua", -- Lua formatter
        "isort", -- Python formatter
        "black", -- Python formatter
        "eslint_d", -- JavaScript/TypeScript linter
        "pylint", -- Python linter
        "tflint", -- Terraform linter
        "markdownlint", -- Markdown linter
      },
      auto_update = true, -- Automatically update tools
      run_on_start = true, -- Run installation/update on startup
    }

    -- Function to handle `on_attach` (for keybindings, etc.)
    local on_attach = function(client, bufnr)
      lsp_keymaps(bufnr)
    end

    -- Enhanced capabilities with cmp-nvim-lsp
    local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

    -- Automatically setup LSP servers installed by Mason
    mason_lspconfig.setup_handlers {
      -- Default handler for all servers
      function(server_name)
        lspconfig[server_name].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,

      -- Custom configuration for specific servers
      ["lua_ls"] = function()
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
      ["pyright"] = function()
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
      end,
    }
  end,
}
