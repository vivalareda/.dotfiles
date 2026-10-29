-- Tab jumps past a closing bracket when the cursor sits right before one,
-- otherwise it drives snippet expansion/jumping, otherwise it is a plain Tab.
local M = {}

local closing_chars_forward = { "]", ")", "}", '"', "'", "`", ">", ";" }
local closing_chars_backward = { "[", "(", "{", '"', "'", "`", "<", ";" }

local function char_at(offset)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  return line:sub(cursor[2] + offset, cursor[2] + offset)
end

local function is_closing_char_forward()
  local next_char = char_at(1)
  return vim.tbl_contains(closing_chars_forward, next_char)
end

local function is_closing_char_backward()
  local prev_char = char_at(0)
  return vim.tbl_contains(closing_chars_backward, prev_char)
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

function M.setup()
  vim.keymap.set({ "i", "s" }, "<Tab>", function()
    local ls = require("luasnip")
    if is_closing_char_forward() then
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + 1 })
    elseif ls.expand_or_locally_jumpable() then
      ls.expand_or_jump()
    else
      feed("<Tab>")
    end
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    local ls = require("luasnip")
    if ls.locally_jumpable(-1) then
      ls.jump(-1)
    elseif is_closing_char_backward() then
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] - 1 })
    else
      feed("<S-Tab>")
    end
  end, { silent = true })
end

return M
