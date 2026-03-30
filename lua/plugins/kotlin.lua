return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_language_server = {
          mason = false,
          -- Increase RAM allocation. Multi-module Maven parsing is heavy.
          cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/kotlin-lsp"), "-J-Xmx2G", "--stdio" },
          filetypes = { "kotlin" },
          root_dir = function(fname)
            local util = require("lspconfig.util")
            -- 1. Prioritize .git or mvnw to guarantee we hit the TRUE parent root
            local root = util.root_pattern(".git", "mvnw")(fname)

            -- 2. Fallback: If not using git/mvnw, find the top-most pom.xml
            -- (This is a simplified fallback, but .git is usually the golden ticket)
            if not root then
              root = util.root_pattern("pom.xml")(fname)
            end

            return root
          end,
          settings = {
            kotlin = {
              indexing = {
                enabled = true,
              },
            },
          },
        },
      },
      setup = {
        jdtls = function()
          if vim.bo.filetype ~= "java" then
            return true
          end
        end,
      },
    },
  },
}
