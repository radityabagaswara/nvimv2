return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {}, -- Use defaults to see if it attaches
        jdtls = {
          -- Strictly define filetypes for JDTLS
          filetypes = { "java" },
          mason = false,
        },
      },
      -- Force it to recognize .cs files immediately
      setup = {
        csharp_ls = function(_, opts)
          require("lspconfig").csharp_ls.setup(opts)
          return true
        end,
        jdtls = function()
          if vim.bo.filetype ~= "java" then
            return true -- skip setup if not java
          end
          return false -- let standard setup continue for java
        end,
      },
    },
    keys = {
      { "<leader>zz", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
    },
  },
}
