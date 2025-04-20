local ls = require "luasnip"
local extras = require "luasnip.extras"
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = extras.rep

-- typescriptreact(.tsx) snippets
return {
  ls.add_snippets("typescriptreact", {
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
  }),

  ls.add_snippets("typescriptreact", {
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
  }),

  ls.add_snippets("typescriptreact", {
    s({ trig = "uE", snippetType = "autosnippet" }, {
      t "useEffect(() => {",
      t { "", "  " },
      i(1),
      t { "", "}" },
      t ", [",
      i(2),
      t "]);",
    }),
  }),

  ls.add_snippets("typescriptreact", {
    s({ trig = "print", snippetType = "autosnippet" }, {
      t "console.log(",
      i(1),
      t ");",
    }),
  }),

  ls.add_snippets("typescript", {
    s({ trig = "print", snippetType = "autosnippet" }, {
      t "console.log(",
      i(1),
      t ");",
    }),
  }),

  ls.add_snippets("typescript", {
    s("nextapi", {
      t 'import { NextRequest, NextResponse } from "next/server";',
      t "\n",
      t "export async function POST(req: NextRequest) {",
      t "  try {",
      t "    const body = await req.json();",
      t "    const { ",
      i(1, "data"), -- Data variable name
    }),
  }),

  ls.add_snippets("typescript", {
    s("ctor", {
      t "constructor(",
      f(function(_, snip)
        return snip.env.LS_SELECT_RAW
      end, {}),
      t ") {\n",
      f(function(_, snip)
        local params = snip.env.LS_SELECT_RAW:split ", "
        local assignments = {}
        for _, param in ipairs(params) do
          local name = param:match "(%w+):"
          if name then
            table.insert(assignments, "    this." .. name .. " = " .. name .. ";\n")
          end
        end
        return table.concat(assignments)
      end, {}),
      t "  }\n",
    }),
  }),
}
