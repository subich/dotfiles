return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
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
    init = function()
      local wk = require("which-key")
      wk.add({ "<leader>gy", desc = "Copy GitHub permalink" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    init = function()
      local wk = require("which-key")
      local gs = require("gitsigns")
      wk.add({ "<leader>gz", gs.toggle_current_line_blame, desc = "Toggle current line blame" })
    end,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        ignore_whitespace = true,
      },
    },
  },
}
