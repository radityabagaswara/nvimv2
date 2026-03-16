return {
  {
    "kdheepak/lazygit.nvim",
    keys = {
      {
        ";c",
        function()
          -- 1. Get the current file path
          local current_file = vim.api.nvim_buf_get_name(0)

          -- 2. Find the nearest .git directory starting from the current file
          local git_root = vim.fs.find(".git", {
            path = current_file,
            upward = true,
            stop = vim.loop.os_homedir(), -- Don't search beyond your home folder
          })[1]

          if git_root then
            -- 3. Get the parent folder of the .git directory
            local repo_path = vim.fn.fnamemodify(git_root, ":h")
            require("lazygit").lazygit(repo_path)
          else
            -- 4. Fallback: If no .git found, just open standard LazyGit
            require("lazygit").lazygit()
          end
        end,
        desc = "LazyGit (Auto-detect Git Root)",
        silent = true,
        noremap = true,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
