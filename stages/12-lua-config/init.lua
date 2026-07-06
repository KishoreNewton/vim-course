-- init.lua — as built in Section 12 (Lua configuration)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8

vim.g.mapleader = " "

vim.cmd("colorscheme hackertheme")

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, {desc="File explorer"})

vim.api.nvim_set_option("clipboard", "unnamedplus")

require("myconfig")
