return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fb",
        function()
          require("conform").format({ async = true, lsp_format = "never" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local lsp_format_opt = "fallback"
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
          stop_after_first = false,
        }
      end,
      formatters_by_ft = {
        javascript = { "biome", "biome-organize-imports" },
        javascriptreact = { "biome", "biome-organize-imports" },
        typescript = { "biome", "biome-organize-imports" },
        typescriptreact = { "biome", "biome-organize-imports" },
      },
    },
  },
  -- {
  --   "y3owk1n/tailwind-autosort.nvim",
  --   version = "*", -- remove this if you want to follow `main` branch
  --   event = "VeryLazy",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   ---@type TailwindAutoSort.Config
  --   opts = {
  --     enable_autocmd = true,
  --     notify_line_changed = true,
  --   } -- your configuration
  -- }
}
