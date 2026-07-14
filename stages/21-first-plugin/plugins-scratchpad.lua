-- Section 21: the lazy.nvim spec that loads the local plugin folder.
-- This file lives at ~/.config/nvim/lua/plugins/scratchpad.lua
return {
  {
    dir = vim.fn.expand("~/projects/scratchpad.nvim"),
    opts = {},
  },
}
