-- nvim-ufo: modern folding driven by the LSP foldingRange capability (which we
-- advertise in config/lsp.lua) with an indent fallback. ufo OWNS folding — it
-- sets foldmethod=manual itself, which is why treesitter.lua no longer sets a
-- foldexpr. The fold gutter is drawn by the snacks statuscolumn (foldcolumn='0'
-- in options.lua), so we keep a single gutter owner — do not set foldcolumn here.
return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      -- These must hold for ufo's manual-fold model (folds start open).
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      -- LSP first, indent as the universal fallback. (Treesitter provider also
      -- exists but the LSP folding range is more precise where a server attaches.)
      provider_selector = function()
        return { 'lsp', 'indent' }
      end,
      -- Show "⋯ N lines" virtual text on a closed fold, right-aligned.
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local newVirtText = {}
        local suffix = ('  󰁂 %d'):format(end_lnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virt_text) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
      { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
      { 'zm', function() require('ufo').closeFoldsWith() end, desc = 'Close folds with level' },
      {
        'zp',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = 'Peek fold / hover',
      },
    },
  },
}
