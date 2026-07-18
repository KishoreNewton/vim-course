-- Section 22: spec unchanged from Section 21 — defaults do the talking.
-- This file lives at ~/.config/nvim/lua/plugins/scratchpad.lua
return {
  {
    dir = vim.fn.expand("~/projects/scratchpad.nvim"),
    opts = {},
    lazy = false, -- this config lazy-loads by default; wake ours at boot
  },
}
