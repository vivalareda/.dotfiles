local ls = require "luasnip"
local extras = require "luasnip.extras"
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = extras.rep

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
}
