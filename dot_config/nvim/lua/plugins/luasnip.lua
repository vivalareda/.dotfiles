return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require "luasnip"

    ls.setup {
      enable_autosnippets = true,
      updateevents = "TextChanged,TextChangedI",
    }

    require("luasnip.loaders.from_lua").load { paths = "~/.config/nvim/snippets/" }

    vim.keymap.set({ "i", "n" }, "<C-k>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end)

    vim.keymap.set({ "i", "n" }, "<C-j>", function()
      if ls.choice_active() then
        ls.change_choice(-1)
      end
    end)
  end,
}
