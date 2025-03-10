-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable LazyVim auto format
vim.g.autoformat = false

vim.o.guifont = "BerkeleyMono Nerd Font:h12"
if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true
end
