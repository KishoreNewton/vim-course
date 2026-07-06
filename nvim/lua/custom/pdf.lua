-- Minimal in-editor PDF viewer: renders a .pdf as text via `pdftotext`.
-- Requires the `pdftotext` binary (poppler-utils). Modernised for Neovim 0.12
-- (vim.bo / vim.hl.range instead of the deprecated nvim_buf_set_option /
-- nvim_buf_add_highlight).
local api = vim.api
local fn = vim.fn

local pdf_ns = api.nvim_create_namespace('pdf_viewer')

local M = {}

-- Render the given PDF into the current buffer.
local function view_pdf(file_path)
  if fn.filereadable(file_path) == 0 then
    vim.notify('PDF viewer: file not readable: ' .. file_path, vim.log.levels.ERROR)
    return
  end
  if fn.executable('pdftotext') == 0 then
    api.nvim_buf_set_lines(0, 0, -1, false, {
      'PDF viewer requires the `pdftotext` binary (install poppler / poppler-utils).',
      '',
      'Arch:    sudo pacman -S poppler',
      'Debian:  sudo apt install poppler-utils',
      'macOS:   brew install poppler',
    })
    vim.bo.modifiable = false
    return
  end

  local pdf_content = fn.system({ 'pdftotext', '-layout', '-nopgbrk', file_path, '-' })
  if vim.v.shell_error ~= 0 then
    vim.notify('PDF viewer: pdftotext failed', vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(pdf_content, '\n')
  api.nvim_buf_set_lines(0, 0, -1, false, lines)

  vim.bo.modifiable = false
  vim.bo.filetype = 'pdf_view'

  -- Light highlighting: title on the first line, page markers elsewhere.
  api.nvim_buf_clear_namespace(0, pdf_ns, 0, -1)
  if lines[1] then
    vim.hl.range(0, pdf_ns, 'Title', { 0, 0 }, { 0, -1 })
  end
  for i, line in ipairs(lines) do
    if line:match('^%s*Page%s+%d+') then
      vim.hl.range(0, pdf_ns, 'Special', { i - 1, 0 }, { i - 1, -1 })
    end
  end
end

function M.setup()
  local group = api.nvim_create_augroup('kn_pdf_viewer', { clear = true })
  api.nvim_create_autocmd('BufReadCmd', {
    group = group,
    pattern = '*.pdf',
    callback = function()
      view_pdf(api.nvim_buf_get_name(0))
    end,
  })
end

return M
