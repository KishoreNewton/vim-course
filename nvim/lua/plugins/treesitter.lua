-- nvim-treesitter on the `main` branch. NOTE: on Neovim 0.12 the legacy `master`
-- branch is frozen and unsupported — `main` is the only correct choice. The
-- `main` rewrite only manages parsers + queries; highlighting is enabled via the
-- native vim.treesitter.start() in a FileType autocmd (no more module options).
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- treesitter does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      local ensure = {
        'bash', 'c', 'cpp', 'css', 'diff', 'dockerfile', 'go', 'gomod', 'gosum',
        'html', 'javascript', 'json', 'lua', 'luadoc', 'luap', 'make',
        'markdown', 'markdown_inline', 'python', 'query', 'regex', 'rust', 'scss',
        'toml', 'tsx', 'typescript', 'vim', 'vimdoc', 'yaml',
      }

      -- Install only the parsers we don't already have (idempotent, async).
      local installed = require('nvim-treesitter.config').get_installed()
      local to_install = vim.tbl_filter(function(parser)
        return not vim.tbl_contains(installed, parser)
      end, ensure)
      if #to_install > 0 then
        require('nvim-treesitter').install(to_install)
      end

      -- Enable highlighting and treesitter-based indentation per file. Folding is
      -- owned by nvim-ufo (see lua/plugins/folding.lua), which sets foldmethod
      -- itself and computes folds from the LSP foldingRange capability + indent —
      -- so we deliberately do NOT set foldmethod/foldexpr here.
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kn_treesitter', { clear = true }),
        callback = function(event)
          local ft = vim.bo[event.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          -- Only start if a parser is actually installed for this language.
          if lang and vim.tbl_contains(require('nvim-treesitter.config').get_installed(), lang) then
            pcall(vim.treesitter.start, event.buf)
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Treesitter text objects (also rewritten on `main`).
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require('nvim-treesitter-textobjects.select').select_textobject
      local moves = require('nvim-treesitter-textobjects.move')

      -- Select: function/class/parameter/conditional/loop, inner & around.
      local sel = {
        ['af'] = '@function.outer', ['if'] = '@function.inner',
        ['ac'] = '@class.outer', ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer', ['ia'] = '@parameter.inner',
        ['ai'] = '@conditional.outer', ['ii'] = '@conditional.inner',
        ['al'] = '@loop.outer', ['il'] = '@loop.inner',
      }
      for lhs, query in pairs(sel) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select(query, 'textobjects')
        end, { desc = 'TS select ' .. query })
      end

      -- Movement between functions/classes.
      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function() moves.goto_next_start('@function.outer', 'textobjects') end, { desc = 'Next function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']F', function() moves.goto_next_end('@function.outer', 'textobjects') end, { desc = 'Next function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function() moves.goto_previous_start('@function.outer', 'textobjects') end, { desc = 'Prev function start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[F', function() moves.goto_previous_end('@function.outer', 'textobjects') end, { desc = 'Prev function end' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function() moves.goto_next_start('@class.outer', 'textobjects') end, { desc = 'Next class start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function() moves.goto_previous_start('@class.outer', 'textobjects') end, { desc = 'Prev class start' })
    end,
  },

  -- Auto close/rename HTML/JSX/Vue tags using treesitter.
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },
}
