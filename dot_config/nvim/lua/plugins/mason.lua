return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }

    require("mason-lspconfig").setup {
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "terraformls",
      },
      handlers = {
        function(server_name)
          local capabilities = require("cmp_nvim_lsp").default_capabilities()
          if server_name == "pyright" then
            require("lspconfig")[server_name].setup {
              capabilities = capabilities,
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = "basic",
                  },
                },
              },
            }
          else
            require("lspconfig")[server_name].setup {
              capabilities = capabilities,
            }
          end
        end,
      },
    }

    require("mason-tool-installer").setup {
      ensure_installed = {
        "prettier",
        "stylua",
        "isort",
        "black",
        "eslint_d",
        "pylint",
        "tflint",
      },
    }
  end,
}
