-- Dashboard: LazyVim supplies alpha-nvim; this swaps in the personal banner
-- and buttons.
local headers = require("custom.dashboard_headers")

return {
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      math.randomseed(os.time())
      opts.section.header.val = headers[math.random(#headers)]

      opts.section.buttons.val = {
        opts.button("Leader ff", "􀈷  > Find File", "<cmd>Telescope find_files<CR>"),
        opts.button("Leader fw", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
        opts.button("r", "􀣔  > Restore Session", "<cmd>SessionRestore<CR>"),
        opts.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
      }
      for _, button in ipairs(opts.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      opts.section.header.opts.hl = "AlphaHeader"
      opts.section.buttons.opts.hl = "AlphaButtons"
      opts.section.footer.opts.hl = "AlphaFooter"

      return opts
    end,
  },
}
