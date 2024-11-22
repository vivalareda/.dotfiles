vim.g.mapleader = " "

local keymap = vim.keymap.set

-- Exit keymaps
keymap("n", "<leader>wq", ":wqa<CR>") -- save and quit
keymap("n", "<leader>qq", ":qa!<CR>") -- quit without saving
keymap("n", "<leader>ww", ":w<CR>") -- save

-- Basic keymaps
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
keymap({ "o", "n", "v" }, "H", "^")
keymap({ "o", "n", "v" }, "L", "$")
keymap({ "n", "v" }, "c", '"_c')
keymap("v", "<leader>c", '"+y', { noremap = true, silent = true })
keymap("n", "<leader>v", '"+p', { noremap = true, silent = true })
keymap("n", "<CR>", "o<Esc>k", { noremap = true, silent = true })

-- Keymaps functions
keymap("n", "<leader>ya", function()
  vim.cmd 'normal! ggVG"+y'
end, { noremap = true, silent = true })

keymap("n", "<leader>ca", function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  vim.cmd "startinsert"
end, { noremap = true, silent = true })

-- Window Navigation
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Telescope Keymaps
local builtin = require "telescope.builtin"
keymap("n", "<leader>fh", builtin.help_tags, { desc = "[S]earch [H]elp" })
keymap("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
keymap("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
keymap("n", "<leader>fs", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
keymap("n", "<leader>fcw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
keymap("n", "<leader>fg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
keymap("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
keymap("n", "<leader>fr", builtin.resume, { desc = "[S]earch [R]esume" })
keymap("n", "<leader>f.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
keymap("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
keymap("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })
keymap("n", "<leader>s/", function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  }
end, { desc = "[S]earch [/] in Open Files" })
keymap("n", "<leader>fn", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "[S]earch [N]eovim files" })

-- LSP Keymaps
local lsp_map = function(keys, func, desc)
  keymap("n", keys, func, { desc = "LSP: " .. desc })
end

lsp_map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
lsp_map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
lsp_map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
lsp_map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
lsp_map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
lsp_map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
lsp_map("<leader>ac", vim.lsp.buf.code_action, "[C]ode [A]ction")
lsp_map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

-- Formatting Keymap
-- keymap({ "n", "v" }, "<leader>l", function()
--     require("conform").format({ async = true, lsp_format = "fallback" })
-- end, { desc = "[F]ormat buffer" })
