-- ts_ls (the renamed typescript-language-server). Rich inlay hints for JS & TS.
local inlay = {
  includeInlayParameterNameHints = 'all',
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

return {
  init_options = { hostInfo = 'neovim' },
  settings = {
    complete_function_calls = true,
    typescript = { inlayHints = inlay },
    javascript = { inlayHints = inlay },
  },
}
