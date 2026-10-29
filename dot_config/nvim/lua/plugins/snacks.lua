-- LazyVim enables Snacks' scroll/animate effects by default. Turn them off;
-- vim.g.snacks_animate = false in config/options.lua covers the animate module.
return {
  {
    "folke/snacks.nvim",
    opts = {
      animate = { enabled = false },
      scroll = { enabled = false },
      -- LazyVim's native indent provider (Snacks). Dots instead of the
      -- default │ bars, matching the previous indent-blankline look.
      indent = {
        enabled = true,
        char = "⋅",
        scope = { char = "⋅", underline = true },
      },
    },
  },
}
