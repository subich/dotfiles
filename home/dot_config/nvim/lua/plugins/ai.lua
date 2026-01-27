return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        tools = {
          copilot = { cmd = { "copilot", "--banner", "--allow-tool 'write'" } },
        },
      },
    },
  },
}
