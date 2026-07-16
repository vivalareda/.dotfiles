return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				style = {
					{ fg = "#806d9c" },
				},
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				require("hlchunk").setup({
					chunk = {
						enable = true,
						style = {
							{ fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Comment")), "fg", "gui") },
						},
					},
				})
			end,
		})
	end,
}
