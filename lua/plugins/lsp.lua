return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {},
        jdtls = {
          filetypes = { "java" },
          mason = false,
        },
        kotlin_language_server = {
          mason = false,
          cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/kotlin-lsp"), "-J-Xmx2G", "--stdio" },
          filetypes = { "kotlin" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern(".git", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts")(fname)
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
        jdtls = function()
          if vim.bo.filetype ~= "java" then
            return true
          end
          return false
        end,
      },
    },
    keys = {
      { "<leader>zz", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gh", vim.lsp.buf.hover, desc = "Hover" },
      { "<leader>k", vim.lsp.buf.hover, desc = "Hover" },
      -- We will handle K and gd globally to avoid conflicts
    },
  },
}
