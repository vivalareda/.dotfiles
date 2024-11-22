return {
  'luckasRanarison/tailwind-tools.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
    'neovim/nvim-lspconfig', -- optional
  },
  config = function()
    require('tailwind-tools').setup {
      autocomplete = true,
    }
  end,
}
