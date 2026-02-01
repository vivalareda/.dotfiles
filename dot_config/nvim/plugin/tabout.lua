local closing_chars_forward = { "]", ")", "}", '"', "'", "`", ">", ";" }
local closing_chars_backwards = { "[", "(", "{", '"', "'", "`", ">", ";" }

local skip_closing_pairs_forward = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- line number
  local col = cursor[2] -- column number
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  local next_char = line:sub(col + 1, col + 1)
  for _, char in ipairs(closing_chars_forward) do
    if next_char == char then
      vim.api.nvim_win_set_cursor(0, { row, col + 1 })
      return
    end
  end
  vim.api.nvim_feedkeys("\t", "n", true)
end

local skip_closing_pairs_backwards = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- line number
  local col = cursor[2] -- column number
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  local prev_char = line:sub(col, col)
  for _, char in ipairs(closing_chars_backwards) do
    if prev_char == char then
      vim.api.nvim_win_set_cursor(0, { row, col - 1 })
      return
    end
  end
  vim.api.nvim_feedkeys("\t", "n", true)
end

vim.keymap.set("i", "<Tab>", function()
  skip_closing_pairs_forward()
end, { silent = true })

vim.keymap.set("i", "<S-Tab>", function()
  skip_closing_pairs_backwards()
end, { silent = true })
