-- LSP installation + enable layer. Three pieces (note org move williamboman → mason-org):
--   • mason-org/mason.nvim            installs language servers / tools
--   • mason-org/mason-lspconfig.nvim  installs servers from ensure_installed (v2)
--   • neovim/nvim-lspconfig           data package shipping lsp/<server>.lua defaults
--
-- IMPORTANT ordering note: nvim-lspconfig's lsp/*.lua files (which carry each
-- server's cmd/filetypes/root_markers) are only available once nvim-lspconfig is
-- on the runtimepath. We therefore load it EAGERLY (lazy = false) and drive the
-- enable ourselves from its config function — rather than relying on
-- mason-lspconfig's automatic_enable, whose timing raced with buffer-open and
-- left servers with a nil `cmd`. Per-server settings live in the top-level lsp/
-- directory; the LspAttach maps + diagnostics live in lua/config/lsp.lua.
return {
  -- Faster, better Lua LS experience when editing Neovim config (replaces neodev).
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
      },
    },
  },

  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate', 'MasonUninstall', 'MasonLog' },
    keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ui = {
        border = 'rounded',
        icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
      },
    },
  },

  -- Non-LSP tools (formatters / linters) installed via Mason.
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    event = 'VeryLazy',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'stylua', 'shfmt', 'prettierd', 'black', 'isort', 'ruff', 'shellcheck', 'markdownlint',
        'js-debug-adapter', -- JS/TS/Node DAP adapter (wired manually in plugins/dap.lua)
      },
      run_on_start = true,
    },
  },

  -- mason-lspconfig: used ONLY to auto-install the servers (not to enable them).
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'VeryLazy',
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua_ls', 'ts_ls', 'basedpyright', 'rust_analyzer', 'clangd', 'gopls',
        'html', 'cssls', 'jsonls', 'yamlls', 'bashls', 'marksman', 'taplo', 'dockerls',
      },
      -- We enable servers ourselves (see nvim-lspconfig config below), so disable
      -- the automatic path to avoid double-enable / racy nil-cmd starts.
      automatic_enable = false,
    },
  },

  -- nvim-lspconfig: the data package. Loaded eagerly so its lsp/*.lua defaults are
  -- on the runtimepath before we enable anything. Its config() owns the enable.
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    priority = 900, -- after colourscheme (1000), before most VeryLazy specs
    config = function()
      -- Wire the '*' capabilities, LspAttach keymaps and diagnostics, then enable
      -- the servers. config/lsp.lua is idempotent and safe to require here.
      require('config.lsp')

      -- Servers we manage natively (rust_analyzer is intentionally absent —
      -- rustaceanvim configures and starts it itself).
      local servers = {
        'lua_ls', 'ts_ls', 'basedpyright', 'clangd', 'gopls',
        'html', 'cssls', 'jsonls', 'yamlls', 'bashls', 'marksman', 'taplo', 'dockerls',
      }
      vim.lsp.enable(servers)
    end,
  },
}
