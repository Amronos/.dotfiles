return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "toml", "yaml", "markdown", "xml", "python", "cpp", "cmake", "c", "lua", "vim", "vimdoc", "bash" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },  
    })
  end
}
