-- return {
--   "codota/tabnine-nvim",
--   build = "./dl_binaries.sh", -- make sure this script exists and is executable
--   config = function()
--     require("tabnine").setup({
--       disable_auto_comment = true,
--       accept_keymap = "<Tab>",
--       dismiss_keymap = "<C-]>",
--       debounce_ms = 800,
--       suggestion_color = { gui = "#808080", cterm = 244 },
--       exclude_filetypes = { "TelescopePrompt", "NvimTree" },
--       log_file_path = nil, -- absolute path to TabNine log file
--     })
--   end,
--   -- "tzachar/cmp-tabnine",
--   -- build = "./install.sh",
--   -- dependencies = "hrsh7th/nvim-cmp",
--   -- config = function()
--   --   local tabnine = require("cmp_tabnine.config")
--   --   tabnine:setup({
--   --     max_lines = 1000,
--   --     max_num_results = 20,
--   --     sort = true,
--   --     run_on_every_keystroke = true,
--   --     snippet_placeholder = "..",
--   --   })
--   -- end,
-- }
--
return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({})
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      LazyVim.lsp.on_attach(function()
        copilot_cmp._on_insert_enter({})
      end, "copilot")
    end,
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
          table.insert(opts.sources, 1, {
            name = "copilot",
            group_index = 1,
            priority = 100,
          })
        end,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      model = "claude-3.7-sonnet",
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
