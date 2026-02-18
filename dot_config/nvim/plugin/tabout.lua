local ls = require("luasnip")

local closing_chars_forward = { "]", ")", "}", '"', "'", "`", ">", ";" }
local closing_chars_backwards = { "[", "(", "{", '"', "'", "`", "<", ";" }

local function is_closing_char_forward()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
	local next_char = line:sub(cursor[2] + 1, cursor[2] + 1)
	for _, char in ipairs(closing_chars_forward) do
		if next_char == char then
			return true
		end
	end
	return false
end

local function is_closing_char_backward()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
	local prev_char = line:sub(cursor[2], cursor[2])
	for _, char in ipairs(closing_chars_backwards) do
		if prev_char == char then
			return true
		end
	end
	return false
end

vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if ls.expand_or_locally_jumpable() then
		ls.expand_or_jump()
	elseif is_closing_char_forward() then
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if ls.locally_jumpable(-1) then
		ls.jump(-1)
	elseif is_closing_char_backward() then
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] - 1 })
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
	end
end, { silent = true })
