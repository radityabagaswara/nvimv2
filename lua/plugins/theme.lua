return {
  -- Nordic theme (active)
  {
    "AlexvZyl/nordic.nvim",
    name = "nordic",
    priority = 1000,
    config = function()
      require("nordic").setup({
        transparent = {
          bg = true,
        },
      })
      vim.cmd([[colorscheme nordic]])
    end,
  },

  -- Catppuccin theme (kept for later use)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = true,
    },
  },
}
