vim.g.mapleader = " "

local keymap = vim.keymap.set

keymap("n", "<leader>nh", function()
  require("snacks").notifier.show_history()
end, { desc = "Show Notification History" })

keymap("n", "<leader>wq", ":wqa<CR>") -- save and quit
keymap("n", "<leader>qq", ":qa!<CR>") -- quit without saving
keymap("n", "<leader>ww", ":wa<CR>")  -- save

-- Basic keymaps
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
keymap("i", "JJ", "<Esc>", { noremap = true, silent = true })
keymap({ "o", "n", "v" }, "H", "^")
keymap({ "o", "n", "v" }, "L", "$")
keymap("n", "<CR>", "o<Esc>k", { noremap = true, silent = true })
keymap("n", "<leader>o", "O<Esc>j", { noremap = true, silent = true })

-- Unbind default 's' behavior for flash.nvim
vim.keymap.set("n", "s", "<Nop>", { noremap = true, silent = true })

keymap("n", "<leader>fa", function()
  vim.lsp.buf.format()
end, { noremap = true, silent = true })

keymap("n", "<leader>x", function()
  vim.cmd "luafile %"
end, { noremap = true, silent = true })

-- Shortcut to use blackhole register by default
keymap("v", "c", '"_c', { noremap = true, silent = true })
keymap("n", "c", '"_c', { noremap = true, silent = true })

-- Add vertical mouvement to jumps
keymap("n", "j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { noremap = true, expr = true })
keymap("n", "k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { noremap = true, expr = true })

keymap("n", "<leader>ya", function()
  local save_cursor = vim.fn.getpos "."
  vim.cmd 'normal! ggVG"+y'
  vim.fn.setpos(".", save_cursor)
end, { noremap = true, silent = true })

keymap("n", "<leader>ca", function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  vim.cmd "startinsert"
end, { noremap = true, silent = true, desc = "Clear all lines and start insert mode" })

keymap("n", "dab", function()
  vim.cmd "normal! V%d"
end, { noremap = true, silent = true, desc = "Delete all brackets" })

keymap("n", "yab", function()
  vim.cmd "normal! V%y"
end, { noremap = true, silent = true, desc = "Yank all brackets" })


-- Yanking keymap to save cursor position
local cursorPreYank
vim.keymap.set({ "n", "x" }, "y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true })

keymap("n", "Y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and cursorPreYank then
      vim.api.nvim_win_set_cursor(0, cursorPreYank)
      cursorPreYank = nil -- Clear the saved position after restoring it
    end
  end,
})

local open_split_view = function()
  require("telescope.builtin").find_files {
    attach_mappings = function(prompt_bufnr, map)
      require("telescope.actions").select_default:replace(function()
        require("telescope.actions").close(prompt_bufnr)
        local selection = require("telescope.actions.state").get_selected_entry()
        if selection then
          vim.cmd("vsplit " .. selection.path)
        end
      end)
      return true
    end,
  }
end

keymap("n", "<leader>vs", open_split_view, { desc = "Open split view" }) -- Open split view with telescope
