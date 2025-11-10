return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        -- Preset options: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
        preset = "modern",

        options = {
          -- Show the source of the diagnostic
          show_source = false,

          -- Throttle the update of the diagnostic when moving cursor
          throttle = 20,

          -- Enable diagnostic message on all lines
          multilines = false,

          -- Show diagnostic message on cursor hold
          show_all_diags_on_cursorline = false,

          -- Enable for all severities
          severities = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },
      })
    end,
  },
}
