-- Formatting (conform.nvim) and linting (nvim-lint). Replaces the original
-- vim-prettier setup and the `gp`/BufWritePre prettier autocmd.
return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function() require('conform').format({ async = true }) end,
        mode = { 'n', 'v' },
        desc = 'Format buffer/selection',
      },
      -- Original muscle-memory: `gp` formatted the file with prettier.
      {
        'gp',
        function() require('conform').format({ async = true }) end,
        desc = 'Format buffer',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      -- NOTE: string `lsp_format`, not the deprecated boolean `lsp_fallback`.
      default_format_opts = { lsp_format = 'fallback' },
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        -- rust/go/c rely on the LSP formatter (rust_analyzer / gopls / clangd).
      },
      format_on_save = function(bufnr)
        -- Respect a global / per-buffer opt-out (toggled below).
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = 'fallback' }
      end,
    },
    init = function()
      -- :Format, :FormatDisable[!], :FormatEnable to control format-on-save.
      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          vim.b.disable_autoformat = true -- this buffer only
        else
          vim.g.disable_autoformat = true -- globally
        end
      end, { desc = 'Disable format-on-save (! = buffer only)', bang = true })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = 'Re-enable format-on-save' })

      vim.keymap.set('n', '<leader>uf', function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Format on save: ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'))
      end, { desc = 'Toggle format on save' })
    end,
  },

  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        python = { 'ruff' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
      }
      local grp = vim.api.nvim_create_augroup('kn_nvim_lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = grp,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
