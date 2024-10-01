require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local nomap = vim.keymap.del

local hop = require('hop')
local directions = require('hop.hint').HintDirection
local builtin = require('telescope.builtin')

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map({ "o", "n", "v" }, "H", "^")
map({ "o", "n", "v" }, "L", "$")
map("v", "<leader>c", '"+y', { noremap = true, silent = true })
map("n", "<leader>v", '"+p', { noremap = true, silent = true })

map("n", "<leader><CR>", "o<Esc>", { noremap = true, silent = true })
map("n", "<CR>", "o<Esc>k", { noremap = true, silent = true })
map("n", "<S-CR>", "O<Esc>j", { noremap = true, silent = true })
map("n", "<C-p>", builtin.find_files, {})
-- map('n', "<leader>i",function()
--   vim.api.nvim_feedkeys("gg=G''", "n", true)
-- end, { noremap = true, silent = true })

-- Unset Neovim's default window navigation
vim.api.nvim_set_keymap("n", "<C-w>h", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>j", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>k", "", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>l", "", { noremap = true, silent = true })

-- Tmux navigator mappings
vim.api.nvim_set_keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", { noremap = true, silent = true })

vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
