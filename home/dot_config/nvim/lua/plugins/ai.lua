if require("lazyvim.util").has_extra("ai.sidekick") then
  return {}
end

return {
  {
    "olimorris/codecompanion.nvim",
    opts = { adapters = { chat = "kiro" } },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
   keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
    },
  },
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
}
