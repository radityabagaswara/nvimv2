return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use standard name to inherit default lspconfig settings
        kotlin_language_server = {
          mason = false,
          cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/kotlin-lsp"), "--stdio" },
          filetypes = { "kotlin" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("pom.xml", "build.gradle", ".git")(fname)
          end,
          settings = {
            kotlin = {
              indexing = {
                enabled = true
              }
            }
          },
        },
      },
      setup = {
        -- Force JDTLS to skip non-java files (extra safety)
        jdtls = function()
          if vim.bo.filetype ~= "java" then
            return true
          end
        end,
      },
    },
  },
}
