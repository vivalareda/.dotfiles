local ls = require "luasnip" -- LuaSnip API
local add_snippet = ls.snippet_node -- Add a snippet node
local s = ls.snippet -- Create a snippet
local t = ls.text_node -- Plain text
local i = ls.insert_node -- Placeholder for cursor
local f = ls.function_node -- Function-generated text

return {
  ls.add_snippets("lua", {
    ls.snippet("hw", {
      ls.text_node "Hello, World!",
    }),
  }),
}
