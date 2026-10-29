-- Personal keymaps. LazyVim loads its own keymaps on VeryLazy, then this file,
-- so anything here overrides a LazyVim default with the same lhs.

local map = vim.keymap.set

-- ---------------------------------------------------------------- notifications
map("n", "<leader>nh", function()
  require("snacks").notifier.show_history()
end, { desc = "Notification history" })

-- ---------------------------------------------------------------- files and windows
map("n", "<leader>wq", "<cmd>wqa<CR>", { desc = "Save all and quit" })
map("n", "<leader>qq", "<cmd>qa!<CR>", { desc = "Quit without saving" })
map("n", "<leader>ww", "<cmd>wa<CR>", { desc = "Save all" })
map("n", "<leader>qp", "<cmd>q<CR>", { desc = "Close window" })

-- ---------------------------------------------------------------- editing basics
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "diw", "daw", { noremap = true, silent = true })
map("i", "jk", "<Esc>", { noremap = true, silent = true })
map("i", "JK", "<Esc>", { noremap = true, silent = true })
map({ "o", "n", "v" }, "H", "^", { desc = "Start of line" })
map({ "o", "n", "v" }, "L", "$", { desc = "End of line" })
map("n", "<CR>", "o<Esc>k", { noremap = true, silent = true, desc = "Open line without insert" })
map("n", "<leader>o", "O<Esc>j", { noremap = true, silent = true, desc = "Open line above without insert" })
map("i", "<C-o>", "<Down>", { noremap = true, silent = true })
map("n", "<C-v>", "<C-q>", { noremap = true, silent = true, desc = "Blockwise insert" })

-- Delete/change without touching registers
map("v", "c", '"_c', { noremap = true, silent = true })
map("n", "c", '"_c', { noremap = true, silent = true })

-- Count-prefixed j/k also set a jumplist mark, so ctrl-o travels vertically.
map("n", "j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { noremap = true, expr = true })
map("n", "k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { noremap = true, expr = true })

-- ---------------------------------------------------------------- text objects
map("n", "dab", function()
  vim.cmd("normal! V%d")
end, { noremap = true, silent = true, desc = "Delete around brackets" })

map("n", "yab", function()
  vim.cmd("normal! V%y")
end, { noremap = true, silent = true, desc = "Yank around brackets" })

map("n", "<leader>ya", function()
  local cursor = vim.fn.getpos(".")
  vim.cmd('normal! ggVG"+y')
  vim.fn.setpos(".", cursor)
end, { desc = "Yank whole buffer" })

map("n", "<leader>ca", function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  vim.cmd("startinsert")
end, { desc = "Clear all lines and start insert" })

-- ---------------------------------------------------------------- yank keeps cursor
-- `y` normally jumps to the start of the yanked range; restore the cursor after.
local cursor_before_yank

map({ "n", "x" }, "y", function()
  cursor_before_yank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true })

map("n", "Y", function()
  cursor_before_yank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserRestoreCursorAfterYank", { clear = true }),
  callback = function()
    if vim.v.event.operator == "y" and cursor_before_yank then
      vim.api.nvim_win_set_cursor(0, cursor_before_yank)
      cursor_before_yank = nil
    end
  end,
})

-- ---------------------------------------------------------------- project helpers
map("n", "<leader>of", function()
  os.execute("open .")
end, { desc = "Reveal cwd in Finder" })

map("n", "<leader>rp", function()
  os.execute("repomix > /dev/null && rm -rf ignore/repomix-output.xml")
end, { desc = "Run repomix" })

map("n", "<leader>x", "<cmd>luafile %<CR>", { noremap = true, silent = true, desc = "Source current Lua file" })
map("n", "<leader>fb", function()
  require("conform").format({ async = true, lsp_format = "never" })
end, { desc = "Format buffer" })
map("n", "<leader>fa", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer with LSP" })

-- ---------------------------------------------------------------- telescope helpers
map("n", "<leader>vs", function()
  require("telescope.builtin").find_files({
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      actions.select_default:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("vsplit " .. selection.path)
        end
      end)
      return true
    end,
  })
end, { desc = "Find file in vertical split" })

-- ---------------------------------------------------------------- window navigation
-- Goes through tmux when the current window is a tmux pane.
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate right" })
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Navigate previous" })

-- ---------------------------------------------------------------- custom features
-- Each module owns one small editing behaviour and registers its own keymaps.
require("util.bool_switch").setup()
require("util.turbo_log").setup()
require("util.tabout").setup()
require("util.floaterm").setup()
