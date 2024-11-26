return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    left = { -- Panels on the right side of the screen
      {
        title = "Copilot Chat",
        ft = "CopilotChat", -- Match CopilotChat's filetype
        size = function()
          return math.floor(vim.o.columns / 2) -- 1/3 of the total screen width
        end,
      },
      options = {
        animate = true,
      },
    },
  },
}
