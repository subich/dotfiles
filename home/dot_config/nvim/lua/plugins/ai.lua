return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        tools = {
          copilot = { cmd = { "copilot", "--banner", "--allow-tool", "write" } },
        },
      },
    },
  },
}
