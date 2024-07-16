-- selene: allow(mixed_table)
return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      ruff = {
        init_options = {
          settings = {
            editor = {
              formatOnSave = false,
            },
          },
        },
      },
      snyk_ls = {
        init_options = {
          activateSnykOpenSource = "true",
          activateSnykCode = "true",
          activateSnykIac = "true",
          enableTrustedFoldersFeature = "false", -- Whether or not LS will prompt to trust a folder (default: true)
          integrationName = "neovim",
          token = "",
        },
      },
      yamlls = {
        settings = {
          editor = {
            tabSize = 2,
          },
          yaml = {
            completion = true,
            format = {
              enable = true,
              bracketSpacing = true,
              singleQuote = true,
            },
            customTags = {
              "!And scalar",
              "!If scalar",
              "!Not",
              "!Equals scalar",
              "!Or scalar",
              "!FindInMap scalar",
              "!Base64",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!GetAtt sequence",
              "!GetAZs",
              "!ImportValue sequence",
              "!Select sequence",
              "!Split sequence",
              "!Join sequence",
            },
            schemas = {
              ["https://s3.amazonaws.com/cfn-resource-specifications-us-east-1-prod/schemas/2.15.0/all-spec.json"] = "/cfn/**/*.yaml",
            },
          },
        },
      },
    },
  },
}
