return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      css = { "stylelint" },
      html = { "tidy" },
      lua = { "selene" },
      shell = { "shellcheck" },
      sql = { "sqlfluff" },
    },
  },
}
