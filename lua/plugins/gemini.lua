return {
  {
    "vaijab/gemini-cli.nvim",
    -- Force load so commands are available immediately
    lazy = false,
    build = ":GeminiBuild",
    opts = {
      -- The internal module is actually 'gemini'
    },
    config = function()
      -- The plugin registers commands automatically.
      -- We just need to sync the PID for your external terminal.
      if vim.env.TMUX then
        local pid = tostring(vim.fn.getpid())
        -- This tells every Tmux pane "I am an IDE and here is my ID"
        vim.fn.jobstart({ "tmux", "set-environment", "GEMINI_CLI_IDE_PID", pid })
        vim.fn.jobstart({ "tmux", "set-environment", "TERM_PROGRAM", "vscode" })
      end

      -- Useful keymaps for the diff view this plugin provides
      vim.keymap.set("n", "<leader>gy", "<cmd>GeminiDiffAccept<cr>", { desc = "Gemini Accept" })
      vim.keymap.set("n", "<leader>gn", "<cmd>GeminiDiffRefuse<cr>", { desc = "Gemini Refuse" })
    end,
  },
}
