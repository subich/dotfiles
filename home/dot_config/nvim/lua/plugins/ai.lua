if require("lazyvim.util").has_extra("ai.sidekick") then
  return {}
end

return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      interactions = {
        chat = { adapter = "kiro" },
        inline = { adapter = "kiro" },
        cmd = { adapter = "kiro" },
      },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat Toggle", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", desc = "AI Add to Chat", mode = "v" },
      { "<leader>ax", "<cmd>CodeCompanionChat<cr>", desc = "AI New Chat", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionCmd<cr>", desc = "AI Command Prompt", mode = { "n", "v" } },
    },
  },
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
}
