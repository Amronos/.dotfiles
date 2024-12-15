require "nvchad.mappings"

local map = vim.keymap.set
local nomap = vim.keymap.del
local opts = { noremap = true, silent = true }

map("n", "<leader>xx", vim.cmd.Ex)
