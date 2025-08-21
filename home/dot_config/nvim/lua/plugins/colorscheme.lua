return {
  {
    "akinsho/bufferline.nvim",
    init = function()
      local bufline = require("catppuccin.groups.integrations.bufferline")
      function bufline.get()
        return bufline.get_theme()
      end
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },

  { "folke/tokyonight.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "rmehri01/onenord.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
