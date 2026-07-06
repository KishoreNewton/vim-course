-- Smaller "must-have" extras that round out a top-tier 2026 config.
return {
  -- Session persistence per working directory (restore from the dashboard).
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore session (cwd)' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore last session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't save session" },
    },
  },

  -- Highlight colour codes (#rrggbb, names, etc.) inline — replaces ap/vim-css-color.
  {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = { render = 'virtual', virtual_symbol = '󰝤' },
  },
}
