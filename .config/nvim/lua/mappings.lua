require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del
local opts = { noremap = true, silent = true }

map("n", "<leader>xx", "<CMD>Oil<CR>")

local telescope_builtin = require "telescope.builtin"
map("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
map("n", "<leader>fgf", telescope_builtin.git_files, { desc = "Telescope find git files" })
map("n", "<leader>fw", telescope_builtin.live_grep, { desc = "Telescope find word" })
map("n", "<leader>fs", telescope_builtin.grep_string, { desc = "Telescope find selection" })

map("n", "<leader>gs", vim.cmd.Git)

map("n", "<leader>u", vim.cmd.UndotreeToggle)
