local function nullSources()
  local builtins = require("null-ls").builtins
  return {
    -- SPELLING
    builtins.completion.spell,

    -- SHELL
    builtins.code_actions.shellcheck,

    -- LUA
    builtins.formatting.stylua,

    -- CLOUDFORMATION
    builtins.diagnostics.cfn_lint,

    -- JAVASCRIPT
    builtins.diagnostics.eslint,

    -- PYTHON
    -- builtins.diagnostics.flake8,
    builtins.diagnostics.pylint,
  }
end

return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    return {
      sources = nullSources(),
    }
  end,
}
