-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local markdown_zen = vim.api.nvim_create_augroup("markdown_zen", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = markdown_zen,
  pattern = "markdown",
  callback = function(event)
    vim.diagnostic.enable(false, { bufnr = event.buf })

    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(event.buf) and vim.api.nvim_get_current_buf() == event.buf then
        local has_snacks, snacks = pcall(require, "snacks")
        if has_snacks and not snacks.zen.win then
          snacks.zen.zen()
        end
      end
    end)
  end,
})
