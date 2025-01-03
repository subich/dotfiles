return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
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
