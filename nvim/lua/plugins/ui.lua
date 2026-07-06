-- UI layer: which-key, trouble, todo-comments, noice, grug-far.
-- (Statusline = lualine.lua, notifications/indent/dashboard = snacks.lua.)
return {
  -- which-key v3 — discoverable keybindings. Uses the modern opts.spec format.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      preset = 'helix',
      spec = {
        { '<leader>b', group = 'buffer' },
        { '<leader>B', group = 'database' },
        { '<leader>c', group = 'code' },
        { '<leader>cg', group = 'go' },
        { '<leader>cn', group = 'npm/package' },
        { '<leader>d', group = 'debug (DAP)' },
        { '<leader>dp', group = 'breakpoints' },
        { '<leader>f', group = 'find/file' },
        { '<leader>g', group = 'git' },
        { '<leader>gh', group = 'github (octo)' },
        { '<leader>h', group = 'git hunk' },
        { '<leader>H', group = 'http/rest' },
        { '<leader>m', group = 'multicursor' },
        { '<leader>o', group = 'obsidian' },
        { '<leader>r', group = 'refactor' },
        { '<leader>R', group = 'run/tasks' },
        { '<leader>s', group = 'split/search' },
        { '<leader>t', group = 'test' },
        { '<leader>u', group = 'ui/toggle' },
        { '<leader>w', group = 'window' },
        { '<leader>x', group = 'diagnostics/trouble' },
        { '<leader>y', group = 'yank' },
        { 'g', group = 'goto' },
        { ']', group = 'next' },
        { '[', group = 'prev' },
      },
    },
    keys = {
      {
        '<leader>?',
        function() require('which-key').show({ global = false }) end,
        desc = 'Buffer-local keymaps',
      },
    },
  },

  -- Trouble v3 — pretty diagnostics / references / symbols list.
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = { focus = true },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer diagnostics (Trouble)' },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP refs/defs (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix (Trouble)' },
      { '<leader>xt', '<cmd>Trouble todo toggle<cr>', desc = 'Todo (Trouble)' },
    },
  },

  -- todo-comments — highlight & navigate TODO/FIX/HACK/NOTE/WARN comments.
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
      { '[t', function() require('todo-comments').jump_prev() end, desc = 'Prev todo comment' },
      { '<leader>ft', function() Snacks.picker.todo_comments() end, desc = 'Todo comments' },
    },
  },

  -- grug-far — project-wide find & replace (replaced nvim-spectre in LazyVim).
  {
    'MagicDuck/grug-far.nvim',
    cmd = 'GrugFar',
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require('grug-far')
          local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
          grug.open({ transient = true, prefills = { filesFilter = ext and ext ~= '' and ('*.' .. ext) or nil } })
        end,
        mode = { 'n', 'v' },
        desc = 'Search & replace (project)',
      },
    },
  },

  -- noice — modern cmdline / messages / popupmenu UI. Uses snacks as the notify
  -- backend (no nvim-notify needed).
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      -- Use the classic NATIVE bottom command line and search, not noice's
      -- floating/centered box. We keep noice only for the nicer LSP hover/
      -- signature markdown and quieter message routing.
      cmdline = { enabled = false }, -- `:` commands use the native bottom line
      messages = { enabled = false }, -- let Neovim show messages normally (bottom)
      popupmenu = { enabled = false }, -- native wildmenu / blink for completion
      lsp = {
        -- Don't take over the cmdline; only improve hover/signature rendering.
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        -- bottom_search / command_palette removed: the native bottom line is used.
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
    keys = {
      { '<leader>sn', '<cmd>Noice<cr>', desc = 'Noice messages' },
      { '<leader>snl', function() require('noice').cmd('last') end, desc = 'Noice last message' },
      { '<leader>snh', function() require('noice').cmd('history') end, desc = 'Noice history' },
    },
  },
}
