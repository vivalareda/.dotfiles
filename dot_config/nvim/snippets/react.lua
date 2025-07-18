local ls = require "luasnip"
local extras = require "luasnip.extras"
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = extras.rep

ls.add_snippets("typescriptreact", {
  s({ trig = "print", snippetType = "autosnippet" }, {
    t "console.log(",
    i(1),
    t ");",
  }),

  s({ trig = "ci", snippetType = "autosnippet" }, {
    t "console.info(",
    i(1),
    t ");",
  }),

  s("nextapi", {
    t 'import { NextRequest, NextResponse } from "next/server";',
    t { "", "" },
    t "export async function POST(req: NextRequest) {",
    t { "", "  try {" },
    t { "", "    const body = await req.json();" },
    t { "", "    const { " },
    i(1, "data"),
    t " } = body;",
    t { "", "    " },
    i(2, "// Your logic here"),
    t { "", "    return NextResponse.json({ success: true });" },
    t { "", "  } catch (error) {" },
    t { "", "    return NextResponse.json({ error: 'Something went wrong' }, { status: 500 });" },
    t { "", "  }" },
    t { "", "}" },
  }),

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

  s({ trig = "note", autosnippet = true }, {
    t "// NOTE: ",
    i(0)
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

  s({ trig = "uS", snippetType = "autosnippet" }, {
    t "const [",
    i(1),
    t ", set",
    f(function(args)
      return args[1][1]:gsub("^%l", string.upper)
    end, { 1 }),
    t "] = useState(",
    i(2),
    t ");",
  }),

  s({ trig = "uE", snippetType = "autosnippet" }, {
    t "useEffect(() => {",
    t { "", "  " },
    i(1),
    t { "", "}" },
    t ", [",
    i(2),
    t "]);",
  }),

  s("sfc", {
    t { "const " },
    i(1),
    t { " = () => {" },
    t { "", "  return (" },
    t { "", "    " },
    i(2, ""),
    t { "", "  );" },
    t { "", "};" },
    t { "", "", "export default " },
    rep(1),
    t { ";" },
  }),
})
