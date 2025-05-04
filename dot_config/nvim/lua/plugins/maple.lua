return {
  "vivalareda/maple.nvim",
  config = function()
    require("maple").setup {
      relative_number = true,
      keymaps = {
        toggle = "<leader>m", -- Key to toggle Maple
        close = "q", -- Key to close the window
        switch_mode = "m", -- Key to switch between global and project view
      },
    }
  end,
}
