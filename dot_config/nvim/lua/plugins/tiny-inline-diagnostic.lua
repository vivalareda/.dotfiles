return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "LspAttach", -- Or `LspAttach`
  priority = 1000, -- needs to be loaded in first
  config = function()
    require("tiny-inline-diagnostic").setup {
      preset = "powerline",
      overflow = {
        mode = "wrap",
      },
      multiple_diag_under_cursor = false,
      multilines = {
        enabled = true,
        always_show = false,
      },
    }
  end,
}
