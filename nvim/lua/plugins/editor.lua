-- Core editing experience: motions, surround, pairs, comments, text objects.
return {
  -- Surround (Lua, dot-repeatable, treesitter-aware) — replaces tpope/vim-surround.
  {
    'kylechui/nvim-surround',
    version = '^4.0.0',
    event = 'VeryLazy',
    opts = {},
  },

  -- Flash: jump anywhere with `s`, treesitter select with `S`.
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
  },

  -- Auto pairs.
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = { check_ts = true }, -- treesitter-aware; blink handles its own brackets
  },

  -- Fix native `gc` commentstring for embedded languages (JSX, Vue, …).
  -- Native gc/gcc already works (Neovim 0.10+); this only patches commentstring.
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
    enabled = vim.fn.has('nvim-0.10.0') == 1,
  },

  -- mini.nvim modules: text objects, move lines, split/join args.
  {
    'nvim-mini/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ a = { '@block.outer', '@conditional.outer', '@loop.outer' }, i = { '@block.inner', '@conditional.inner', '@loop.inner' } }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        },
      }
    end,
  },
  {
    'nvim-mini/mini.move',
    event = 'VeryLazy',
    opts = {
      mappings = {
        -- Alt+hjkl to move lines/selections (works in normal and visual).
        left = '<M-h>', right = '<M-l>', down = '<M-j>', up = '<M-k>',
        line_left = '<M-h>', line_right = '<M-l>', line_down = '<M-j>', line_up = '<M-k>',
      },
    },
  },
  {
    'nvim-mini/mini.splitjoin',
    keys = {
      { 'gS', function() require('mini.splitjoin').toggle() end, desc = 'Split/join args' },
    },
    opts = { mappings = { toggle = 'gS' } },
  },

  -- Yank ring with paste-history cycling.
  {
    'gbprod/yanky.nvim',
    event = 'VeryLazy',
    opts = {
      highlight = { timer = 200 },
    },
    keys = {
      { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put after (yanky)' },
      { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put before (yanky)' },
      { '<c-n>', '<Plug>(YankyCycleForward)', desc = 'Cycle forward through yank history' },
      { '<c-y>', '<Plug>(YankyCycleBackward)', desc = 'Cycle backward through yank history' },
    },
  },

  -- Undotree (replaces mbbill/undotree from the original config). On <leader>U
  -- because <leader>u is the ui/toggle which-key group prefix.
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<leader>U', '<cmd>UndotreeToggle<cr>', desc = 'Undo tree' },
    },
    config = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },

  -- Better quickfix window.
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    -- bqf defaults the preview float to winblend = 12. Over a dark theme that
    -- 12% blend lets the buffer underneath show THROUGH the preview, so the
    -- two layers interleave into unreadable phantom code (a stale VERSION /
    -- MAX_RETRIES appearing to duplicate on blank lines). Make it opaque.
    opts = { preview = { winblend = 0 } },
  },
}
