local g = vim.g

g.darkTransparency = 0.92
g.lightTransparency = 0.93

return {
  { "catppuccin/nvim", name = "catppuccin" },
  { "ellisonleao/gruvbox.nvim" },
  { "kaiuri/nvim-juliana" },
  { "marko-cerovac/material.nvim" },
  { "olimorris/onedarkpro.nvim" },
  { "rmehri01/onenord.nvim" },
  { "sainnhe/everforest" },
  { "savq/melange-nvim" },
  { "shaunsingh/moonlight.nvim" },
  { "tanvirtin/monokai.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
