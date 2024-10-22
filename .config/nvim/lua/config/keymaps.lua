-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
--
map("n", "<C-h>", "<cmd> NvimTmuxNavigateLeft <cr>")
map("n", "<C-j>", "<cmd> NvimTmuxNavigateDown <cr>")
map("n", "<C-k>", "<cmd> NvimTmuxNavigateUp <cr>")
map("n", "<C-l>", "<cmd> NvimTmuxNavigateRight <cr>")

map(
  "n",
  "<S-l>",
  -- Notice that I start it in normal mode to navigate similarly to bufexplorer,
  -- the ivy theme is also similar to bufexplorer and tmux sessions
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<cr>",
  { desc = "[P]Open telescope buffers" }
)

-- map("n", "<S-l>", function()
--   local toggle = require("snipe").create_buffer_menu_toggler({
--     -- Limit the width of path buffer names
--     max_path_width = 1,
--   })
--   toggle()
-- end, { desc = "[P]Snipe" })
