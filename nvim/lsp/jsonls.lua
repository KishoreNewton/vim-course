-- json-language-server with the SchemaStore catalog (package.json, tsconfig, …).
local ok, schemastore = pcall(require, 'schemastore')

return {
  settings = {
    json = {
      validate = { enable = true },
      schemas = ok and schemastore.json.schemas() or {},
    },
  },
}
