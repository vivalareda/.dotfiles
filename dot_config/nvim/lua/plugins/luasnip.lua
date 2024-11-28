return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require "luasnip"

    -- Load existing friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Add your custom snippets here
    ls.add_snippets("lua", {
      ls.snippet("hello", {
        ls.text_node "Hello, World!",
      }),
    })
  end,
}
