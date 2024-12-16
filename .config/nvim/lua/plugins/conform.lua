return {
  "stevearc/conform.nvim",

  event = "BufWritePre",

  -- This will provide type hinting with LuaLS
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
      python = { "isort", "black" },
      ["_"] = { "trim_whitespace" },
    },

    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
  },
}
