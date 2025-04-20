vim.g.mapleader = " "

local keymap = vim.keymap.set

keymap("n", "<leader>nh", function()
  require("snacks").notifier.show_history()
end, { desc = "Show Notification History" })

-- keymap({ "i" }, "<Tab>", function()
--   local ls = require "luasnip"
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   else
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-n>", true, false, true), "n", false)
--   end
-- end, { silent = true })

-- Exit keymaps
keymap("n", "<leader>wq", ":wqa<CR>") -- save and quit
keymap("n", "<leader>qq", ":qa!<CR>") -- quit without saving
keymap("n", "<leader>ww", ":wa<CR>") -- save

-- Basic keymaps
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")
keymap("i", "jj", "<Esc>", { noremap = true, silent = true })
keymap("i", "JJ", "<Esc>", { noremap = true, silent = true })
keymap({ "o", "n", "v" }, "H", "^")
keymap({ "o", "n", "v" }, "L", "$")
keymap("v", "<leader>y", '"+y', { noremap = true, silent = true })
keymap("n", "<leader>v", '"+p', { noremap = true, silent = true })
keymap("n", "<CR>", "o<Esc>k", { noremap = true, silent = true })
keymap("n", "<leader>o", "O<Esc>j", { noremap = true, silent = true })
keymap("n", "C", "ciw", { noremap = true, silent = true })
keymap("n", "==", "ggvG=/", { noremap = true, silent = true })
keymap("n", "<leader>k", function()
  vim.diagnostic.open_float(nil, { severity = vim.diagnostic.severity.ERROR })
end, { desc = "open floating diagnostic" }, { noremap = true, silent = true })

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

-- Shortcut to use blackhole register by default
keymap("v", "c", '"_c', { noremap = true, silent = true })
keymap("n", "c", '"_c', { noremap = true, silent = true })

-- Add vertical mouvement to jumps
keymap("n", "j", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']], { noremap = true, expr = true })
keymap("n", "k", [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']], { noremap = true, expr = true })

-- Keymaps functions
keymap("n", "<leader>ya", function()
  local save_cursor = vim.fn.getpos "."
  vim.cmd 'normal! ggVG"+y'
  vim.fn.setpos(".", save_cursor)
end, { noremap = true, silent = true })

keymap("n", "==", function()
  local save_cursor = vim.fn.getpos "."
  vim.cmd "normal! gg=G"
  vim.fn.setpos(".", save_cursor)
end, { desc = "Indent whole file" }, { noremap = true, silent = true })

keymap("n", "<leader>ca", function()
  vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
  vim.cmd "startinsert"
end, { noremap = true, silent = true })

keymap("n", "dab", function()
  vim.cmd "normal! V%d"
end, { noremap = true, silent = true })

-- Copilot Keymaps
vim.keymap.set("i", "<C-R>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})

function ToggleCopilot()
  local status = vim.g.copilot_enabled
  if status == 1 then
    vim.cmd "Copilot disable"
    print "Copilot disabled"
  else
    vim.cmd "Copilot enable"
    print "Copilot enabled"
  end
end

keymap("n", "<leader>cpt", ToggleCopilot, { desc = "Toggle Copilot" }, { noremap = true, silent = true })
vim.g.copilot_no_tab_map = true

-- LSP Keymaps
local function lsp_keymaps(bufnr)
  local buf_opts = { noremap = true, silent = true, buffer = bufnr }
  keymap("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
    vim.defer_fn(function()
      vim.cmd "normal! zz"
    end, 100)
  end, vim.tbl_extend("force", buf_opts, { desc = "[G]oto [D]efinition and Center" }))
  keymap(
    "n",
    "gr",
    require("telescope.builtin").lsp_references,
    vim.tbl_extend("force", buf_opts, { desc = "[G]oto [R]eferences" })
  )
  keymap(
    "n",
    "gI",
    require("telescope.builtin").lsp_implementations,
    vim.tbl_extend("force", buf_opts, { desc = "[G]oto [I]mplementation" })
  )
  keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", buf_opts, { desc = "[R]e[n]ame" }))
  -- keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", buf_opts, { desc = "[C]ode [A]ction" }))
  keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", buf_opts, { desc = "Hover Documentation" }))
  keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", buf_opts, { desc = "[G]oto [D]eclaration" }))
  keymap(
    "n",
    "<leader>ds",
    require("telescope.builtin").lsp_document_symbols,
    vim.tbl_extend("force", buf_opts, { desc = "[D]ocument [S]ymbols" })
  )
  keymap(
    "n",
    "<leader>ws",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    vim.tbl_extend("force", buf_opts, { desc = "[W]orkspace [S]ymbols" })
  )
end

-- Super secret keymap
keymap("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain animation" })

return {
  lsp_keymaps = lsp_keymaps, -- Function for LSP keymaps to be used in `on_attach`
}
