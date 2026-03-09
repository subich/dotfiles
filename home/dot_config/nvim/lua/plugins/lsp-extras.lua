return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    servers = {
      snyk_ls = {
        init_options = {
          activateSnykCode = "true",
          trustedFolders = { "~/Developer/" },
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
            validate = true,
            customTags = {
              "!And sequence",
              "!If sequence",
              "!Not sequence",
              "!Equals sequence",
              "!Or sequence",
              "!FindInMap sequence",
              "!Base64",
              "!Cidr",
              "!Ref",
              "!Sub",
              "!Sub sequence",
              "!GetAtt",
              "!GetAZs",
              "!ImportValue",
              "!Select sequence",
              "!Split sequence",
              "!Join sequence",
            },
            schemas = {
              ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = {
                "**/cfn/**/*.yaml",
                "**/cfn/**/*.yml",
              },
            },
          },
        },
      },
    },
  },
}
