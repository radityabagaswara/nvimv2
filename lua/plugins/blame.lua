return {
  {
    "FabijanZulj/blame.nvim",
    config = function()
      require("blame").setup()
      vim.keymap.set("n", "<leader>ba", ":BlameToggle<CR>", { desc = "Git Blame Sidebar" })
    end,
  },
}
