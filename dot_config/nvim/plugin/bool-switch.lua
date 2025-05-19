local function switch_bool()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- line number
  local word = vim.fn.expand "<cword>"
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
  if word == "true" then
    local index = line:find "true"
    vim.api.nvim_set_current_line(line:sub(1, index - 1) .. "false" .. line:sub(index + 4))
  elseif word == "false" then
    local index = line:find "false"
    vim.api.nvim_set_current_line(line:sub(1, index - 1) .. "true" .. line:sub(index + 5))
  end
end

vim.keymap.set("n", "<leader>bs", function()
  switch_bool()
end, { desc = "Switch boolean" })
