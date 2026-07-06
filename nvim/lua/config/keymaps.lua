-- Global keymaps. Plugin-specific maps live with their plugin spec (keys = …).
-- Leader is <Space>. We deliberately do NOT redefine Neovim 0.11+ built-in LSP
-- maps (grn/gra/grr/gri/grt/gO/K/<C-S>) or native gc commenting — those are set
-- in lua/config/lsp.lua only where a default is missing (e.g. gd).
local map = vim.keymap.set

-- ── Quality-of-life ─────────────────────────────────────────────────────────
-- Clear search highlight / close floats with Esc.
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- Save / quit. (<leader>w is the window group; save is <C-s>, the modern idiom.)
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>write<cr><esc>', { desc = 'Save file' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit window' })
map('n', '<leader>Q', '<cmd>qall<cr>', { desc = 'Quit all' })

-- Better up/down on wrapped lines.
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Keep cursor centred on big jumps and search results.
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centred)' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centred)' })
map('n', 'n', 'nzzzv', { desc = 'Next search result (centred)' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result (centred)' })

-- Keep the yank register when pasting over a visual selection.
map('x', '<leader>p', [["_dP]], { desc = 'Paste without yanking selection' })
-- Delete to the black hole register (don't clobber the clipboard).
-- On <leader>D (capital): <leader>d is the debug/DAP group.
map({ 'n', 'x' }, '<leader>D', [["_d]], { desc = 'Delete (black hole)' })

-- Move selected lines up/down, re-indenting (J/K in visual mode).
map('x', 'J', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('x', 'K', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Stay in visual mode while indenting.
map('x', '<', '<gv', { desc = 'Indent left (keep selection)' })
map('x', '>', '>gv', { desc = 'Indent right (keep selection)' })

-- Join lines but keep the cursor put.
map('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })

-- ── Window navigation / resize ──────────────────────────────────────────────
-- <C-hjkl> (move) and <A-hjkl> (resize) are owned by smart-splits.nvim (see
-- lua/plugins/workflow.lua), which makes them seamless across tmux/wezterm/kitty
-- panes too. Arrow-key resize is kept here as a non-conflicting fallback.
map('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
map('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
map('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
map('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Split management.
map('n', '<leader>sv', '<C-w>v', { desc = 'Split vertically' })
map('n', '<leader>sh', '<C-w>s', { desc = 'Split horizontally' })
map('n', '<leader>se', '<C-w>=', { desc = 'Equalise splits' })
map('n', '<leader>sx', '<cmd>close<cr>', { desc = 'Close split' })

-- ── Buffers ─────────────────────────────────────────────────────────────────
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to other buffer' })
-- <leader>bd (delete buffer keeping the window) is provided by snacks.bufdelete.

-- ── File explorer: netrw (preferred) ────────────────────────────────────────
-- netrw is the primary explorer. <leader>pv keeps the original muscle memory
-- (project view); <leader>e opens netrw in the current window. The snacks
-- explorer is on <leader>fE and neo-tree on <leader>E if a tree is wanted.
map('n', '<leader>pv', '<cmd>Explore<cr>', { desc = 'Explorer (netrw)' })
map('n', '<leader>e', '<cmd>Explore<cr>', { desc = 'Explorer (netrw)' })
map('n', '<leader>E', '<cmd>Lexplore<cr>', { desc = 'Explorer side panel (netrw)' })

-- ── Diagnostics (the [d / ]d / <C-W>d defaults already exist in 0.11+) ───────
-- Line diagnostics live on <leader>cd (see lua/config/lsp.lua); loclist dump here.
map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Diagnostics → loclist' })

-- ── Utilities (ported from the original config) ─────────────────────────────
-- F2 copied the absolute file path; keep it, plus a leader alias.
map('n', '<F2>', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  vim.notify('Yanked path: ' .. path)
end, { desc = 'Yank absolute file path' })
map('n', '<leader>yp', '<F2>', { remap = true, desc = 'Yank absolute file path' })

-- Toggle the custom cursor trail (lua/custom/cursor-trail.lua).
map('n', '<leader>ut', function()
  require('custom.cursor-trail').toggle()
end, { desc = 'Toggle cursor trail' })
