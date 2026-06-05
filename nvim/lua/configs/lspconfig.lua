require("nvchad.configs.lspconfig").defaults()

local servers = {
  "clangd",
  "dockerls",
  "docker_compose_language_service",
  "esbonio",
  "lemminx",
  "nixd",
  "pylsp",
  "rust_analyzer",
  "svelte",
  "tailwindcss",
  "ts_ls",
}

vim.lsp.config.nixd = {
  cmd = { "nixd" },
  settings = {
    formatting = {
      command = { "nix fmt" },
    },
  },
}

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
