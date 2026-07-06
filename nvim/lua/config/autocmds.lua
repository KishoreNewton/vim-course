-- Autocommands. Grouped so re-sourcing this file is idempotent.
local function augroup(name)
  return vim.api.nvim_create_augroup('kn_' .. name, { clear = true })
end

-- Highlight text on yank (uses the modern vim.hl, not the deprecated vim.highlight).
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup('highlight_yank'),
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Auto-reload files changed outside Neovim, and warn on conflicts.
-- Replaces the original `au CursorHold * checktime | redraw!`, but scoped to the
-- events that actually matter (so we don't force a full redraw every updatetime).
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave', 'BufEnter' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Return to the last edit position when reopening a file.
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('last_loc'),
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].kn_last_loc then
      return
    end
    vim.b[buf].kn_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close throwaway/util buffers with a bare `q`.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'help', 'man', 'qf', 'lspinfo', 'checkhealth', 'notify', 'startuptime',
    'query', 'tsplayground', 'PlenaryTestPopup', 'grug-far',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, desc = 'Close window' })
  end,
})

-- Don't auto-comment the next line when pressing o/O on a comment.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('no_auto_comment'),
  callback = function()
    vim.opt_local.formatoptions:remove({ 'o' })
  end,
})

-- Auto-create missing parent directories when saving a new file.
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('auto_mkdir'),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Spell-check and soft-wrap in prose buffers.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('prose'),
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
})

-- The original config disabled treesitter highlighting in :help (it preferred
-- the classic syntax). Keep that behaviour.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup('help_no_treesitter'),
  pattern = 'help',
  callback = function(event)
    pcall(vim.treesitter.stop, event.buf)
  end,
})

-- Personal modules: custom PDF viewer (pdftotext) and the cursor-trail animation.
require('custom.pdf').setup()
require('custom.cursor-trail').setup({
  enabled = true,
  character = '●',
  length = 5,
  fade_time = 150,
  update_interval = 30,
})
