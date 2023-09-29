local function nullSources()
  local builtins = require("null-ls").builtins
  return {
    -- LUA
    builtins.formatting.stylua,

    -- SHELL
    builtins.code_actions.shellcheck,

    -- CLOUDFORMATION
    builtins.diagnostics.cfn_lint,

    -- TERRAFORM
    builtins.diagnostics.terraform_validate,

    -- JAVASCRIPT
    builtins.diagnostics.eslint,

    -- PYTHON
    builtins.diagnostics.pylint,
    -- builtins.diagnostics.mypy,
    -- builtins.diagnostics.flake8.with({
    --   extra_args = { "--config", vim.fn.expand("~/.config/flake8") },
    -- }),
  }
end

return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    return {
      sources = nullSources(),
    }
  end,
}
