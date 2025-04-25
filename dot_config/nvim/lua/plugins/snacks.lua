return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = { enabled = true },
    picker = { enabled = true },
  },
  keys = {
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments()
      end,
      desc = "Todo",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.todo_comments { keywords = { "TODO", "FIX", "FIXME" } }
      end,
      desc = "Todo/Fix/Fixme",
    },
  },
}
