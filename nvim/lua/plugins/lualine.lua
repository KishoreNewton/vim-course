-- Statusline (lualine) — still the 2026 standard. This keeps the spirit of the
-- original hand-rolled "eviline" config (mode dot, centred filename, LSP name,
-- diagnostics/diff/branch) but tuned to the hackertheme green palette and using
-- only modern APIs.
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-mini/mini.icons' },
  config = function()
    local lualine = require('lualine')

    -- Palette leaning into the hackertheme green-on-black aesthetic.
    local colors = {
      bg = '#0a0a0f',
      fg = '#e0e0e0',
      green = '#00ff00',
      mint = '#9DE0AD',
      yellow = '#FFF066',
      cyan = '#86E3CE',
      blue = '#A9D0F5',
      violet = '#CCABD8',
      magenta = '#FB7BBE',
      orange = '#FFDCA2',
      red = '#ec5f67',
      grey = '#808080',
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    local config = {
      options = {
        component_separators = '',
        section_separators = '',
        globalstatus = true,
        theme = {
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
        disabled_filetypes = { statusline = { 'dashboard', 'snacks_dashboard' } },
      },
      sections = {
        lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
        lualine_c = {}, lualine_x = {},
      },
      inactive_sections = {
        lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {},
      },
    }

    local function ins_left(component) table.insert(config.sections.lualine_c, component) end
    local function ins_right(component) table.insert(config.sections.lualine_x, component) end

    -- Left edge bar.
    ins_left({ function() return '▊' end, color = { fg = colors.green }, padding = { left = 0, right = 1 } })

    -- Mode dot, colour-coded.
    ins_left({
      function() return '' end,
      color = function()
        local mode_color = {
          n = colors.green, i = colors.mint, v = colors.blue, [''] = colors.blue,
          V = colors.blue, c = colors.magenta, no = colors.red, s = colors.orange,
          S = colors.orange, ic = colors.yellow, R = colors.violet, Rv = colors.violet,
          cv = colors.red, ce = colors.red, r = colors.cyan, rm = colors.cyan,
          ['r?'] = colors.cyan, ['!'] = colors.red, t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] or colors.green }
      end,
      padding = { right = 1 },
    })

    ins_left({ 'filesize', cond = conditions.buffer_not_empty })
    ins_left({
      'filename',
      cond = conditions.buffer_not_empty,
      path = 1,
      symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' },
      color = { fg = colors.magenta, gui = 'bold' },
    })
    ins_left({ 'location' })
    ins_left({ 'progress', color = { fg = colors.fg, gui = 'bold' } })
    ins_left({
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      diagnostics_color = {
        error = { fg = colors.red }, warn = { fg = colors.yellow },
        info = { fg = colors.cyan }, hint = { fg = colors.blue },
      },
    })

    -- Push the rest to the right.
    ins_left({ function() return '%=' end })

    -- Active LSP server name(s) for this buffer.
    ins_left({
      function()
        local buf_ft = vim.bo.filetype
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if next(clients) == nil then return 'No LSP' end
        local names = {}
        for _, client in ipairs(clients) do
          local fts = client.config.filetypes
          if not fts or vim.tbl_contains(fts, buf_ft) then
            table.insert(names, client.name)
          end
        end
        return #names > 0 and table.concat(names, ', ') or 'No LSP'
      end,
      icon = ' LSP:',
      color = { fg = colors.green, gui = 'bold' },
    })

    -- Noice: show recording macro / command status when active.
    ins_right({
      function() return require('noice').api.status.mode.get() end,
      cond = function()
        local ok, noice = pcall(require, 'noice')
        return ok and noice.api.status.mode.has()
      end,
      color = { fg = colors.orange },
    })

    ins_right({ 'o:encoding', fmt = string.upper, cond = conditions.hide_in_width, color = { fg = colors.cyan, gui = 'bold' } })
    ins_right({ 'fileformat', icons_enabled = false, fmt = string.upper, color = { fg = colors.cyan, gui = 'bold' } })
    ins_right({ 'branch', icon = '', color = { fg = colors.violet, gui = 'bold' } })
    ins_right({
      'diff',
      symbols = { added = ' ', modified = ' ', removed = ' ' },
      diff_color = {
        added = { fg = colors.mint }, modified = { fg = colors.orange }, removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
    })
    ins_right({ function() return '▊' end, color = { fg = colors.green }, padding = { left = 1 } })

    lualine.setup(config)
  end,
}
