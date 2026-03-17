return {
  {
    "FabijanZulj/blame.nvim",
    config = function()
      require("blame").setup()
      vim.keymap.set("n", "<leader>ba", ":BlameToggle<CR>", { desc = "Git Blame Sidebar" })
    end,
  },
  {
    "yt20chill/inline_git_blame.nvim",
    event = "BufReadPost",
    opts = {},
  },
}
