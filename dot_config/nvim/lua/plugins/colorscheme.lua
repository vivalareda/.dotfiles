return {
  {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('nordic').load()
    end
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 999,
    config = function()
      vim.o.background = "dark" -- MUST be set before applying the colorscheme
      require("everforest").setup({
        background = "medium",  -- Optional; you can also set other options here
        show_eob = false,
      })
      vim.cmd "colorscheme everforest"
    end,
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 999,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme('gruvbox-material')
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 999,
    opts = {},
  }
}
