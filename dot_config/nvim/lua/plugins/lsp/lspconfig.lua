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
        -- "pyright",
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "graphql",
        "prismals",
        "terraformls",
        "yamlls",
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
      -- ["pylsp"] = function()
      --   lspconfig.pylsp.setup {
      --     on_attach = on_attach,
      --     capabilities = capabilities,
      --     settings = {
      --       pylsp = {
      --         plugins = {
      --           rope_rename = { enabled = false },
      --           pycodestyle = { enabled = false }, -- Disable pycodestyle
      --           flake8 = { enabled = false }, -- Disable flake8
      --           pylint = { enabled = true }, -- Enable pylint
      --           black = { enabled = true }, -- Enable black
      --           isort = { enabled = true }, -- Enable isort
      --         },
      --       },
      --     },
      --   }
      -- end,
      ["pyright"] = function()
        lspconfig.pyright.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            python = {
              analysis = {
                diagnosticSeverityOverrides = {
                  reportUnknownMemberType = "none",
                  reportAttributeAccessIssue = "none", -- Add this line
                },
              },
            },
          },
        }
      end,
      ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = {
                disabled = { "unused" },
              },
            },
          },
        }
      end,
      ["yamlls"] = function()
        lspconfig.yamlls.setup {
          on_attach = on_attach,
          capabilities = capabilities,
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
              },
              schemas = {
                ["https://d1uauaxba7bl26.cloudfront.net/latest/gzip/CloudFormationResourceSpecification.json"] = {
                  "cloud-formation-*.yaml",
                  "cloud-formation-*.yml",
                  "*.cf.yaml",
                  "*.cf.yml",
                  "cloudformation/*.yaml",
                  "cloudformation/*.yml",
                },
              },
              customTags = {
                "!And scalar",
                "!And mapping",
                "!And sequence",
                "!If scalar",
                "!If mapping",
                "!If sequence",
                "!Not scalar",
                "!Not mapping",
                "!Not sequence",
                "!Equals scalar",
                "!Equals mapping",
                "!Equals sequence",
                "!Or scalar",
                "!Or mapping",
                "!Or sequence",
                "!FindInMap scalar",
                "!FindInMap mapping",
                "!FindInMap sequence",
                "!Base64 scalar",
                "!Base64 mapping",
                "!Base64 sequence",
                "!Cidr scalar",
                "!Cidr mapping",
                "!Cidr sequence",
                "!Ref scalar",
                "!Ref mapping",
                "!Ref sequence",
                "!Sub scalar",
                "!Sub mapping",
                "!Sub sequence",
                "!GetAtt scalar",
                "!GetAtt mapping",
                "!GetAtt sequence",
                "!GetAZs scalar",
                "!GetAZs mapping",
                "!GetAZs sequence",
                "!ImportValue scalar",
                "!ImportValue mapping",
                "!ImportValue sequence",
                "!Select scalar",
                "!Select mapping",
                "!Select sequence",
                "!Split scalar",
                "!Split mapping",
                "!Split sequence",
                "!Join scalar",
                "!Join mapping",
                "!Join sequence",
              },
            },
          },
        }
      end,
    }
  end,
}
