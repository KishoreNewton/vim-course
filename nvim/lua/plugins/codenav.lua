-- Structural navigation and advanced editing.
return {
  -- ── Treewalker: move the cursor by AST structure (parent/sibling) and SWAP
  --    sibling nodes (reorder args/list items, comments preserved). Orthogonal to
  --    flash (label jump) and mini.ai (textobjects).
  --    Moves on <M-arrows> so they don't clash with mini.move's <M-hjkl> (lines).
  {
    'Aaronik/treewalker.nvim',
    opts = { highlight = true, highlight_duration = 250 },
    keys = {
      { '<M-Up>', '<cmd>Treewalker Up<cr>', mode = { 'n', 'v' }, desc = 'Treewalker up (AST)' },
      { '<M-Down>', '<cmd>Treewalker Down<cr>', mode = { 'n', 'v' }, desc = 'Treewalker down (AST)' },
      { '<M-Left>', '<cmd>Treewalker Left<cr>', mode = { 'n', 'v' }, desc = 'Treewalker out (AST)' },
      { '<M-Right>', '<cmd>Treewalker Right<cr>', mode = { 'n', 'v' }, desc = 'Treewalker in (AST)' },
      { '<leader>K', '<cmd>Treewalker SwapUp<cr>', desc = 'Swap node up (AST)' },
      { '<leader>J', '<cmd>Treewalker SwapDown<cr>', desc = 'Swap node down (AST)' },
    },
  },

  -- ── actions-preview: show a DIFF of what each LSP code action changes before
  --    applying. Overrides the native `gra` (which only lists titles). snacks UI.
  {
    'aznhe21/actions-preview.nvim',
    event = 'LspAttach',
    opts = { backend = { 'snacks' } },
    -- gra (the native code-action key) is overridden here to preview diffs.
    -- <leader>ca is handled by the LspAttach map in config/lsp.lua (which calls
    -- actions-preview when present), so it isn't duplicated here.
    keys = {
      { 'gra', function() require('actions-preview').code_actions() end, mode = { 'n', 'v' }, desc = 'Code action (preview)' },
    },
  },

  -- ── Multi-cursor (modern, Lua-native). Lowest-confidence add of the batch —
  --    grug-far already handles bulk edits — but invaluable for interactive
  --    multi-cursor editing. Under <leader>m and <C-q> (both previously free).
  {
    'jake-stewart/multicursor.nvim',
    branch = '1.0',
    event = 'VeryLazy',
    config = function()
      local mc = require('multicursor-nvim')
      mc.setup()
      local set = vim.keymap.set

      -- Add/skip cursors by matching the word/selection under the cursor.
      set({ 'n', 'x' }, '<leader>mn', function() mc.matchAddCursor(1) end, { desc = 'MC: add next match' })
      set({ 'n', 'x' }, '<leader>mN', function() mc.matchAddCursor(-1) end, { desc = 'MC: add prev match' })
      set({ 'n', 'x' }, '<leader>ms', function() mc.matchSkipCursor(1) end, { desc = 'MC: skip next match' })
      set({ 'n', 'x' }, '<leader>mA', mc.matchAllAddCursors, { desc = 'MC: add all matches' })
      -- Add cursors vertically.
      set({ 'n', 'x' }, '<leader>mj', function() mc.lineAddCursor(1) end, { desc = 'MC: add cursor down' })
      set({ 'n', 'x' }, '<leader>mk', function() mc.lineAddCursor(-1) end, { desc = 'MC: add cursor up' })
      -- Toggle a cursor at the current position, and operate on cursors.
      set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'MC: toggle cursor here' })
      set('n', '<leader>mr', mc.restoreCursors, { desc = 'MC: restore cursors' })

      -- Layered Esc: clear cursors first, otherwise fall through to normal Esc.
      set('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- preserve the default <Esc> (clears search highlight, see keymaps.lua)
          vim.cmd('nohlsearch')
        end
      end)

      -- Bring back common bindings while multiple cursors are active.
      mc.addKeymapLayer(function(layer)
        layer({ 'n', 'x' }, '<left>', mc.prevCursor)
        layer({ 'n', 'x' }, '<right>', mc.nextCursor)
        layer({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'MC: delete cursor' })
        layer('n', '<esc>', mc.clearCursors)
      end)
    end,
  },

  -- ── Precognition: show available motions as inline hints (great alongside
  --    which-key/flash). Off by default (always-on is noisy); toggle with <leader>up.
  {
    'tris203/precognition.nvim',
    keys = {
      { '<leader>up', '<cmd>Precognition toggle<cr>', desc = 'Toggle precognition hints' },
    },
    opts = { startVisible = false },
  },

  -- ── DAP breakpoint UI: a real menu for conditional / log / hit-count
  --    breakpoints and exception filters (dap makes you use raw vim.ui.input).
  --    virtual_text disabled so it doesn't clash with dap-view's inline display.
  --    NOTE: dap-breakpoints hard-requires persistent-breakpoints.nvim (it
  --    require()s persistent-breakpoints.api internally) — declaring it here both
  --    fixes the load error and gives us breakpoints that survive restarts.
  {
    'Carcuis/dap-breakpoints.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      {
        'Weissle/persistent-breakpoints.nvim',
        opts = { load_breakpoints_event = { 'BufReadPost' } },
      },
    },
    keys = {
      { '<leader>dpc', function() require('dap-breakpoints.api').set_conditional_breakpoint() end, desc = 'DAP: conditional breakpoint' },
      { '<leader>dpl', function() require('dap-breakpoints.api').set_log_point() end, desc = 'DAP: log point' },
      { '<leader>dph', function() require('dap-breakpoints.api').set_hit_condition_breakpoint() end, desc = 'DAP: hit-condition breakpoint' },
      { '<leader>dpr', function() require('dap-breakpoints.api').reveal_all_breakpoints() end, desc = 'DAP: reveal all breakpoints' },
    },
    opts = {
      virtual_text = { enabled = false },
    },
  },
}
