local ls = require "luasnip"
local extras = require "luasnip.extras"
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = extras.rep

ls.add_snippets("typescript", {
  s("ctor", {
    t "constructor(",
    f(function(_, snip)
      return snip.env.LS_SELECT_RAW or ""
    end, {}),
    t ") {",
    t { "", "  " },
    f(function(_, snip)
      local raw = snip.env.LS_SELECT_RAW or ""
      if raw == "" then return "" end

      local params = vim.split(raw, ",")
      local assignments = {}
      for _, param in ipairs(params) do
        local trimmed = vim.trim(param)
        local name = trimmed:match "([%w_]+)%s*:"
        if name then
          table.insert(assignments, "this." .. name .. " = " .. name .. ";")
        end
      end
      return table.concat(assignments, "\n  ")
    end, {}),
    t { "", "}" },
  }),

  s("todo", {
    c(1, {
      t "// TODO: ",
      t "// FIXME: ",
      t "// HACK: ",
    }),
    i(0),
  }),

  s({ trig = "note", snippetType = 'autosnippet' }, {
    t "// NOTE: ",
    i(0)
  }),

  s({ trig = 'yield ', snippetType = 'autosnippet' }, {
    t "yield*"
  }),

  s({ trig = 'Effect.gen()', snippetType = 'autosnippet' }, fmt([[
    Effect.gen(function* () {{
      {}
    }})
    ]], {
    i(1)
  }))
})
