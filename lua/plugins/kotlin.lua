return {
  {
    "AlexandrosAlexiou/kotlin.nvim",
    ft = { "kotlin" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      require("kotlin").setup({
        root_markers = { "gradlew", ".git", "mvnw", "settings.gradle", "settings.gradle.kts" },
        lsp = {
          settings = {
            kotlin = {
              -- Configure storage path to centralized location
              storagePath = vim.fn.stdpath("cache") .. "/kotlin-lsp",
            },
          },
        },
      })
    end,
  },
}
