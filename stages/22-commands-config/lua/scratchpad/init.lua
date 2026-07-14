local M = {}

M.config = {
  dir = vim.fn.stdpath("data") .. "/scratchpad",
  keymap = "<leader>j",
}

local function note_path()
  local project = vim.fn.getcwd():gsub("[^%w]", "_")
  return M.config.dir .. "/" .. project .. ".md"
end

function M.open()
  vim.fn.mkdir(M.config.dir, "p")
  vim.cmd.split(note_path())
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  vim.api.nvim_create_user_command("Scratch", M.open, {
    desc = "Project scratchpad",
  })
  vim.keymap.set("n", M.config.keymap, M.open, { desc = "Scratchpad" })
end

return M
