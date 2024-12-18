local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require "luasnip.extras"
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
}
