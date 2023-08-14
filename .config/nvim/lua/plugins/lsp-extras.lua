return {
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