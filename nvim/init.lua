-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║  Neovim configuration — Kishore Newton                                     ║
-- ║  Modern modular setup on lazy.nvim · Neovim 0.11+/0.12 native LSP          ║
-- ║                                                                            ║
-- ║  Layout:                                                                   ║
-- ║    lua/config/   core editor settings (options, keymaps, autocmds, lsp)    ║
-- ║    lua/plugins/  one file per concern, auto-imported by lazy.nvim          ║
-- ║    lua/custom/   personal modules (cursor-trail, pdf viewer)               ║
-- ║    lsp/          native vim.lsp.config server definitions                  ║
-- ║    colors/       hackertheme (the original green-on-black aesthetic)       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Leader must be set before lazy.nvim and before any mapping is defined.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Mason-installed tools (language servers, formatters, debug adapters) live in
-- mason's bin directory, but mason.nvim itself loads lazily. Put that directory
-- on PATH up front so servers resolve even for the very first buffer nvim was
-- launched with (`nvim foo.lua` straight from a shell would otherwise get no
-- LSP: the FileType attach fires before mason's setup prepends the PATH).
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- Core editor behaviour (no plugins required).
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Bootstrap lazy.nvim and load every spec under lua/plugins/.
-- Native LSP wiring (config.lsp) is driven from the nvim-lspconfig spec's
-- config() — see lua/plugins/lsp.lua — so it runs once nvim-lspconfig's data
-- files are on the runtimepath. We deliberately do NOT require it here.
require('config.lazy')
