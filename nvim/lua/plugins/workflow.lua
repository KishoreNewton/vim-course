-- Everyday-workflow upgrades. All non-AI, each filling a distinct gap.
return {
  -- ── Smart increment/decrement: <C-a>/<C-x> that understands bools, dates,
  --    hex, semver, &&↔||, and/or. Reuses the native keys (no which-key noise).
  {
    'monaqa/dial.nvim',
    keys = {
      { '<C-a>', function() require('dial.map').manipulate('increment', 'normal') end, mode = 'n', desc = 'Increment' },
      { '<C-x>', function() require('dial.map').manipulate('decrement', 'normal') end, mode = 'n', desc = 'Decrement' },
      { '<C-a>', function() require('dial.map').manipulate('increment', 'visual') end, mode = 'v', desc = 'Increment' },
      { '<C-x>', function() require('dial.map').manipulate('decrement', 'visual') end, mode = 'v', desc = 'Decrement' },
      { 'g<C-a>', function() require('dial.map').manipulate('increment', 'gvisual') end, mode = 'v', desc = 'Increment (sequential)' },
      { 'g<C-x>', function() require('dial.map').manipulate('decrement', 'gvisual') end, mode = 'v', desc = 'Decrement (sequential)' },
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias['%Y-%m-%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { '&&', '||' }, word = false }),
          augend.constant.new({ elements = { 'and', 'or' } }),
          augend.constant.new({ elements = { 'True', 'False' } }),
          augend.constant.new({ elements = { 'yes', 'no' } }),
        },
      })
    end,
  },

  -- ── Seamless split + multiplexer (tmux/wezterm/kitty/zellij) navigation,
  --    directional resize, and buffer swapping. Owns <C-hjkl> and <A-hjkl>.
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    opts = {
      at_edge = 'stop',
      default_amount = 3,
      cursor_follows_swapped_bufs = true,
      ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
    },
    keys = {
      { '<C-h>', function() require('smart-splits').move_cursor_left() end, desc = 'Move to left split' },
      { '<C-j>', function() require('smart-splits').move_cursor_down() end, desc = 'Move to lower split' },
      { '<C-k>', function() require('smart-splits').move_cursor_up() end, desc = 'Move to upper split' },
      { '<C-l>', function() require('smart-splits').move_cursor_right() end, desc = 'Move to right split' },
      { '<A-h>', function() require('smart-splits').resize_left() end, desc = 'Resize split left' },
      { '<A-j>', function() require('smart-splits').resize_down() end, desc = 'Resize split down' },
      { '<A-k>', function() require('smart-splits').resize_up() end, desc = 'Resize split up' },
      { '<A-l>', function() require('smart-splits').resize_right() end, desc = 'Resize split right' },
      { '<leader>wh', function() require('smart-splits').swap_buf_left() end, desc = 'Swap buffer left' },
      { '<leader>wj', function() require('smart-splits').swap_buf_down() end, desc = 'Swap buffer down' },
      { '<leader>wk', function() require('smart-splits').swap_buf_up() end, desc = 'Swap buffer up' },
      { '<leader>wl', function() require('smart-splits').swap_buf_right() end, desc = 'Swap buffer right' },
    },
  },

  -- ── Window picker: overlay a letter on each window for instant jumps. Also the
  --    "open in window" target used by the explorer.
  {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    version = '2.*',
    event = 'VeryLazy',
    opts = {
      hint = 'floating-big-letter',
      filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        bo = { filetype = { 'neo-tree', 'neo-tree-popup', 'notify', 'snacks_dashboard' }, buftype = { 'terminal', 'quickfix' } },
      },
    },
    keys = {
      {
        '<leader>wp',
        function()
          local win = require('window-picker').pick_window()
          if win then
            vim.api.nvim_set_current_win(win)
          end
        end,
        desc = 'Pick window',
      },
    },
  },

  -- ── Positional file jumper (Harpoon-style). Complements the fuzzy picker:
  --    `;` opens the jump menu; pinned files are always one keystroke away.
  --    leader_key/buffer_leader_key must be single characters (not <leader> notation).
  --    `M` is used for per-buffer bookmarks so the raw `m` mark command is untouched.
  {
    'otavioschwanck/arrow.nvim',
    dependencies = { 'nvim-mini/mini.icons' },
    event = 'VeryLazy',
    opts = {
      show_icons = true,
      leader_key = ';', -- open the arrow bookmark menu (flash supersedes ; for repeat-find)
      buffer_leader_key = 'M', -- per-buffer bookmarks (capital M; raw m untouched)
    },
  },

  -- ── Sticky scroll: keep the enclosing function/class/if context pinned at the
  --    top of the window. (snacks `scope` only highlights — this is real context.)
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      max_lines = 3,
      min_window_height = 20,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
      separator = '─',
      zindex = 20,
    },
    keys = {
      { '[x', function() require('treesitter-context').go_to_context(vim.v.count1) end, desc = 'Jump to context' },
      { '<leader>ux', '<cmd>TSContextToggle<cr>', desc = 'Toggle sticky context' },
    },
  },

  -- ── Refactoring: extract function/variable, inline, extract block — operations
  --    LSP rename/code-action don't provide. Picker routes through snacks.
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = { 'lewis6991/async.nvim' },
    keys = {
      { '<leader>re', function() require('refactoring').refactor('Extract Function') end, mode = 'x', desc = 'Extract function' },
      { '<leader>rF', function() require('refactoring').refactor('Extract Function To File') end, mode = 'x', desc = 'Extract function to file' },
      { '<leader>rv', function() require('refactoring').refactor('Extract Variable') end, mode = 'x', desc = 'Extract variable' },
      { '<leader>rI', function() require('refactoring').refactor('Inline Variable') end, mode = { 'n', 'x' }, desc = 'Inline variable' },
      { '<leader>rb', function() require('refactoring').refactor('Extract Block') end, mode = 'n', desc = 'Extract block' },
      { '<leader>rr', function() require('refactoring').select_refactor() end, mode = { 'n', 'x' }, desc = 'Select refactor' },
    },
    config = function()
      require('refactoring').setup({})
    end,
  },

  -- ── Interactive colour picker/editor (sliders, format conversion). Distinct
  --    from nvim-highlight-colors, which only displays swatches.
  {
    'uga-rosa/ccc.nvim',
    cmd = { 'CccPick', 'CccConvert' },
    keys = {
      { '<leader>cp', '<cmd>CccPick<cr>', desc = 'Colour picker' },
      { '<leader>cv', '<cmd>CccConvert<cr>', desc = 'Colour convert' },
    },
    opts = { highlighter = { auto_enable = false } },
  },

  -- ── Symbol outline panel (table-of-contents for big files). The snacks picker
  --    covers jump-to-symbol; this is the always-visible sidebar.
  {
    'hedyhli/outline.nvim',
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { { '<leader>cs', '<cmd>Outline<cr>', desc = 'Symbol outline' } },
    opts = {
      outline_window = { position = 'right', width = 25, auto_close = true },
      outline_items = { show_symbol_details = true, auto_set_cursor = true },
      symbol_folding = { autofold_depth = 1 },
    },
  },

  -- ── Task runner: discover & run make/npm/cargo/just/vscode-tasks, parse errors
  --    into quickfix, and orchestrate neotest/DAP tasks.
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerOpen', 'OverseerQuickAction', 'OverseerInfo' },
    -- Under <leader>R (tasks/Run) so it never collides with <leader>o (obsidian).
    keys = {
      { '<leader>Rr', '<cmd>OverseerRun<cr>', desc = 'Overseer: run task' },
      { '<leader>Rt', '<cmd>OverseerToggle<cr>', desc = 'Overseer: toggle list' },
      { '<leader>Ra', '<cmd>OverseerQuickAction<cr>', desc = 'Overseer: quick action' },
      { '<leader>Ri', '<cmd>OverseerInfo<cr>', desc = 'Overseer: info' },
    },
    opts = {
      strategy = 'terminal',
      templates = { 'builtin' },
      -- Free <C-h>/<C-l> in the task list for smart-splits navigation.
      task_list = { direction = 'bottom', bindings = { ['<C-l>'] = false, ['<C-h>'] = false } },
    },
  },
}
