return {
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    lazy = true,
    opts = {
      default_mappings = {
        ours = "<leader>ho",
        theirs = "<leader>ht",
        none = "<leader>h0",
        both = "<leader>hb",
        next = "]x",
        prev = "[x",
      },
    },
    keys = {
      {
        "<leader>gx",
        "<cmd>GitConflictListQf<cr>",
        desc = "List Conflicts",
      },
      {
        "<leader>gr",
        "<cmd>GitConflictRefresh<cr>",
        desc = "Refresh Conflicts",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    opts = {
      current_line_blame = true,
    },
    keys = {
      { "<leader>gz", require("gitsigns").toggle_current_line_blame, desc = "Toggle current line blame" },
    },
  },
}
