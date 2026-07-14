local M = {}

M.config = {
  dir = vim.fn.stdpath("data") .. "/scratchpad",
  keymap = "<leader>j",
  width = 0.6,
  height = 0.6,
  border = "rounded",
  title = " Scratchpad ",
}

M.win = nil

local function note_path()
  local project = vim.fn.getcwd():gsub("[^%w]", "_")
  return M.config.dir .. "/" .. project .. ".md"
end

function M.open()
  vim.fn.mkdir(M.config.dir, "p")
  local buf = vim.fn.bufadd(note_path())
  vim.fn.bufload(buf)
  vim.bo[buf].filetype = "markdown"
  local width = math.floor(vim.o.columns * M.config.width)
  local height = math.floor(vim.o.lines * M.config.height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  M.win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", style = "minimal",
    width = width, height = height, row = row, col = col,
    border = M.config.border, title = M.config.title,
    title_pos = "center",
  })
  vim.keymap.set("n", "q", function() M.close() end, { buffer = buf })
end

function M.close()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    vim.api.nvim_win_call(M.win, function() vim.cmd.write() end)
    vim.api.nvim_win_close(M.win, true)
  end
  M.win = nil
end

function M.toggle()
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    M.close()
  else
    M.open()
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  vim.api.nvim_create_user_command("Scratch", M.toggle, {
    desc = "Project scratchpad",
  })
  vim.keymap.set("n", M.config.keymap, M.toggle, { desc = "Scratchpad" })
end

return M
