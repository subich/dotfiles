vim.o.background = "dark"

-- append lazy = false, priority = 1000 to default
return {
  { "catppuccin/nvim", name = "catppuccin" },
  { "rebelot/kanagawa.nvim" },
  { "sainnhe/everforest" },
  { "ellisonleao/gruvbox.nvim" },
  { "marko-cerovac/material.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "rmehri01/onenord.nvim" },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
