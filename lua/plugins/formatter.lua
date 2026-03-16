return {
  "stevearc/conform.nvim",
  opts = {
    -- 1. Define the formatters for each filetype
    formatters_by_ft = {
      javascript = { "organize-imports", "prettier" },
      typescript = { "organize-imports", "prettier" },
      javascriptreact = { "organize-imports", "prettier" },
      typescriptreact = { "organize-imports", "prettier" },
    },
    -- 2. Define what "organize-imports" actually does (The Missing Definition)
    formatters = {
      ["organize-imports"] = {
        meta = {
          url = "https://github.com/neovim/nvim-lspconfig",
          description = "Organize imports via the LSP code action.",
        },
        -- This tells conform to use the LSP (vtsls) instead of looking for a command
        method = "textDocument/codeAction",
        args = {},
        params = {
          context = {
            only = { "source.organizeImports" },
            diagnostics = {},
          },
        },
      },
    },
  },
}
