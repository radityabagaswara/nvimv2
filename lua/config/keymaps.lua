local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", ":quit<Return>", opts)
keymap.set("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
keymap.set("n", "<Leader>f", ":NvimTreeFindFile<Return>", opts)
keymap.set("n", "<Leader>e", ":NvimTreeToggle<Return>", opts)
keymap.set("n", "<Leader>fe", ":NvimTreeFocus<Return>", opts)

-- Tabs
keymap.set("n", "te", ":tabedit<Return>")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

keymap.set("n", "H", "^")
keymap.set("n", "L", "$")
keymap.set("n", "J", "}")
keymap.set("n", "KK", "{")

keymap.set("v", "H", "^")
keymap.set("v", "L", "$")
keymap.set("v", "J", "}")
keymap.set("v", "KK", "{")

keymap.set("i", "jk", "<ESC>")
keymap.set("v", "jk", "<ESC>")

keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
keymap.set("n", "gd", vim.lsp.buf.references, opts)
keymap.set("n", "<Leader>c", ":cclose<Return>:lclose<Return>", opts)

keymap.set("n", ";z", ":HopWord<Return>", opts)
keymap.set("n", ";g", ":lua local line=tonumber(vim.fn.input('Go to line: ')); if line then vim.cmd(':'..line) end<CR>")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
keymap.set("n", "<S-j>", function()
  vim.diagnostic.goto_prev()
end, opts)

keymap.set("n", "<Leader>cy", function()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  if #diagnostics > 0 then
    local err = diagnostics[1]
    vim.fn.setreg("+", err.message)
    vim.notify("Copied error: " .. err.message, vim.log.levels.INFO)
  else
    vim.notify("No diagnostic on current line", vim.log.levels.WARN)
  end
end, opts)

-- Terminal Toggle Fix
local function toggle_terminal()
  Snacks.terminal.toggle()
end

-- Map for both Normal and Terminal modes
vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_terminal, { desc = "which_key_ignore" })
vim.keymap.set("n", "<Leader>b", ":BlameToggle<Return>")

-- Opens the Gemini CLI in a floating terminal, disguised as VS Code
vim.keymap.set("n", "<leader>ag", function()
  Snacks.terminal("gemini", {
    win = { position = "float" },
    env = { TERM_PROGRAM = "vscode" }, -- This is the magic bypass key
  })
end, { desc = "Open Gemini AI IDE" })
