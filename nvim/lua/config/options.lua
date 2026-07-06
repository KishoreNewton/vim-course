-- Editor options. Ported and modernised from the original init.vim.
local opt = vim.opt
local g = vim.g

-- ── UI ──────────────────────────────────────────────────────────────────────
opt.termguicolors = true -- 24-bit colour (required by modern themes)
opt.number = true -- absolute line numbers …
opt.relativenumber = true -- … plus relative, for fast motions
opt.signcolumn = "yes" -- always show sign column (no text jitter)
opt.cursorline = true -- highlight the current line
-- Solid block cursor in every mode (insert/replace included), no blink.
-- Requires a terminal that honours cursor-shape escapes (kitty/wezterm/foot/etc).
opt.guicursor = "n-v-c-i-ci-ve-r-cr-o-sm:block-blinkon0"
opt.scrolloff = 8 -- keep context around the cursor (was 0; 8 is nicer)
opt.sidescrolloff = 8
opt.wrap = false -- no soft wrapping
opt.laststatus = 3 -- single global statusline (lualine globalstatus)
opt.showmode = false -- mode is shown in the statusline instead
opt.cmdheight = 1
opt.pumheight = 12 -- cap completion popup height
opt.winborder = "rounded" -- 0.11+: global rounded borders for all float windows
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below
opt.splitkeep = "screen" -- keep text stable when opening/closing splits
-- Single-cell glyphs only (0.11+ enforces width==1 for fillchars fields).
opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " ", diff = "╱" }
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.wrap = true

-- ── Indentation ─────────────────────────────────────────────────────────────
opt.expandtab = true -- spaces, not tabs
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true -- round indent to a multiple of shiftwidth
opt.smartindent = true
opt.breakindent = true -- wrapped lines keep their indent (if wrap is on)

-- ── Search ──────────────────────────────────────────────────────────────────
opt.ignorecase = true -- case-insensitive …
opt.smartcase = true -- … unless the query has uppercase
opt.incsearch = true
opt.hlsearch = false -- don't keep matches highlighted after searching
opt.inccommand = "split" -- live preview for :substitute

-- ── Files / persistence ─────────────────────────────────────────────────────
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true -- persistent undo …
opt.undodir = vim.fn.stdpath("state") .. "/undo" -- … in the standard state dir
opt.autowriteall = true -- auto-save modified buffers (original behaviour)
opt.confirm = true -- prompt instead of failing on unsaved changes

-- ── Behaviour ───────────────────────────────────────────────────────────────
opt.mouse = "a" -- mouse in all modes
opt.mousemoveevent = true -- needed for hover/bufferline mouse interactions
opt.clipboard = "unnamedplus" -- use the system clipboard
opt.updatetime = 200 -- faster CursorHold / swap write (original used 100)
opt.timeoutlen = 400 -- mapped-sequence timeout (was 1000; snappier which-key)
opt.ttimeoutlen = 0 -- no delay for key codes
opt.completeopt = "menu,menuone,noselect" -- modern completion behaviour
opt.virtualedit = "block" -- let visual-block selections past line ends
opt.formatoptions = "jcroqlnt" -- sensible auto-format rules
opt.shortmess:append("Isc") -- quieter messages (no intro, no ins-completion menu)
opt.belloff = "all"
opt.errorbells = false

-- ── Folding (treesitter-powered; see plugins/treesitter.lua) ────────────────
opt.foldlevel = 99 -- start with everything unfolded
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldcolumn = "0" -- snacks statuscolumn renders fold markers

-- ── netrw (the preferred file explorer) ─────────────────────────────────────
-- netrw stays enabled and is the primary explorer (<leader>e / <leader>pv /
-- <leader>E). These settings make it pleasant to use.
g.netrw_sort_by = "exten" -- sort by file extension
g.netrw_banner = 0 -- hide the top help banner (gh / I toggles it back)
g.netrw_liststyle = 3 -- tree-style listing
g.netrw_winsize = 25 -- side panel (:Lexplore) takes 25% width
g.netrw_browse_split = 0 -- open files in the same window (4 = previous window)
g.netrw_altv = 1 -- vertical splits open to the right
g.netrw_keepdir = 0 -- keep the browsing dir synced with the current file
g.netrw_localcopydircmd = "cp -r" -- recursive copy for directories
g.netrw_sizestyle = "H" -- human-readable file sizes (e.g. 4K)
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]] -- hide dotfiles by default (gh toggles)
g.netrw_hide = 1

g.markdown_recommended_style = 0

-- Disable a handful of built-in plugins we don't use, for a faster startup.
-- NOTE: netrwPlugin is deliberately NOT disabled — netrw is the file explorer.
for _, plugin in ipairs({ "gzip", "tarPlugin", "zipPlugin", "tutor" }) do
	g["loaded_" .. plugin] = 1
end
