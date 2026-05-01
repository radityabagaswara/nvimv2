return {
  "folke/zen-mode.nvim",
  opts = {
    window = {
      backdrop = 0.95,
      width = 90,
      options = {
        number = true,
        relativenumber = true,
        wrap = false,
        signcolumn = "yes", -- Keep signcolumn to prevent layout shifts
      },
    },
    plugins = {
      -- ❗ Disable global option changes. This is the most common cause of
      -- ZenMode exiting unexpectedly when UI elements (like completion menus) close.
      options = {
        enabled = false,
      },
      twilight = { enabled = false },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
    },
    on_open = function(win)
      -- Automatically close NvimTree when entering Zen mode
      local nvim_tree_api = pcall(require, "nvim-tree.api")
      if nvim_tree_api then
        require("nvim-tree.api").tree.close()
      end
    end,
  },
  keys = {
    { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode (Normal)" },
    {
      "<leader>zZ",
      function()
        require("zen-mode").toggle({
          window = { width = 80 },
        })
      end,
      desc = "Toggle Zen Mode (Narrow)",
    },
  },
}
