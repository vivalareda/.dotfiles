local ls = require "luasnip"
local c = ls.choice_node
local t = ls.text_node
local s = ls.snippet

ls.snippets = {
  all = {
    ls.parser.parse_snippet("lf", "local $1 = function($2) \n $0\nend"),
  },
}

local function get_visual_selection()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    vim.notify("Not in visual mode", vim.log.levels.ERROR)
    return ""
  end

  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  -- nvim_buf_get_text uses 0-indexed positions
  local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
  local end_row, end_col = end_pos[2] - 1, end_pos[3]

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})

  return table.concat(lines, "\n")
end

vim.keymap.set("v", "<leader>l", function()
  local text = get_visual_selection()
  vim.notify("Selected text: " .. text, vim.log.levels.INFO)
end, { noremap = true, silent = true })
