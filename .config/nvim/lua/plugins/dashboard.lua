return {
  "snacks.nvim",
  ---@type snacks.Config
  dependencies = {
    { "juansalvatore/git-dashboard-nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  opts = function(_, opts)
    local git_dashboard = require("git-dashboard-nvim").setup({
      top_padding = 0,
      bottom_padding = 0,
      fallback_header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
      title = "owner_with_repo_name",
    })

    -- opts.dashboard.preset.header = table.concat(git_dashboard, "\n")
    opts.dashboard.sections = {
      {
        text = table.concat(git_dashboard, "\n"),
        align = "center",
        height = 15,
        padding = 1,
      },
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    }
  end,
}
