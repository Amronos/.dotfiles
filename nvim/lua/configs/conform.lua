local options = {
  formatters_by_ft = {
    cpp = { "clang-format" },
    css = { "styleint" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    yaml = { "prettierd" },
    ["_"] = { "trim_whitespace" },
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 2000, lsp_format = "first" }
  end,
}

return options
