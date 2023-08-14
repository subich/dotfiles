return {
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
        wk.register({
          g = {
            y = "Copy GitHub permalink",
          },
        }, { prefix = "<leader>" })
      end,
    },
    {
      "lewis6991/gitsigns.nvim",
      opts = {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          ignore_whitespace = true,
        },
        current_line_blame_formatter_opts = {
          relative_time = true,
        },
      },
    },
  }
  