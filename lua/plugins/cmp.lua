return {
  -- 1. nvim-cmp Configuration
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        opts = {}, -- Replaces the empty config function
      },
    },
    -- Use the function form of opts to merge your settings with the defaults safely
    opts = function(_, opts)
      -- Apply your performance tweaks
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        debounce = 150,
      })

      opts.performance = vim.tbl_deep_extend("force", opts.performance or {}, {
        fetching_timeout = 200,
        max_view_entries = 15,
      })

      -- Ensure sources table exists and inject your custom sources
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "emoji" })
      table.insert(opts.sources, { name = "cmp_tabnine" }) -- Required to actually use Tabnine
    end,
  },
}
