-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local servers = { "clangd", "pylsp", "lemminx", "esbonio", "docker_compose_language_service", "dockerls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.pylsp.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
  settings = {
    configurationSources = { "flake8" },
    formatCommand = { "black" },
    pylsp = {
      plugins = {
        pyflakes = { enabled = true },
        pylsp_mypy = { enabled = true },
        pycodestyle = {
          enabled = true,
          ignore = { "E303" },
          maxLineLength = 200,
        },
        yapf = { enabled = true },
      },
    },
  },
}
