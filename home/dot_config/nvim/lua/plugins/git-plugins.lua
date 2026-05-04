local gitsigns_base_is_main = false

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
      {
        "<leader>gm",
        function()
          local gitsigns = require("gitsigns")

          -- Detect the default branch (main or master) from the remote HEAD,
          -- falling back to probing each name if the remote lookup fails.
          local function get_default_branch()
            local ref = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
            ref = ref:gsub("%s+$", "")
            if ref ~= "" then
              return ref:match("refs/remotes/origin/(.+)$")
            end
            -- Fallback: probe branch names directly.
            if vim.fn.system("git rev-parse --verify main 2>/dev/null"):gsub("%s+$", "") ~= "" then
              return "main"
            end
            return "master"
          end

          -- Module-level toggle state (persists for the session).
          if not gitsigns_base_is_main then
            local branch = get_default_branch()
            gitsigns.change_base(branch, true)
            vim.notify("gitsigns base → " .. branch, vim.log.levels.INFO)
            gitsigns_base_is_main = true
          else
            gitsigns.change_base(nil, true)
            vim.notify("gitsigns base → index (reset)", vim.log.levels.INFO)
            gitsigns_base_is_main = false
          end
        end,
        desc = "Toggle base to main/master",
      },
    },
  },
}
