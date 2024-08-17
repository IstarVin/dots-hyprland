-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set
--
map("n", "<C-h>", "<cmd> NvimTmuxNavigateLeft <cr>")
map("n", "<C-j>", "<cmd> NvimTmuxNavigateDown <cr>")
map("n", "<C-k>", "<cmd> NvimTmuxNavigateUp <cr>")
map("n", "<C-l>", "<cmd> NvimTmuxNavigateRight <cr>")
