return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jdtls = {
          -- Strictly define filetypes for JDTLS
          filetypes = { "java" },
        },
      },
      setup = {
        -- Force JDTLS to stay away from non-java files
        jdtls = function()
          if vim.bo.filetype ~= "java" then
            return true -- skip setup if not java
          end
          return false -- let standard setup continue for java
        end,
      },
    },
  },
}
