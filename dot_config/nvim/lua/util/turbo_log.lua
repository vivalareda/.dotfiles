-- Insert a console.log for the word under the cursor, matching indentation.
local M = {}

local function turbo_console_log()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local line_content = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
  local indent = line_content:match("^(%s*)") or ""
  local log_line = string.format("%sconsole.log(`%s is: ${%s}`)", indent, word, word)

  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { log_line })
end

function M.setup()
  vim.keymap.set("n", "<leader>cl", turbo_console_log, { desc = "Turbo console log" })
end

return M
