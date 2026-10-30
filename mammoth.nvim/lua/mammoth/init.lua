-- mammoth.nvim: the Lua half. Rust owns the file; this buffer only ever holds a
-- small window of it, and the window slides as the cursor moves.
local M = {}
local chan
local views = {}   -- buffer -> { total, top, size, gb, ms }

local function host()
  if not chan then
    local bin = vim.api.nvim_get_runtime_file('target/release/mammoth', false)[1]
    chan = vim.fn.jobstart({ bin }, { rpc = true })
  end
  return chan
end

-- show file lines [top, top + size) in the buffer
local function render(buf, top)
  local v = views[buf]
  top = math.max(0, math.min(top, v.total - v.size))
  local lines = vim.rpcrequest(host(), 'lines', top, v.size)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  v.top = top
end

-- put the cursor on file line n (0-based), sliding the window if it has to
function M.jump(n, keep)
  local buf = vim.api.nvim_get_current_buf()
  local v = views[buf]
  n = math.max(0, math.min(n, v.total - 1))
  local view = vim.fn.winsaveview()
  local old = v.top
  if keep or n < v.top or n >= v.top + v.size then
    render(buf, n - math.floor(v.size / 2))
  end
  if keep then
    -- same lines on screen as before the slide: shift the view by what the window moved
    view.topline = view.topline - (v.top - old)
    view.lnum = n - v.top + 1
    vim.fn.winrestview(view)
  else
    vim.api.nvim_win_set_cursor(0, { n - v.top + 1, 0 })
  end
end

-- the number column shows where a line sits in the FILE, not in the buffer
function M.lnum()
  local v = views[vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)]
  return v and tostring(v.top + vim.v.lnum) or tostring(vim.v.lnum)
end

-- the bar along the top: the file, and where the cursor is in all of it
function M.winbar()
  local win = vim.g.statusline_winid or 0
  local v = views[vim.api.nvim_win_get_buf(win)]
  if not v then return '' end
  local n = v.top + vim.api.nvim_win_get_cursor(win)[1]
  return (' mammoth   %.1f GB   %d lines   indexed in %d ms   │   line %d of %d   %d%%%%'):format(
    v.gb, v.total, v.ms, n, v.total, math.floor(n * 100 / v.total))
end

function M.find(text)
  local v = views[vim.api.nvim_get_current_buf()]
  local here = v.top + vim.api.nvim_win_get_cursor(0)[1] - 1
  local hit = vim.rpcrequest(host(), 'search', text, here)
  if hit == vim.NIL then
    vim.notify('mammoth: "' .. text .. '" not found below line ' .. (here + 1))
  else
    M.jump(hit)
    vim.fn.setreg('/', text)
  end
end

function M.open(path, buf)
  path = vim.fn.fnamemodify(path, ':p')
  local info = vim.rpcrequest(host(), 'open', path)
  buf = buf or vim.api.nvim_create_buf(true, true)
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false
  views[buf] = { total = info.lines, top = 0, size = 3 * vim.o.lines, gb = info.bytes / 2 ^ 30, ms = info.ms }
  vim.api.nvim_set_current_buf(buf)
  render(buf, 0)

  local ft = vim.filetype.match({ filename = path })
  if ft then vim.bo[buf].filetype = ft end
  vim.wo.number = true
  vim.wo.statuscolumn = "%=%{v:lua.require'mammoth'.lnum()} "
  vim.wo.winbar = "%!v:lua.require'mammoth'.winbar()"

  -- near either edge of the window? slide it so the cursor sits in the middle
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = buf,
    callback = function()
      local v = views[buf]
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local edge = vim.o.lines
      if (row <= edge and v.top > 0) or (row > v.size - edge and v.top + v.size < v.total) then
        M.jump(v.top + row - 1, true)
      end
    end,
  })
  local function count_or(default)
    return vim.v.count > 0 and vim.v.count - 1 or default
  end
  vim.keymap.set('n', 'G', function() M.jump(count_or(info.lines - 1)) end, { buffer = buf })
  vim.keymap.set('n', 'gg', function() M.jump(count_or(0)) end, { buffer = buf })
  vim.keymap.set('n', 'n', function() M.find(vim.fn.getreg('/')) end, { buffer = buf })
end

function M.setup(opts)
  local limit = (opts and opts.min_mb or 100) * 1024 * 1024
  vim.api.nvim_create_user_command('Mammoth', function(a) M.open(a.args) end,
    { nargs = 1, complete = 'file' })
  vim.api.nvim_create_user_command('MammothFind', function(a) M.find(a.args) end,
    { nargs = 1 })

  -- big files named on the command line: take them before Neovim tries to read them
  for _, file in ipairs(vim.fn.argv()) do
    if vim.fn.getfsize(file) > limit then
      vim.api.nvim_create_autocmd('BufReadCmd', {
        pattern = vim.fn.fnamemodify(file, ':p'),
        once = true,
        callback = function(ev) M.open(file, ev.buf) end,
      })
    end
  end
end

return M
