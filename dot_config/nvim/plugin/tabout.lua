local skip_closing_pairs = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- line number
  local col = cursor[2] -- column number
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  local closing_chars = { "]", ")", "}", '"', "'", "`", ">", ";" }
  local next_char = line:sub(col + 1, col + 1)
  for _, char in ipairs(closing_chars) do
    if next_char == char then
      vim.api.nvim_win_set_cursor(0, { row, col + 1 })
      return
    end
  end
end

vim.keymap.set("i", "<Tab>", function()
  skip_closing_pairs()
end, { silent = true })
