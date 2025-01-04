return {
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
    config = function()
      require("spectre").setup()
    end,
  },
}
