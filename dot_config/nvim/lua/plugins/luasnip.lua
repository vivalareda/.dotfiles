return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require "luasnip"

    ls.setup {
      enable_autosnippets = true,
    }

    -- Load existing friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/snippets/" }
  end,
}
