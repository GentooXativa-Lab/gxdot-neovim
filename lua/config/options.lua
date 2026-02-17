-- Core Neovim options
-- vim: ts=4 sts=4 sw=4 et

local opt = vim.opt

--

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cursorline = true
opt.wrap = false
opt.colorcolumn = "100"

-- Behavior
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse = "a"

-- File handling
opt.fileencoding = "utf-8"
opt.hidden = true
