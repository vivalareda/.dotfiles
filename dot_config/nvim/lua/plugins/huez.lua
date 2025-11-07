return {
  "vague2k/huez.nvim",
  -- if you want registry related features, uncomment this
  -- import = "huez-manager.import"
  branch = "stable",
  event = "UIEnter",
  config = function()
    require("huez").setup({})

    vim.keymap.set("n", "<leader>hu", function() require("huez.pickers").themes() end, { desc = "Open theme picker" })
  end,
}
