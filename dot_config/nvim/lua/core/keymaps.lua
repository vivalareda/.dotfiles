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
keymap("n", "p", '"0p', { noremap = true, silent = true })
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

-- lsp_map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
-- lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
-- lsp_map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
-- lsp_map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
-- lsp_map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
-- lsp_map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
-- lsp_map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
-- lsp_map("<leader>ac", vim.lsp.buf.code_action, "[C]ode [A]ction")
-- lsp_map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
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
