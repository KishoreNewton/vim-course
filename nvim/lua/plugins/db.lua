-- Database client (vim-dadbod + UI + completion) and REST/HTTP client (kulala).
-- Dadbod: best non-AI SQL client for Postgres/MySQL/SQLite — no compiled backend,
-- and blink completion via the vim_dadbod_completion.blink module.
return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    -- Under <leader>B (dataBase) so it never collides with <leader>b (buffers)
    -- or <leader>D (black-hole delete).
    keys = {
      { '<leader>Bu', '<cmd>DBUIToggle<cr>', desc = 'Database UI (toggle)' },
      { '<leader>Bf', '<cmd>DBUIFindBuffer<cr>', desc = 'Database: find buffer' },
      { '<leader>Ba', '<cmd>DBUIAddConnection<cr>', desc = 'Database: add connection' },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      -- Define connections via vim.g.dbs or a connections.json (keep it out of git):
      --   vim.g.dbs = { dev = 'postgres://user:pass@localhost:5432/dev' }
    end,
  },

  -- REST/HTTP client for .http files. kulala is the actively-maintained 2026 pick
  -- (daily commits, native 0.12, no luarocks). Needs curl + tree-sitter CLI (present).
  {
    'mistweaverco/kulala.nvim',
    ft = { 'http', 'rest' },
    -- Under <leader>H (Http) so it doesn't collide with <leader>R (overseer tasks).
    keys = {
      { '<leader>Hs', function() require('kulala').run() end, ft = { 'http', 'rest' }, desc = 'HTTP: send request' },
      { '<leader>Ha', function() require('kulala').run_all() end, ft = { 'http', 'rest' }, desc = 'HTTP: send all' },
      { '<leader>Ht', function() require('kulala').toggle_view() end, ft = { 'http', 'rest' }, desc = 'HTTP: toggle body/headers' },
      { '<leader>Hc', function() require('kulala').copy() end, ft = { 'http', 'rest' }, desc = 'HTTP: copy as curl' },
      { '<leader>Hp', function() require('kulala').jump_prev() end, ft = { 'http', 'rest' }, desc = 'HTTP: previous request' },
      { '<leader>Hn', function() require('kulala').jump_next() end, ft = { 'http', 'rest' }, desc = 'HTTP: next request' },
    },
    opts = {
      global_keymaps = false,
      default_view = 'body',
      display_mode = 'split',
    },
  },
}
