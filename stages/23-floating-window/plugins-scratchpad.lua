-- Section 23: the user overrides an option — the merge honors it.
-- This file lives at ~/.config/nvim/lua/plugins/scratchpad.lua
return {
  {
    dir = vim.fn.expand("~/projects/scratchpad.nvim"),
    opts = { title = " Notes " },
    lazy = false, -- this config lazy-loads by default; wake ours at boot
  },
}
