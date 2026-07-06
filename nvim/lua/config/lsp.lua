-- Native LSP wiring for Neovim 0.11+/0.12.
--
-- This file does the parts that are NOT per-server:
--   1. a global vim.lsp.config('*', …) that advertises blink.cmp's capabilities
--      to every server (so we don't thread capabilities into each lsp/*.lua),
--   2. a single LspAttach autocmd for buffer-local keymaps — we only add what the
--      0.11+ defaults don't already cover (notably `gd`), gated by capabilities,
--   3. vim.diagnostic.config with the modern signs/virtual_lines/jump options.
--
-- Per-server *settings* live in the top-level lsp/<name>.lua files, which
-- vim.lsp.config()/vim.lsp.enable() (driven by mason-lspconfig) discover
-- automatically and deep-merge over this wildcard.

-- ── 1. Global capabilities ──────────────────────────────────────────────────
-- blink.cmp also auto-registers via '*', but setting it explicitly is harmless
-- and makes the dependency obvious. Fall back gracefully if blink isn't loaded.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, 'blink.cmp')
if ok_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end
-- Advertise folding range support (used by treesitter/ufo-style folding).
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

vim.lsp.config('*', {
  capabilities = capabilities,
  root_markers = { '.git' },
})

-- ── 2. Buffer-local keymaps on attach ───────────────────────────────────────
-- Defaults already provided by Neovim 0.11+ (do NOT redefine):
--   grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO document symbols · K hover · <C-S> signature (insert)
--   [d / ]d diagnostic jump · <C-W>d diagnostic float
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kn_lsp_attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local buf = event.buf
    local function map(keys, fn, desc, mode)
      vim.keymap.set(mode or 'n', keys, fn, { buffer = buf, desc = 'LSP: ' .. desc })
    end

    -- The big omission from the defaults: go-to-definition / declaration.
    map('gd', function() Snacks.picker.lsp_definitions() end, 'Definition')
    map('gD', vim.lsp.buf.declaration, 'Declaration')
    map('gr', function() Snacks.picker.lsp_references() end, 'References')
    map('gI', function() Snacks.picker.lsp_implementations() end, 'Implementation')
    map('gy', function() Snacks.picker.lsp_type_definitions() end, 'Type definition')
    map('<leader>ss', function() Snacks.picker.lsp_symbols() end, 'Document symbols')
    map('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace symbols')

    -- Convenience aliases (the gr* defaults still work too).
    map('<leader>cr', vim.lsp.buf.rename, 'Rename')
    -- Code action with a preview diff (actions-preview.nvim) when available,
    -- falling back to the built-in picker. (Native `gra` is also overridden by
    -- actions-preview globally — see plugins/codenav.lua.)
    map('<leader>ca', function()
      local ok, ap = pcall(require, 'actions-preview')
      if ok then
        ap.code_actions()
      else
        vim.lsp.buf.code_action()
      end
    end, 'Code action (preview)', { 'n', 'v' })
    map('<leader>cd', vim.diagnostic.open_float, 'Line diagnostics')

    -- Enable inlay hints if the server supports them (0.10+ API). The global
    -- toggle lives on <leader>uh via Snacks.toggle.inlay_hints (see snacks.lua).
    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end

    -- Highlight references of the symbol under the cursor (snacks.words also does
    -- this, but the LSP document-highlight is more precise where available).
    if client and client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('kn_lsp_highlight_' .. buf, { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl_group,
        buffer = buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = hl_group,
        buffer = buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ── 3. Diagnostics ──────────────────────────────────────────────────────────
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  },
  -- Keep the inline view quiet; show the full message as virtual lines only on
  -- the cursor's current line (a clean, modern 0.11+ default).
  virtual_text = false,
  virtual_lines = { current_line = true },
  float = { border = 'rounded', source = 'if_many' },
  -- NOTE: jump.float was deprecated in 0.12 (removed in 0.14) in favour of
  -- jump.on_jump — a callback run after the cursor jumps. Re-open the float there.
  jump = {
    wrap = true,
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float(bufnr, { scope = 'cursor', focus = false, border = 'rounded' })
    end,
  },
})

-- Toggle between virtual_lines (current line) and virtual_text.
vim.keymap.set('n', '<leader>uv', function()
  local cfg = vim.diagnostic.config()
  if cfg.virtual_lines then
    vim.diagnostic.config({ virtual_lines = false, virtual_text = { source = 'if_many', spacing = 2 } })
    vim.notify('Diagnostics: virtual text')
  else
    vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })
    vim.notify('Diagnostics: virtual lines')
  end
end, { desc = 'Toggle diagnostic virtual lines/text' })

-- ── 4. Reference highlighting (document highlight / snacks words) ─────────────
-- When the cursor rests on a symbol, the LSP highlights every matching occurrence
-- using the LspReference{Text,Read,Write} groups. By default Neovim links those to
-- `Visual`, which hackertheme paints solid white (#FFFFFF) — far too harsh. Replace
-- them with a faint, semi-transparent-looking tint so the matches read cleanly:
-- only a soft background wash, no foreground recolour, no bold. `blend` makes the
-- wash sit *over* the text translucently on terminals that support it.
local function set_reference_highlights()
  -- The hackertheme uses a transparent Normal background (guibg=NONE), so the real
  -- backdrop is the terminal's (near-black). SOLID backgrounds — no `blend` — are
  -- used here: blend washed the colour out to near-invisible on a transparent bg.
  -- These sit at ~6% luminance (~2.2:1 contrast on black): clearly visible when you
  -- rest on a symbol, but calm enough not to distract. Reads get a hacker-green
  -- wash; writes get a warmer amber so an assignment is distinguishable at a glance.
  local read = { bg = '#2a4d36' } -- medium green
  local write = { bg = '#574421' } -- warm amber
  vim.api.nvim_set_hl(0, 'LspReferenceText', read)
  vim.api.nvim_set_hl(0, 'LspReferenceRead', read)
  vim.api.nvim_set_hl(0, 'LspReferenceWrite', write)
  -- snacks.words reuses the same groups for its ]]/[[ navigation.
  vim.api.nvim_set_hl(0, 'SnacksWordsUnder', read)
end

set_reference_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('kn_lsp_reference_hl', { clear = true }),
  callback = set_reference_highlights,
})
