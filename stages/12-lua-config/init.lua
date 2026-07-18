-- init.lua — as built in Section 12 (Lua configuration + vim-plug in Lua)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8

vim.g.mapleader = " "

local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/pack')
Plug('tpope/vim-surround')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('lewis6991/gitsigns.nvim')
vim.call('plug#end')

vim.cmd("colorscheme hackertheme")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, {desc="File explorer"})

vim.api.nvim_set_option("clipboard", "unnamedplus")

require("myconfig")
