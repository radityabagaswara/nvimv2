return {
  {
    "elmcgill/springboot-nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      springboot_nvim.setup({})

      local function get_maven_root()
        local pom = vim.fs.find("pom.xml", { path = vim.api.nvim_buf_get_name(0), upward = true })[1]
        return pom and vim.fn.fnamemodify(pom, ":h") or nil
      end

      -------------------------------------------------------------------------
      -- UNIVERSAL GENERATOR: Handles Class, Interface, and Enum
      -------------------------------------------------------------------------
      local function create_file(type)
        local root = get_maven_root()
        if not root then
          print("❌ Not in a Maven project")
          return
        end

        local is_kotlin = vim.fn.isdirectory(root .. "/src/main/kotlin") == 1
        local base_path = is_kotlin and "/src/main/kotlin/" or "/src/main/java/"

        vim.ui.input({ prompt = "New " .. type .. " Name (e.g. dto.UserRequest): " }, function(input)
          if not input or input == "" then
            return
          end

          local relative_path = input:gsub("%.", "/")
          local ext = is_kotlin and ".kt" or ".java"
          local full_path = root .. base_path .. relative_path .. ext

          -- Create directory and file
          vim.fn.mkdir(vim.fn.fnamemodify(full_path, ":h"), "p")

          -- Simple boilerplate logic
          local name = vim.fn.fnamemodify(full_path, ":t:r")
          local content = is_kotlin and (type:lower() .. " " .. name .. " {\n\n}")
            or ("public " .. type:lower() .. " " .. name .. " {\n\n}")

          vim.fn.writefile({ content }, full_path)
          vim.cmd("e " .. full_path)
          print("🚀 Created " .. type .. ": " .. relative_path .. ext)
        end)
      end

      -- Re-using the Run/Build functions from before
      local function run_maven_service()
        vim.cmd("wa")
        local root = get_maven_root()
        if not root then
          return
        end
        local mvn = vim.fn.filereadable(root .. "/mvnw") == 1 and "./mvnw" or "mvn"
        vim.cmd("split | term cd " .. root .. " && " .. mvn .. " spring-boot:run")
      end

      local function build_and_sync()
        vim.cmd("wa")
        local root = get_maven_root()
        if not root then
          return
        end
        local mvn = vim.fn.filereadable(root .. "/mvnw") == 1 and "./mvnw" or "mvn"
        print("🔨 Building...")
        vim.fn.jobstart(mvn .. " compile", {
          cwd = root,
          on_exit = function(_, code)
            if code == 0 then
              print("✅ Syncing LSP...")
              vim.lsp.buf.execute_command({ command = "kotlin.indexWorkspace" })
            end
          end,
        })
      end

      -------------------------------------------------------------------------
      -- KEYMAPS (The Full Set)
      -------------------------------------------------------------------------
      -- Run & Build
      vim.keymap.set("n", "<leader>Jr", run_maven_service, { desc = "Run Service" })
      vim.keymap.set("n", "<leader>jb", build_and_sync, { desc = "Build & Sync LSP" })

      -- New Generation Tools (Kotlin aware)
      vim.keymap.set("n", "<leader>Jc", function()
        create_file("Class")
      end, { desc = "Create Class" })
      vim.keymap.set("n", "<leader>Ji", function()
        create_file("Interface")
      end, { desc = "Create Interface" })
      vim.keymap.set("n", "<leader>Je", function()
        create_file("Enum")
      end, { desc = "Create Enum" })
    end,
  },
}
