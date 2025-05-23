return {
  "echasnovski/mini.nvim",
  config = function ()
    require("mini.icons").setup {
      lazy = true,
      opts = {
        file = {
          [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
          ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        },
        filetype = {
          dotenv = { glyph = "", hl = "MiniIconsYellow" },
        },
      },
    }

    require("mini.ai").setup { n_lines = 500 }
  end
}
