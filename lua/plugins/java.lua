return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            filetypes = { "java" }, -- Removed 'kotlin' to prevent JDTLS from interfering with Kotlin files
            settings = {
              java = {
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-21",
                      path = "/opt/homebrew/opt/openjdk@21",
                      default = true,
                    },
                  },
                },
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              jdk = {
                auto_install = false,
              },
            })
          end,
        },
      },
    },
    -- Removed 'Kotlin/kotlin-lsp' plugin here as it is not a Neovim plugin repo.
    -- The configuration for official Kotlin LSP is now correctly handled in 'lua/plugins/kotlin.lua'
    -- by pointing 'kotlin_language_server' to '/opt/homebrew/bin/kotlin-lsp'.
  },
}
