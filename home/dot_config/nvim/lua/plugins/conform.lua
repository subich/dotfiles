return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "stylelint" },
      lua = { "stylua" },
      shell = { "shfmt" },
      sql = { "sqlfluff" },
      ["*"] = { "codespell" },
      ["_"] = { "trim_whitespace" },
    },
    formatters = {
      sqlfluff = {
        args = { "format", "-" },
      },
    },
  },
}
