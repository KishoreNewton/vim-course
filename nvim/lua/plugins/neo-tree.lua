-- neo-tree — a dedicated sidebar file tree, kept as an alternative. The primary
-- explorer is netrw (<leader>e / <leader>pv / <leader>E — the user's preference).
-- neo-tree lives on <leader>fe (and git/buffer variants) so it's still available.
-- Uses branch v3.x (current major).
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  cmd = 'Neotree',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-mini/mini.icons',
  },
  keys = {
    { '<leader>fe', '<cmd>Neotree toggle reveal<cr>', desc = 'Explorer (neo-tree)' },
    { '<leader>ge', '<cmd>Neotree git_status<cr>', desc = 'Git explorer (neo-tree)' },
    { '<leader>be', '<cmd>Neotree buffers<cr>', desc = 'Buffer explorer (neo-tree)' },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status' },
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = { visible = false, hide_dotfiles = false, hide_gitignored = true },
    },
    window = {
      width = 32,
      mappings = {
        ['<space>'] = 'none', -- don't shadow leader
        ['Y'] = function(state)
          local node = state.tree:get_node()
          vim.fn.setreg('+', node.path, 'c')
        end,
        ['O'] = function(state)
          require('lazy.util').open(state.tree:get_node().path, { system = true })
        end,
      },
    },
    default_component_configs = {
      indent = { with_expanders = true, expander_collapsed = '', expander_expanded = '' },
      git_status = {
        symbols = {
          added = '', modified = '', deleted = '✖', renamed = '󰁕',
          untracked = '', ignored = '', unstaged = '󰄱', staged = '', conflict = '',
        },
      },
    },
  },
}
