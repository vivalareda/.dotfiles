local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Define the snippet
return {
  ls.add_snippets("javascriptreact", {
    s("cln", {
      t 'className="',
      i(1),
      t '"',
    }),
  }),
}
