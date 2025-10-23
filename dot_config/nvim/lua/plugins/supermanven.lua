return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      disable_inline_completion = false,
      disable_keymaps = false,
      keymaps = {
        accept_suggestion = "<C-l>"
      }
    })

    vim.keymap.set("n", "<leader>ts", function()
      require("supermaven-nvim.api").toggle()
    end, { desc = "Toggle Supermaven" })
  end,
}
