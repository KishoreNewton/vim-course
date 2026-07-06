-- Git integration. gitsigns (signs + hunk actions + blame), fugitive (the
-- original :Git workflow), and diffview for rich diffs/history.
-- Lazygit lives in snacks.lua (<leader>gg).
return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- Signs preserved from the original config.
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      current_line_blame = false,
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      preview_config = { border = 'rounded' },
      on_attach = function(buffer)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
        end

        -- Navigation between hunks (respects diff mode).
        map('n', ']h', function()
          if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
        end, 'Next hunk')
        map('n', '[h', function()
          if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
        end, 'Prev hunk')

        -- Hunk actions.
        map({ 'n', 'v' }, '<leader>hs', '<cmd>Gitsigns stage_hunk<cr>', 'Stage hunk')
        map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', 'Reset hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
        map('n', '<leader>hd', gs.diffthis, 'Diff this')
        map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff this (cached)')
        -- Toggles.
        map('n', '<leader>htb', gs.toggle_current_line_blame, 'Toggle line blame')
        map('n', '<leader>htd', gs.toggle_deleted, 'Toggle deleted')
        -- Text object.
        map({ 'o', 'x' }, 'ih', '<cmd>Gitsigns select_hunk<cr>', 'Select hunk')
      end,
    },
  },

  -- The original :Git / :Gdiffsplit workflow.
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Gedit', 'Gclog' },
    keys = {
      { '<leader>gG', '<cmd>Git<cr>', desc = 'Fugitive status' },
      { '<leader>gp', '<cmd>Git push<cr>', desc = 'Git push' },
      { '<leader>gP', '<cmd>Git pull<cr>', desc = 'Git pull' },
    },
  },

  -- Rich diff & file-history viewer.
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
    -- File history on <leader>gf so <leader>gh stays the octo (GitHub) group.
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
      { '<leader>gF', '<cmd>DiffviewFileHistory<cr>', desc = 'Branch history' },
    },
    opts = { enhanced_diff_hl = true },
  },
}
