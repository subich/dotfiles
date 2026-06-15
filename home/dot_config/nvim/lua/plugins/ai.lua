if require("lazyvim.util").has_extra("ai.sidekick") then
  return {}
end

local ai_plugin = "agentic" -- "agentic" or "codecompanion"

if ai_plugin == "agentic" then
  return {
    {
      "carlos-algms/agentic.nvim",
      opts = { provider = "kiro-acp" },
      keys = {
        { "<leader>aa", function() require("agentic").toggle() end, desc = "AI Toggle Chat" },
        { "<leader>af", function() require("agentic").add_file() end, desc = "AI Send File" },
        { "<leader>ad", function() require("agentic").add_current_line_diagnostics() end, desc = "AI Diagnostics" },
        { "<leader>at", function() require("agentic").add_selection_or_file_to_context() end, mode = { "n", "v" }, desc = "AI Send This" },
        { "<leader>an", function() require("agentic").new_session() end, desc = "AI New Session" },
        { "<leader>ar", function() require("agentic").restore_session() end, desc = "AI Restore Session" },
        { "<leader>as", function() require("agentic").switch_provider() end, desc = "AI Switch Provider" },
      },
    },
  }
end

-- codecompanion
return {
  {
    "olimorris/codecompanion.nvim",
    opts = { adapters = { chat = "kiro" } },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Toggle Chat" },
      { "<leader>ad", "<cmd>CodeCompanion /lsp<cr>", mode = { "n", "v" }, desc = "AI Diagnostics" },
      { "<leader>at", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI Send Selection" },
      { "<leader>an", "<cmd>CodeCompanionChat<cr>", desc = "AI New Chat" },
      { "<leader>as", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    },
  },
  { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
}
