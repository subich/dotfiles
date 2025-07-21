return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "stylelint" },
      lua = { "stylua" },
      shell = { "shfmt" },
      sql = { "sqlfluff", timeout_ms = 30000 },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
  },
}
