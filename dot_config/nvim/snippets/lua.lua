local ls = require "luasnip" -- LuaSnip API
local add_snippet = ls.snippet_node -- Add a snippet node
local c = ls.choice_node -- Choice node
local s = ls.snippet -- Create a snippet
local t = ls.text_node -- Plain text
local i = ls.insert_node -- Placeholder for cursor
local f = ls.function_node -- Function-generated text
local fmt = require("luasnip.extras.fmt").fmt

return {
  ls.add_snippets("lua", {
    ls.snippet("hw", {
      ls.text_node "Hello, World!",
    }),
  }),

  ls.add_snippets("lua", {
    s("todo", {
      c(1, {
        t "-- TODO: ",
        t "-- FIXME: ",
        t "-- HACK: ",
      }),
      i(0),
    }),

    s(
      "reqqq",
      fmt([[local {} = require "{}"]], {
        f(function(import_name)
          local parts = vim.split(import_name[1][1], ".", true)
          return parts[#parts] or ""
        end, { 1 }),
        i(1),
      })
    ),
  }),
}
