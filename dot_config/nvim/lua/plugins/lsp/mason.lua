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
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "graphql",
        "prismals",
        "pyright",
        "terraformls",
      },
    }

    require("mason-tool-installer").setup {
      ensure_installed = {
        -- "prettier", -- prettier formatter
        -- "stylua", -- lua formatter
        -- "isort", -- python formatter
        -- "black", -- python formatter
        -- "eslint_d",
        -- "pylint",
        -- "tflint",
      },
    }
  end,
}
