-- Extra autocommands on top of LazyVim's defaults.

-- Reload files changed outside Neovim as soon as the window regains focus
-- or the cursor rests, but never while typing a command.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("UserChecktime", { clear = true }),
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})
