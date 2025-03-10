return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      css = { "stylelint" },
      html = { "tidy" },
      javascript = { "eslint" },
      lua = { "selene" },
      python = { "pylint" },
      shell = { "shellcheck" },
      sql = { "sqlfluff" },
    },
  },
}
