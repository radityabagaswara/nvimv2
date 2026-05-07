return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        csharp_ls = {},
      },

      setup = {
        csharp_ls = function(_, opts)
          require("lspconfig").csharp_ls.setup(opts)
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
