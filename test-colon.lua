-- Temporary debug file to catch colon key press
vim.on_key(function(key)
  local char = vim.fn.keytrans(key)
  if char:match(":") then
    vim.notify("COLON KEY DETECTED: " .. char, vim.log.levels.ERROR)
    -- Log what's mapped
    local maps = vim.api.nvim_get_keymap('n')
    for _, map in ipairs(maps) do
      if map.lhs == ":" or map.lhs:match(":") then
        vim.notify("Found mapping: " .. vim.inspect(map), vim.log.levels.WARN)
      end
    end
  end
end)

-- Also check Leader key
vim.notify("Leader key is: " .. vim.g.mapleader or "not set", vim.log.levels.INFO)
