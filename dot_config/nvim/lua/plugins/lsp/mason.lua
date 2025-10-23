-- Mason setup for installing and managing LSP servers
return {
  "williamboman/mason.nvim",

  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- Integrates Mason with LSPconfig
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- Mason setup
    require("mason").setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    -- Mason LSPconfig setup for managing LSP servers
    require("mason-lspconfig").setup {
      ensure_installed = {
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
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({})
        end,
        biome = function()
          require("lspconfig").biome.setup({
            capabilities = {
              positionEncodings = { 'utf-16' }
            }
          })
        end,
        vtsls = function()
          require('lspconfig').vtsls.setup({
            settings = {
              vtsls = {
                autoUseWorkspaceTsdk = true,
              }
            }
          })
        end,
        eslint = function()
          require('lspconfig').eslint.setup({
            flags = {
              allow_incremental_sync = false,
              debounce_text_changes = 1000,
            },
            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
              })
            end,
            root_dir = require("lspconfig.util").root_pattern(
              "eslint.config.mjs",
              "eslint.config.cjs",
              "eslint.config.js",
              ".eslintrc",
              ".eslintrc.js",
              "package.json"
            ),
            settings = {
              workingDirectory = { mode = "auto" },
            },
          })
        end,
      }
    }

    require("mason-tool-installer").setup {
      ensure_installed = {
        "prettier", -- prettier formatter
        -- "stylua", -- lua formatter
        -- "isort", -- python formatter
        -- "black", -- python formatter
        "eslint_d",
        -- "pylint",
        -- "tflint",
      },
    }
  end,
}
