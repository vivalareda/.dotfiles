return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "light" -- MUST be set before applying the colorscheme
    require("everforest").setup {
      background = "light", -- Optional; you can also set other options here
    }
    vim.cmd "colorscheme everforest"
  end,
}
