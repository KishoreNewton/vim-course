-- lua_ls — tuned for Neovim config editing. lazydev.nvim supplies the runtime
-- library paths, so we don't hardcode them here.
return {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      diagnostics = {
        globals = { 'vim', 'Snacks' },
        disable = { 'missing-fields' },
      },
      hint = { enable = true }, -- inlay hints
      completion = { callSnippet = 'Replace' },
      format = { enable = false }, -- stylua (via conform) handles formatting
      telemetry = { enable = false },
    },
  },
}
