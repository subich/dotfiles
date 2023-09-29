return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    init = function()
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")
      local util = require("lspconfig.util")

      if not configs.snyk then
        configs.snyk = {
          default_config = {
            cmd = { "snyk-ls" },
            root_dir = function(name)
              return util.find_git_ancestor(name) or vim.loop.os_homedir()
            end,
            single_file_support = true,
            filetypes = {}, -- empty equates to all filetypes
          },
        }
      end
      lspconfig.snyk.setup({
        init_options = {
          -- full list of options at https://docs.snyk.io/integrations/ide-tools/language-server#lsp-initialization-options
          activateSnykCode = "true",
          enableTrustedFoldersFeature = "false", -- Whether or not LS will prompt to trust a folder (default: true)
        },
      })
    end,
  },

  { -- display inlay hints from LSP
    "lvimuser/lsp-inlayhints.nvim", -- INFO only temporarily needed, until https://github.com/neovim/neovim/issues/18086
    lazy = true, -- required in attach function
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local capabilities = client.server_capabilities
          if capabilities.inlayHintProvider then
            require("lsp-inlayhints").on_attach(client, bufnr, false)
          end
        end,
      })
    end,
    opts = {
      inlay_hints = {
        parameter_hints = {
          show = true,
          prefix = "󰁍 ",
          remove_colon_start = true,
          remove_colon_end = true,
        },
        type_hints = {
          show = true,
          prefix = "   ",
          remove_colon_start = true,
          remove_colon_end = true,
        },
        only_current_line = true,
        highlight = "NonText", -- highlight group
      },
    },
  },
}
