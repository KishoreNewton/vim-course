-- Colourschemes. hackertheme (the original green-on-black aesthetic) stays the
-- default; modern themes are installed alongside so they're a :colorscheme away.
return {
  -- Modern, popular themes — installed but not active by default.
  {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = { style = 'storm', transparent = false },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = true,
    priority = 1000,
    opts = {
      flavour = 'mocha',
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        neotree = true,
        snacks = true,
        treesitter = true,
        which_key = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        native_lsp = { enabled = true, virtual_text = { errors = { 'italic' } } },
      },
    },
  },
  { 'rebelot/kanagawa.nvim', lazy = true, priority = 1000 },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = true, priority = 1000 },

  -- hackertheme ships from this repo's own colors/ directory. We register a tiny
  -- "virtual" plugin spec with no repo (dir = config root) so it participates in
  -- lazy's ordering and loads first, as the active colourscheme.
  {
    'hackertheme',
    dir = vim.fn.stdpath('config'),
    lazy = false,
    priority = 1000,
    config = function()
      -- The original config kept `syntax on`; treesitter provides highlighting
      -- for supported langs and falls back to syntax elsewhere.
      vim.cmd.colorscheme('hackertheme')
    end,
  },
}
