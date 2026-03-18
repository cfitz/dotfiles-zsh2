-- Leader key must be set before Lazy is loaded
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Core options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.textwidth = 100
vim.opt.colorcolumn = "100"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.encoding = "utf-8"

-- Core keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Escape with jk
map("i", "jk", "<Esc>", opts)

-- Clear search highlight on Enter
map("n", "<CR>", ":nohlsearch<CR>", opts)

-- Line diagnostics
map("n", "gl", vim.diagnostic.open_float, opts)

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Bootstrap Lazy.nvim
require("config.lazy")
