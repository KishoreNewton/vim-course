-- octo.nvim — GitHub PRs & issues inside Neovim (review, inline comments,
-- suggestions, issues-as-buffers). The collaboration layer that gitsigns/
-- fugitive/diffview don't provide. Requires the `gh` CLI authenticated.
-- Keys live under <leader>gh… (gitHub) so they don't collide with the fugitive
-- push/pull maps on <leader>gp/<leader>gP.
return {
  'pwntester/octo.nvim',
  cmd = 'Octo',
  dependencies = { 'nvim-lua/plenary.nvim', 'folke/snacks.nvim' },
  opts = {
    picker = 'snacks',
    enable_builtin = true,
    suppress_missing_scope = { projects_v2 = true },
  },
  keys = {
    { '<leader>ghp', '<cmd>Octo pr list<cr>', desc = 'GitHub: PRs' },
    { '<leader>ghi', '<cmd>Octo issue list<cr>', desc = 'GitHub: issues' },
    { '<leader>ghr', '<cmd>Octo review start<cr>', desc = 'GitHub: start review' },
    { '<leader>ghs', '<cmd>Octo search<cr>', desc = 'GitHub: search' },
    { '<leader>gho', '<cmd>Octo<cr>', desc = 'GitHub: Octo menu' },
  },
}
