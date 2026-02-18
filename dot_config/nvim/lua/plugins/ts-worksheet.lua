return {
	"typed-rocks/ts-worksheet-neovim",
	config = function()
		require("tsw").setup({
			severity = vim.diagnostic.severity.WARN,
		})

		local tsw_enabled = false

		local function toggle_tsw()
			tsw_enabled = not tsw_enabled
			if tsw_enabled then
				vim.cmd("Tsw")
				vim.api.nvim_create_autocmd("BufWritePost", {
					group = vim.api.nvim_create_augroup("TswAutoRun", { clear = true }),
					pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
					callback = function()
						vim.cmd("Tsw")
					end,
				})
			else
				vim.api.nvim_create_augroup("TswAutoRun", { clear = true })
				vim.diagnostic.reset()
			end
		end

		vim.keymap.set("n", "<leader>tw", toggle_tsw, { desc = "Toggle TSW" })
	end,
}
