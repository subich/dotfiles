return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = false,
      float = { transparent = false },
      auto_integrations = true,
    },
  },
  { "folke/tokyonight.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-nvim" },
  },
}
