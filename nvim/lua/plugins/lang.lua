-- Language-specific enhancements layered on top of the LSP core.
return {
  -- Rust: rustaceanvim configures rust_analyzer with extras (runnables, expand
  -- macro, debugging). It auto-applies — do NOT also set up rust_analyzer via
  -- vim.lsp.config/mason-lspconfig. We exclude rust_analyzer from mason-lspconfig's
  -- ensure_installed handling by letting rustaceanvim own it. (We still install the
  -- rust-analyzer binary; rustaceanvim finds it.)
  {
    'mrcjkb/rustaceanvim',
    -- v9 requires Neovim 0.12 (we're on 0.12.2) and drops a deprecated
    -- vim.lsp.get_buffers_by_client_id() call that v6 emitted. The breaking
    -- changes between v6→v9 (ra-multiplex, .vscode settings, nvim-0.11) don't
    -- affect our vim.g.rustaceanvim setup.
    version = '^9',
    lazy = false, -- the plugin handles its own loading on Rust files
    ft = { 'rust' },
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map('<leader>cA', function() vim.cmd.RustLsp('codeAction') end, 'Rust code action')
            map('<leader>dr', function() vim.cmd.RustLsp('debuggables') end, 'Rust debuggables')
            map('K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'Rust hover actions')
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
              checkOnSave = true,
              check = { command = 'clippy', extraArgs = { '--no-deps' } },
              procMacro = { enable = true },
              inlayHints = { chainingHints = { enable = true }, parameterHints = { enable = true } },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml: dependency versions, completions, update hints.
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },

  -- Go codegen helpers (struct tags, iferr, impl, fill struct, json→struct). NOT
  -- redundant with gopls/dap-go/neotest-golang — those don't generate code. All
  -- the LSP/DAP/test layers are disabled so this never fights our native setup.
  {
    'ray-x/go.nvim',
    dependencies = { 'ray-x/guihua.lua' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false, -- we configure gopls natively (lsp/gopls.lua)
      dap_debug = false, -- we use dap-go
      dap_debug_keymap = false,
      lsp_keymaps = false,
      lsp_inlay_hints = { enable = false }, -- native inlay hints already on
      trouble = false,
      luasnip = false,
    },
    keys = {
      { '<leader>cgt', '<cmd>GoModifyTags<cr>', ft = 'go', desc = 'Go: modify struct tags' },
      { '<leader>cga', '<cmd>GoAddTag<cr>', ft = 'go', desc = 'Go: add struct tags' },
      { '<leader>cge', '<cmd>GoIfErr<cr>', ft = 'go', desc = 'Go: add if err' },
      { '<leader>cgi', '<cmd>GoImpl<cr>', ft = 'go', desc = 'Go: generate interface impl' },
      { '<leader>cgf', '<cmd>GoFillStruct<cr>', ft = 'go', desc = 'Go: fill struct' },
      { '<leader>cgj', '<cmd>GoJson2Struct<cr>', mode = 'v', ft = 'go', desc = 'Go: JSON → struct' },
    },
  },

  -- package.json: inline dependency versions + outdated hints, update/delete actions.
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = { 'BufRead package.json' },
    opts = { autostart = true, hide_up_to_date = false },
    keys = {
      { '<leader>cnu', function() require('package-info').update() end, desc = 'npm: update package' },
      { '<leader>cni', function() require('package-info').install() end, desc = 'npm: install package' },
      { '<leader>cnc', function() require('package-info').change_version() end, desc = 'npm: change version' },
      { '<leader>cnt', function() require('package-info').toggle() end, desc = 'npm: toggle versions' },
    },
  },

  -- JSON/YAML schemas (used by the LSP settings in lsp/jsonls.lua & lsp/yamlls.lua).
  { 'b0o/schemastore.nvim', lazy = true },

  -- ── Markdown / Obsidian notes ──────────────────────────────────────────────
  -- In-editor markdown rendering (headings, code blocks, callouts, checkboxes).
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion' },
    dependencies = { 'nvim-mini/mini.icons' },
    opts = {
      completions = { lsp = { enabled = true } },
      heading = { sign = false },
    },
    keys = {
      { '<leader>um', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle markdown render' },
    },
  },

  -- Obsidian — IMPORTANT: the actively-maintained community fork
  -- (obsidian-nvim/obsidian.nvim), NOT the abandoned epwalsh/obsidian.nvim.
  -- Workspaces are created on demand; edit the paths to your real vault(s).
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = 'notes', path = '~/notes' },
      },
      -- completion.nvim_cmp / completion.blink are deprecated (removed in 4.0):
      -- the fork now provides completion via its built-in obsidian-ls LSP server,
      -- which blink picks up automatically. Keep only min_chars.
      completion = { min_chars = 2 },
      picker = { name = 'snacks.pick' },
      ui = { enable = false }, -- render-markdown.nvim handles the UI
    },
    keys = {
      { '<leader>oo', '<cmd>Obsidian quick_switch<cr>', desc = 'Obsidian quick switch' },
      { '<leader>on', '<cmd>Obsidian new<cr>', desc = 'Obsidian new note' },
      { '<leader>os', '<cmd>Obsidian search<cr>', desc = 'Obsidian search' },
      { '<leader>ot', '<cmd>Obsidian today<cr>', desc = 'Obsidian today' },
      { '<leader>ob', '<cmd>Obsidian backlinks<cr>', desc = 'Obsidian backlinks' },
    },
  },
}
