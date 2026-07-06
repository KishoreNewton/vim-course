-- Test runner (neotest) — still the 2026 standard. Adapters: Go (neotest-golang,
-- NOT the deprecated neotest-go), Python, Vitest. Rust comes through rustaceanvim
-- (NOT the archived neotest-rust); run Rust tests with `:RustLsp testables` too.
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fredrikaverpil/neotest-golang',
    'nvim-neotest/neotest-python',
    'marilari88/neotest-vitest',
    'mrcjkb/rustaceanvim', -- provides require('rustaceanvim.neotest')
  },
  keys = {
    { '<leader>tn', function() require('neotest').run.run() end, desc = 'Test: nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Test: file' },
    { '<leader>ta', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Test: suite' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Test: last' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test: summary panel' },
    { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Test: output float' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Test: output panel' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Test: watch file' },
    { '<leader>tS', function() require('neotest').run.stop() end, desc = 'Test: stop' },
    { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Test: debug nearest (DAP)' },
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-golang'),
        require('neotest-python'),
        require('neotest-vitest'),
        require('rustaceanvim.neotest'),
      },
      status = { virtual_text = true },
      output = { open_on_run = false },
    })
  end,
}
