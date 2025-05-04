local ls = require "luasnip"
local c = ls.choice_node
local t = ls.text_node
local s = ls.snippet

ls.snippets = {
  all = {
    ls.parser.parse_snippet("lf", "local $1 = function($2) \n $0\nend"),
  },
}
