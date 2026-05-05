require("core.options")
require("core.keymaps")
require("config.lazy")

vim.schedule(function()
	vim.filetype.add({
		extension = { qc = "qc" },
	})

	local parser_path = "/Users/lilflare/github/interpreter-presentation/language/tree-sitter-joual/joual.dylib"
	vim.treesitter.language.add("joual", {
		path = parser_path,
		symbol_name = "joual",
	})

	vim.treesitter.language.register("joual", "qc")
	-- Add queries to runtime path so nvim finds highlights.scm
	local query_path = "/Users/lilflare/github/interpreter-presentation/language/tree-sitter-joual"
	vim.opt.runtimepath:append(query_path)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "qc",
		callback = function(args)
			vim.treesitter.start(args.buf, "joual")
		end,
	})
end)
