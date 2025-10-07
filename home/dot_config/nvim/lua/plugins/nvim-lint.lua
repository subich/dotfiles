return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      css = { "stylelint" },
      html = { "tidy" },
      javascript = { "eslint" },
      lua = { "selene" },
      shell = { "shellcheck" },
      sql = { "sqlfluff" },
      terraform = { "tfsec" },
      yaml = { "cfn_lint" },
    },
    linters = {
      cfn_lint = {
        ignore_exitcode = true,
        condition = function(ctx)
          return string.find(ctx.filename, "cfn")
        end,
      },
      sqlfluff = {
        args = { "lint", "--format=json" },
      },
    },
  },
}
