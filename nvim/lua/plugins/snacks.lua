-- folke/snacks.nvim — the 2026 QoL powerhouse. Bundles the fuzzy picker
-- (replaces Telescope), file explorer, dashboard, notifier, indent guides,
-- scroll/scope, statuscolumn, lazygit, terminal, and more.
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Startup & always-on UI.
    bigfile = { enabled = true }, -- disable heavy features in huge files
    quickfile = { enabled = true }, -- render the file before plugins load
    indent = { enabled = true }, -- indent guides + animated scope
    scope = { enabled = true }, -- text-object/jump by scope
    scroll = { enabled = true }, -- smooth scrolling
    statuscolumn = { enabled = true }, -- pretty fold/sign/number column
    words = { enabled = true }, -- LSP reference highlight + ]] navigation
    input = { enabled = true }, -- nicer vim.ui.input
    notifier = { enabled = true, timeout = 3000 }, -- vim.notify replacement
    picker = { enabled = true }, -- fuzzy finder (files/grep/lsp/git/…)
    -- File explorer stays available on <leader>fE, but it must NOT hijack netrw:
    -- the user wants plain netrw when opening a directory (replace_netrw = false).
    explorer = { enabled = true, replace_netrw = false },

    -- On-demand modules (active because opts are passed; invoked via keys/API).
    bufdelete = { enabled = true },
    git = { enabled = true },
    gitbrowse = { enabled = true },
    lazygit = { enabled = true },
    rename = { enabled = true }, -- LSP-aware file rename (used by neo-tree)
    scratch = { enabled = true },
    terminal = { enabled = true },
    toggle = { enabled = true },
    zen = { enabled = true },
    dim = { enabled = true },

    -- A dashboard with the green hacker aesthetic.
    dashboard = {
      enabled = true,
      preset = {
        header = [[
 ██╗  ██╗ █████╗  ██████╗██╗  ██╗███████╗██████╗
 ██║  ██║██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
 ███████║███████║██║     █████╔╝ █████╗  ██████╔╝
 ██╔══██║██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
 ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
 ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝]],
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = ' ', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },

    styles = {
      notification = { wo = { wrap = true } },
    },
  },
  keys = {
    -- ── Pickers (replace the original Telescope <C-p>/<C-l>/<C-t> maps) ──────
    { '<leader><space>', function() Snacks.picker.smart() end, desc = 'Smart find files' },
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep (live)' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fh', function() Snacks.picker.help() end, desc = 'Help tags' },
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    { '<leader>fc', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>fd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Grep word/selection', mode = { 'n', 'x' } },
    { '<leader>f:', function() Snacks.picker.command_history() end, desc = 'Command history' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },
    { '<leader>fR', function() Snacks.picker.resume() end, desc = 'Resume last picker' },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colourschemes' },
    -- Original muscle-memory: <C-p> buffers. (Live grep is <leader>fg; <C-l> is
    -- owned by smart-splits for navigate-right.)
    { '<C-p>', function() Snacks.picker.buffers() end, desc = 'Buffers' },

    -- ── Explorer ────────────────────────────────────────────────────────────
    -- The primary explorer is netrw (<leader>e / <leader>pv — see config/keymaps.lua,
    -- the user prefers netrw's features). The snacks explorer stays available here
    -- on <leader>fE for when a fuzzy/picker-style tree is wanted.
    { '<leader>fE', function() Snacks.explorer() end, desc = 'File explorer (snacks)' },

    -- ── Git ─────────────────────────────────────────────────────────────────
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gb', function() Snacks.gitbrowse() end, desc = 'Git browse (open in browser)', mode = { 'n', 'x' } },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git log' },
    { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git status' },

    -- ── Terminal (replaces vim-floaterm F7–F10) ─────────────────────────────
    { '<F7>', function() Snacks.terminal.toggle() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
    { '<c-/>', function() Snacks.terminal.toggle() end, desc = 'Toggle terminal', mode = { 'n', 't' } },

    -- ── Misc ────────────────────────────────────────────────────────────────
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete buffer' },
    { '<leader>bD', function() Snacks.bufdelete.all() end, desc = 'Delete all buffers' },
    { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle scratch buffer' },
    { '<leader>S', function() Snacks.scratch.select() end, desc = 'Select scratch buffer' },
    { '<leader>z', function() Snacks.zen() end, desc = 'Zen mode' },
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification history' },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss notifications' },
    { '<leader>cR', function() Snacks.rename.rename_file() end, desc = 'Rename file' },
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev reference', mode = { 'n', 't' } },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Expose handy debug globals and toggle mappings.
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end

        Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
        Snacks.toggle.diagnostics():map('<leader>ud')
        Snacks.toggle.line_number():map('<leader>ul')
        Snacks.toggle.treesitter():map('<leader>uT')
        Snacks.toggle.inlay_hints():map('<leader>uh')
        Snacks.toggle.indent():map('<leader>ug')
        Snacks.toggle.dim():map('<leader>uD')
        Snacks.toggle
          .option('background', { off = 'light', on = 'dark', name = 'Dark Background' })
          :map('<leader>ub')
      end,
    })
  end,
}
