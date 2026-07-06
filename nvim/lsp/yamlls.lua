-- yaml-language-server with SchemaStore catalog. Preserves the original
-- github-workflow / compose schema intent and adds the full catalog.
local ok, schemastore = pcall(require, 'schemastore')

return {
  settings = {
    yaml = {
      validate = true,
      keyOrdering = false,
      schemaStore = {
        -- Disable the built-in store; use the schemastore.nvim catalog instead.
        enable = false,
        url = '',
      },
      schemas = ok and schemastore.yaml.schemas() or {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.yml',
      },
    },
  },
}
