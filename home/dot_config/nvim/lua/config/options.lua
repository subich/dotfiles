-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable LazyVim auto format
vim.g.autoformat = false

-- LSP to use for Python
vim.g.lazyvim_python_lsp = "basedpyright"

-- Neovide specific options
vim.o.guifont = "BerkeleyMono Nerd Font:h12"

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
  vim.g.neovide_scale_factor = 1.0

  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.1)
  end, { desc = "Increase Neovide scale factor" })
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
  end, { desc = "Decrease Neovide scale factor" })
end
