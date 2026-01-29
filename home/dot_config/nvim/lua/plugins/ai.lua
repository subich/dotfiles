return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          copilot = {
            cmd = {
              "copilot",
              "--banner",
              "--allow-all-tools",
              "--deny-tool",
              "shell(git push)",
              "--deny-tool",
              "shell(rm)",
            },
          },
        },
      },
    },
  },
}
