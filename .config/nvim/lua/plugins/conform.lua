return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      python = { "isort", "black" },
      ["_"] = { "trim_whitespace" },
    },
  
    format_on_save = {
      lsp_fallback = true,
    },
  },
}
