-- A single floating terminal that survives being hidden and reopened.
local M = {}

local state = {
  buf = -1,
  win = -1,
}

local function create_window(buf)
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines
  local width = math.floor(screen_width * 0.8)
  local height = math.floor(screen_height * 0.8)

  return vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((screen_height - height) / 2),
    col = math.floor((screen_width - width) / 2),
    width = width,
    height = height,
    border = "rounded",
    focusable = true,
    style = "minimal",
  })
end

local function toggle()
  if not vim.api.nvim_win_is_valid(state.win) then
    if not vim.api.nvim_buf_is_valid(state.buf) then
      state.buf = vim.api.nvim_create_buf(false, true)
    end
    state.win = create_window(state.buf)
    if vim.bo[state.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
    vim.cmd.startinsert()
  else
    vim.api.nvim_win_hide(state.win)
  end
end

local function close()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
  else
    vim.cmd("nohlsearch")
  end
end

function M.setup()
  vim.api.nvim_create_user_command("Floaterminal", toggle, {})
  vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
  vim.keymap.set({ "n", "t" }, "<leader>tt", toggle, { desc = "Toggle floating terminal" })
  vim.keymap.set({ "n", "t" }, "<Esc>", close, { desc = "Close floating terminal" })
end

return M
