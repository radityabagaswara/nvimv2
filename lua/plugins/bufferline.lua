return {
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = function(_, opts)
      opts.options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      }

      -- ✅ Use Catppuccin’s built-in bufferline integration
      local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
      if ok then
        opts.highlights = catppuccin.get()
      end

      return opts
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
