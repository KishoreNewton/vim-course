-- init.lua — as of Section 13 (vim-plug + Mason + native LSP)
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
Plug('mason-org/mason.nvim')
Plug('mason-org/mason-lspconfig.nvim')
Plug('neovim/nvim-lspconfig')
vim.call('plug#end')

vim.cmd("colorscheme hackertheme")
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, {desc="File explorer"})
vim.api.nvim_set_option("clipboard", "unnamedplus")
require("myconfig")

require('mason').setup()
require('mason-lspconfig').setup({ensure_installed = {'lua_ls'}})

vim.lsp.config('lua_ls', {settings = {Lua = {diagnostics = {globals = {'vim'}}}}})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {desc="LSP hover"})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {desc="Go to definition"})
vim.keymap.set("n", "gr", vim.lsp.buf.references, {desc="Find references"})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {desc="Rename symbol"})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {desc="Next diagnostic"})
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {desc="Previous diagnostic"})
