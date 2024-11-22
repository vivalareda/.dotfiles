return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    input = {
      enabled = true,
      default_prompt = "Input:",
      border = "rounded", -- Rounded borders for the floating window
      win_options = {
        winblend = 10, -- Transparency
        wrap = false, -- Disable line wrapping
      },
    },
    select = {
      enabled = true,
      backend = { "telescope", "builtin" }, -- Use Telescope if available
      telescope = require("telescope.themes").get_dropdown {},
      builtin = {
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },
    },
  },
}
