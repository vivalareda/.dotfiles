return {
	"shrynx/line-numbers.nvim",
	opts = {},
	config = function()
		require("line-numbers").setup({ mode = "relative" })
		local is_both = false
		vim.keymap.set("n", "<leader>ln", function()
			if is_both then
				vim.cmd("LineNumberRelative")
			else
				vim.cmd("LineNumberBoth")
			end
			is_both = not is_both
		end, { desc = "Toggle line numbers" })
	end,
}
