return {
  "echasnovski/mini.nvim",
  config = function()
    local spec_treesitter = require('mini.ai').gen_spec.treesitter
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

    require("mini.ai").setup {
      n_lines = 500,
      custom_textobjects = {
        f = spec_treesitter({ 
          a = { '@function.outer', '@lexical_declaration.outer' }, 
          i = { '@function.inner', '@lexical_declaration.inner' }
        }),
      },
    }
  end
}
