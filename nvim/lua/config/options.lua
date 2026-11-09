vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.autoread = true

-- Reload buffers changed on disk (e.g. by agents in other tmux panes)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("UserAutoread", {}),
	command = "silent! checktime",
})
