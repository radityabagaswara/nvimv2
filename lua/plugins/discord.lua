return {
  "vyfor/cord.nvim",
  build = ":Cord update",
  opts = {
    text = {
      file_browser = false,
      plugin_manager = false,
      docs = false,
      notes = false,
    },
  },
}
