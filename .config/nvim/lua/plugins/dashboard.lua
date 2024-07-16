return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = {
    { "juansalvatore/git-dashboard-nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  opts = function(_, opts)
    local git_dashboard = require("git-dashboard-nvim").setup({})
    opts.config.header = git_dashboard
  end,
}
