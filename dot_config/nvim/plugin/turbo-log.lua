local function turbo_console_log()
	-- Get the word under cursor
	local word = vim.fn.expand("<cword>")

	if word == "" then
		vim.notify("No word under cursor", vim.log.levels.WARN)
		return
	end

	-- Get current line info
	local current_line = vim.api.nvim_win_get_cursor(0)[1]

	-- Get the indentation of current line
	local line_content = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
	local indent = line_content:match("^(%s*)") or ""

	-- Create the console.log line
	local log_line = string.format("%sconsole.log(`%s is: ${%s}`)", indent, word, word)

	-- Insert below current line
	vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { log_line })
end

vim.keymap.set("n", "<leader>cl", turbo_console_log, { desc = "Turbo Console Log" })
