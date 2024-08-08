-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local map = vim.keymap.set

map("n", "<C-h>", "<cmd> TmuxNavigateLeft <cr>")
map("n", "<C-j>", "<cmd> TmuxNavigateDown <cr>")
map("n", "<C-k>", "<cmd> TmuxNavigateUp <cr>")
map("n", "<C-l>", "<cmd> TmuxNavigateRight <cr>")
