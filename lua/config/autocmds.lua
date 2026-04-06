-- Auto-fold Java and Kotlin imports on open
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "java", "kotlin" },
  callback = function()
    -- Wait a bit for Treesitter/Folding to initialize
    vim.defer_fn(function()
      local win = vim.api.nvim_get_current_win()
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor = vim.api.nvim_win_get_cursor(win)

      -- Search for the first import statement
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for i, line in ipairs(lines) do
        if line:match("^import ") then
          -- Temporarily move cursor to the import line to trigger foldclose
          vim.api.nvim_win_set_cursor(win, { i, 0 })
          vim.cmd("silent! foldclose")
          -- Restore original cursor position
          vim.api.nvim_win_set_cursor(win, cursor)
          break
        end
      end
    end, 1000)
  end,
})

-- Handle jar:file:/// and zipfile:// URIs for Go to Definition in Libraries
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "jar:file://*", "zipfile://*" },
  callback = function()
    local path = vim.fn.expand("<amatch>")
    -- Translate JAR paths to zipfile for Neovim's built-in zip plugin
    local clean_path = path:gsub("jar:file://", "zipfile://"):gsub("!", "::")
    vim.cmd("silent! e " .. vim.fn.fnameescape(clean_path))
  end,
})

-- Force K to jump even when LSP is attached (The Nuclear Option)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    vim.defer_fn(function()
      local opts = { buffer = bufnr, silent = true, noremap = true, nowait = true }
      pcall(vim.keymap.del, "n", "K", { buffer = bufnr })
      vim.keymap.set("n", "K", "{", opts)
      vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
    end, 1000)
  end,
})

-- Global LSP handler to suppress RPC errors from malformed Kotlin URIs
local original_definition_handler = vim.lsp.handlers["textDocument/definition"]
vim.lsp.handlers["textDocument/definition"] = function(err, result, ctx, config)
  -- 1. If there's an RPC error (like "Expected scheme-specific part"), just ignore it silently
  if err and (err.message:match("Expected scheme") or err.code == -32603) then
    return
  end

  -- 2. If there's a result, fix any broken file:/path URIs before continuing
  if result then
    local function fix_uri(uri)
      if uri:match("^file:/[^/]") then
        return uri:gsub("^file:/", "file:///")
      end
      return uri
    end

    if type(result) == "table" then
      if result.uri then
        result.uri = fix_uri(result.uri)
      else
        for _, location in ipairs(result) do
          if location.uri then
            location.uri = fix_uri(location.uri)
          end
        end
      end
    end
  end

  -- 3. Pass to original handler, but use pcall to catch Snacks.nvim picker crashes
  local ok, call_err = pcall(original_definition_handler, err, result, ctx, config)
  if not ok then
    -- If Snacks picker crashes, fallback to raw Neovim definition jump
    vim.notify("Fallback to raw definition jump...", vim.log.levels.DEBUG)
    vim.lsp.buf.definition()
  end
end
