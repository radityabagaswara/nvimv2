return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {},

        kotlin_language_server = {
          mason = false,
          cmd = {
            vim.fn.expand("~/.local/share/nvim/mason/bin/kotlin-lsp"),
            "--stdio",
            "-J-Xmx1g",
          },
          filetypes = { "kotlin" },
          root_dir = function(fname)
            local util = require("lspconfig.util")

            local pom = util.root_pattern("pom.xml")(fname)
            if pom then
              return pom
            end

            return util.root_pattern("mvnw", "build.gradle", "build.gradle.kts", ".git")(fname)
          end,
          settings = {
            kotlin = {
              indexing = { enabled = true },
              externalSources = { useKlsCustomCommand = false },
            },
          },
        },
      },

      setup = {
        csharp_ls = function(_, opts)
          require("lspconfig").csharp_ls.setup(opts)
          return true
        end,

        kotlin_lsp = function(_, opts)
          require("lspconfig").kotlin_lsp.setup(opts)
          return true
        end,
      },
    },

    keys = {
      { "gh", vim.lsp.buf.hover, desc = "Hover" },
      { "<leader>k", vim.lsp.buf.hover, desc = "Hover" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
    },
  },
}
