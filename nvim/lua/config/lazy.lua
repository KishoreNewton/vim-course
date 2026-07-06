-- Bootstrap lazy.nvim (clones the stable branch on first launch) and load every
-- spec under lua/plugins/. See https://lazy.folke.io.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins' }, -- auto-import every lua/plugins/*.lua
  },
  defaults = {
    lazy = true, -- specs are lazy by default; opt into eager with lazy = false
    version = false, -- always use the latest commit (themes/tools move fast)
  },
  -- Install the hackertheme look during headless installs so the UI matches.
  install = { colorscheme = { 'hackertheme', 'tokyonight', 'habamax' } },
  checker = {
    enabled = true, -- periodically check for plugin updates …
    notify = false, -- … but don't nag on every startup
  },
  change_detection = { notify = false },
  ui = { border = 'rounded' },
  -- None of our plugins need luarocks; disabling it silences the hererocks
  -- ❌ in :checkhealth lazy and avoids an unused dependency.
  rocks = { enabled = false },
  performance = {
    rtp = {
      -- Disable some built-in runtime plugins for a faster startup.
      disabled_plugins = {
        'gzip', 'tarPlugin', 'zipPlugin', 'tohtml', 'tutor',
      },
    },
  },
})

-- Convenience: open the lazy.nvim UI.
vim.keymap.set('n', '<leader>L', '<cmd>Lazy<cr>', { desc = 'Lazy plugin manager' })
