-- Formatting through conform.nvim. LazyVim provides the plugin and the
-- format-on-save wiring; these are the project's formatters.
return {
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      -- Format-on-save is driven by LazyVim (vim.g.autoformat, <leader>uf).
      formatters_by_ft = {
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
        json = { "oxfmt" },
        jsonc = { "oxfmt" },
        markdown = { "oxfmt" },
        css = { "oxfmt" },
        scss = { "oxfmt" },
        html = { "oxfmt" },
        yaml = { "oxfmt" },
        go = { "gofumpt", "goimports" },
        lua = { "stylua" },
        rust = { "rustfmt", "maudfmt", lsp_format = "fallback" },
      },
      formatters = {
        maudfmt = {
          command = "maudfmt",
          args = { "-s" },
        },
      },
    },
  },
}
