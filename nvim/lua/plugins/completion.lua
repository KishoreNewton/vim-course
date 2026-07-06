-- saghen/blink.cmp — the 2026 default completion engine (successor to nvim-cmp).
-- Batteries-included: LSP + path + snippets + buffer + cmdline + signature, with
-- a Rust fuzzy matcher. IMPORTANT: pin version = '1.*' — there is no stable v2
-- release yet (v2 lives only on `main` and changes the build story).
return {
  {
    'saghen/blink.cmp',
    version = '1.*', -- downloads the prebuilt Rust fuzzy binary (no toolchain needed)
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = (function()
          -- jsregexp gives LuaSnip better snippet transforms; skip on Windows.
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },
      keymap = {
        -- super-tab: <Tab> accepts/expands, <CR> confirms, arrows navigate.
        preset = 'super-tab',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      appearance = {
        nerd_font_variant = 'mono',
        use_nvim_cmp_as_default = false,
      },
      completion = {
        accept = { auto_brackets = { enabled = true } }, -- adds () after functions
        menu = {
          border = 'rounded',
          draw = { treesitter = { 'lsp' } }, -- highlight items with treesitter
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = 'rounded' },
        },
        ghost_text = { enabled = true }, -- inline preview of the selected item
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- SQL buffers get dadbod (table/column) completion (see plugins/db.lua).
        per_filetype = {
          sql = { 'dadbod', 'buffer' },
          mysql = { 'dadbod', 'buffer' },
          plsql = { 'dadbod', 'buffer' },
        },
        providers = {
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
