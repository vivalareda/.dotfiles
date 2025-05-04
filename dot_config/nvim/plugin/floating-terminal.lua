vim.keymap.set("t", "<C-q>", "<C-\\><C-n>")

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  -- Get screen dimensions
  local screen_width = vim.api.nvim_get_option "columns"
  local screen_height = vim.api.nvim_get_option "lines"
  -- Calculate default dimensions (80% of screen)
  local default_width = math.floor(screen_width * 0.8)
  local default_height = math.floor(screen_height * 0.8)
  -- Determine window dimensions
  local win_width = opts.width or default_width
  local win_height = opts.height or default_height
  -- Calculate position to center the window
  local win_col = math.floor((screen_width - win_width) / 2)
  local win_row = math.floor((screen_height - win_height) / 2)
  -- Create a new buffer for the floating window
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end
  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = win_row,
    col = win_col,
    width = win_width,
    height = win_height,
    border = "rounded", -- Or any other border style you prefer
    focusable = true,
    style = "minimal",
  })

  return { win = win, buf = buf }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.term()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "Toggle floating terminal" })
