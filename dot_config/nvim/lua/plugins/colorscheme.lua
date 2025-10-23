return {
  "neanias/everforest-nvim",
  version = false,
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark" -- MUST be set before applying the colorscheme
    require("everforest").setup({
      background = "medium",  -- Optional; you can also set other options here
      show_eob = false,
    })
    vim.cmd "colorscheme everforest"
  end,
}
