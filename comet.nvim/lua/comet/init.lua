local M = {}

function M.setup(opts)
  local script = vim.api.nvim_get_runtime_file('comet.mjs', false)[1]
  local chan = vim.fn.jobstart({ 'node', script }, { rpc = true })
  vim.rpcnotify(chan, 'config', opts or {})

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled' }, {
    callback = function()
      local p = vim.fn.screenpos(0, vim.fn.line('.'), vim.fn.col('.'))
      if p.row > 0 then
        vim.rpcnotify(chan, 'move', p.row - 1, p.col - 1)
      end
    end,
  })
  vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function() vim.rpcnotify(chan, 'config', {}) end,
  })
  vim.api.nvim_create_user_command('CometStats', function()
    print(vim.rpcrequest(chan, 'stats'))
  end, {})
end

return M
