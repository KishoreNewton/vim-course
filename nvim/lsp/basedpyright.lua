-- basedpyright — modern pyright fork (inlay hints, semantic tokens). Linting and
-- import sorting are delegated to ruff (via nvim-lint / conform).
return {
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'standard',
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
        },
      },
    },
  },
}
