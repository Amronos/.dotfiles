return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('telescope').setup({})

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fgf', builtin.git_files, { desc = 'Telescope find git files' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = 'Telescope find word' })
    vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = 'Telescope find selection' })
  end
}
