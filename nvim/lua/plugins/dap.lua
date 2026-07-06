-- Debugging via DAP. Single-window UI is nvim-dap-view (the 2026 pick over the
-- now-stale dap-ui). Adapters: Go (delve), Python (debugpy). Rust is handled by
-- rustaceanvim — do NOT add a Rust DAP adapter or put codelldb in ensure_installed;
-- use `:RustLsp debuggables` (mapped to <leader>dr in lang.lua) instead.
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'igorlfs/nvim-dap-view',
      { 'jay-babu/mason-nvim-dap.nvim', dependencies = { 'mason-org/mason.nvim' } },
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
    },
    -- NB: each key closure requires the module lazily (NOT at the top of a
    -- keys=function block) — requiring dap at spec-build time would make lazy
    -- consider the plugin loaded and skip config(), leaving adapters unregistered.
    keys = {
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP: toggle breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'DAP: conditional breakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'DAP: continue / start' },
      { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'DAP: run to cursor' },
      { '<leader>do', function() require('dap').step_over() end, desc = 'DAP: step over' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'DAP: step into' },
      { '<leader>dO', function() require('dap').step_out() end, desc = 'DAP: step out' },
      { '<leader>du', function() require('dap-view').toggle() end, desc = 'DAP: toggle UI' },
      { '<leader>dE', function() require('dap-view').toggle({ section = 'repl' }) end, desc = 'DAP: toggle REPL' },
      { '<leader>dL', function() require('dap').run_last() end, desc = 'DAP: run last' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'DAP: terminate' },
      { '<leader>dh', function() require('dap.ui.widgets').hover() end, mode = { 'n', 'v' }, desc = 'DAP: hover value' },
    },
    config = function()
      local dap = require('dap')
      local dv = require('dap-view')

      -- Keep this minimal and schema-valid: an invalid key makes dv.setup() throw,
      -- which would abort config() before the adapters below get registered.
      -- (The valid key is windows.size, not windows.height.)
      dv.setup({
        winbar = { default_section = 'scopes' },
      })

      -- Register the language adapters FIRST so debugging works even if Mason
      -- (network) is slow or unavailable. dap-go → delve, dap-python → debugpy.
      require('dap-go').setup()
      local py = vim.fn.exepath('python3')
      if py == '' then
        py = 'python3'
      end
      require('dap-python').setup(py)

      -- mason.nvim is already set up by the LSP spec; this ensures the debug
      -- adapter binaries are installed. Wrapped so a Mason hiccup can't abort the
      -- adapter registration above.
      pcall(function()
        require('mason-nvim-dap').setup({
          -- python → debugpy, delve → Go, codelldb → C/C++ (Rust stays with
          -- rustaceanvim). js-debug-adapter is installed separately (see below)
          -- because mason-nvim-dap's 'js' maps to the dead node2 adapter.
          ensure_installed = { 'python', 'delve', 'codelldb' },
          automatic_installation = true,
          handlers = {
            function(config)
              require('mason-nvim-dap').default_setup(config)
            end,
            -- codelldb auto-configures c/cpp/rust/swift/zig by default; restrict it
            -- to C/C++ so it doesn't inject a config into dap.configurations.rust
            -- (rustaceanvim owns Rust debugging).
            codelldb = function(config)
              config.filetypes = { 'c', 'cpp' }
              require('mason-nvim-dap').default_setup(config)
            end,
          },
        })
      end)

      -- ── JavaScript / TypeScript / Node (pwa-node via vscode-js-debug) ────────
      -- nvim-dap-vscode-js is abandoned (last release 2022) and mason-nvim-dap's
      -- 'js' maps to the dead node2 adapter, so we wire pwa-node manually. The
      -- js-debug-adapter mason bin shim is unreliable, so invoke node on the
      -- dapDebugServer.js entrypoint directly. Install the adapter via Mason:
      --   :MasonInstall js-debug-adapter   (also auto-installed by mason-tool-installer)
      local js_debug = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { js_debug, '${port}' },
        },
      }
      for _, lang in ipairs({ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }) do
        dap.configurations[lang] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch current file (node)',
            program = '${file}',
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            protocol = 'inspector',
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch current file (tsx)',
            runtimeExecutable = 'tsx',
            args = { '${file}' },
            cwd = '${workspaceFolder}',
            sourceMaps = true,
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach to node process',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
            sourceMaps = true,
          },
        }
      end

      -- Auto open/close the UI around a session.
      dap.listeners.after.event_initialized['dapview_config'] = function() dv.open() end
      dap.listeners.before.event_terminated['dapview_config'] = function() dv.close() end
      dap.listeners.before.event_exited['dapview_config'] = function() dv.close() end

      -- Pretty signs in the gutter.
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'Visual', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DiagnosticError', numhl = '' })
    end,
  },
}
