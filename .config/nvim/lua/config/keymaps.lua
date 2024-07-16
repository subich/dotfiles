-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<Leader>-", "<Cmd>set foldlevel-=1<CR>zz", { desc = "Zoom out (see less)" })
vim.api.nvim_set_keymap("n", "<Leader>=", "<Cmd>set foldlevel+=1<CR>zz", { desc = "Zoom in (see more)" })
vim.api.nvim_set_keymap("n", "<Leader><Leader>-", "<Cmd>set foldlevel=0<CR>zM", { desc = "Zoom out max" })
vim.api.nvim_set_keymap("n", "<Leader><Leader>=", "<Cmd>set foldlevel=20<CR>zR", { desc = "Zoom in max" })
vim.api.nvim_set_keymap("n", "Z", "zkzxzz", { desc = "Open previous fold" })
vim.api.nvim_set_keymap("n", "X", "zjzxzz", { desc = "Open next fold" })

vim.api.nvim_set_keymap("n", "<BS>", "ciw", { desc = "Change word" })
