local M = {}

function M.setup()
  local script = vim.api.nvim_get_runtime_file('comet.mjs', false)[1]
  local chan = vim.fn.jobstart({ 'node', script }, { rpc = true })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled' }, {
    callback = function()
      local p = vim.fn.screenpos(0, vim.fn.line('.'), vim.fn.col('.'))
      vim.rpcnotify(chan, 'move', p.row - 1, p.col - 1)
    end,
  })
end

return M
