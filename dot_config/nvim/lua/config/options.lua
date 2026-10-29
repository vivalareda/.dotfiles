-- Extra options on top of LazyVim's defaults.
-- Best, fastest source of truth: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- No UI animations (Snacks covers scroll, zoom, dim, indent, etc.).
vim.g.snacks_animate = false
opt.smoothscroll = false

-- Sessions
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Cursor and scrolling
opt.cursorline = true
opt.scrolloff = 8

-- Appearance
opt.background = "dark"
-- No bufferline/tabline at the top.
opt.showtabline = 0
vim.diagnostic.config({ float = { border = "rounded" } })

-- Editing
opt.backspace = "indent,eol,start"
opt.clipboard = "unnamedplus"
opt.iskeyword:append("-")
opt.conceallevel = 2
vim.g.netrw_liststyle = 3

-- Folds driven by treesitter
opt.foldlevel = 20
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Files
opt.undofile = true
opt.swapfile = false
opt.autoread = true
opt.updatetime = 250
