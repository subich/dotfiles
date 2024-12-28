return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
    },
    config = true,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },
  {
    "ruifm/gitlinker.nvim",
    opts = {},
    keys = {
      { "<leader>gy", desc = "Copy GitHub permalink" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
    keys = {
      { "<leader>gz", require("gitsigns").toggle_current_line_blame, desc = "Toggle current line blame" },
    },
  },
}
