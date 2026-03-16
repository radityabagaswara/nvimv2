return {
  -- tools
  { "stevearc/dressing.nvim", opts = {}, event = "VeryLazy" },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },

      -- { "folke/eodev.nvim", opts = {} },
      "mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      ---@type vim.diagnostic.Opts
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false, -- Disabled in favor of tiny-inline-diagnostic.nvim
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          -- Use this to add any additional keymaps
          -- for specific lsp servers
          ---@type LazyKeysSpec[]
          -- keys = {},
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },

      -- Inside your lspconfig servers table
      kotlin_language_server = {
        -- 1. Optimized Command for JetBrains LSP
        -- We boost the Heap (Xmx) and Stack (Xss) for deep Maven projects
        -- We also add the TieredCompilation flag to make the Java process start faster
        cmd = {
          "kotlin-language-server",
          "--jvm-arg=-Xmx4G",
          "--jvm-arg=-Xms1G",
          "--jvm-arg=-Xss4M",
          "--jvm-arg=-XX:+TieredCompilation",
          "--jvm-arg=-XX:TieredStopAtLevel=1",
          "--jvm-arg=-Didea.max.intellisense.filesize=2500",
          "--jvm-arg=-Dkotlin.lsp.skip.index.garbage=true",
        },

        -- 2. Root Detection
        -- Ensures it attaches to 'jacs-be' parent folder instead of sub-modules
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("settings.gradle", "settings.gradle.kts", "pom.xml", ".git")(fname)
        end,

        -- 3. LSP Specific Settings
        settings = {
          kotlin = {
            compiler = { jvm = { target = "17" } },
            indexing = {
              enabled = true,
            },
            externalSources = {
              useKlsCustomTarget = false, -- Prevents scanning every JAR immediately
              autoExpand = false,
            },
            hints = {
              typeHints = false, -- Disable for extra speed
              parameterHints = false,
            },
          },
        },

        -- 4. Life-Cycle Hooks
        -- This fixes the "Multiple Sessions" lock error you encountered
        on_exit = function()
          vim.fn.jobstart("pkill -9 -f kotlin-language-server")
        end,

        -- 5. File Watcher Filtering (The "Importing" speed-up)
        -- This tells the LSP to ignore the massive target folder in its watcher
        on_init = function(client)
          if client.server_capabilities then
            client.server_capabilities.workspace = client.server_capabilities.workspace or {}
            client.server_capabilities.workspace.fileOperations = {
              didCreate = { filters = { { pattern = { glob = "**/target/**", kind = "file" } } } },
              didDelete = { filters = { { pattern = { glob = "**/target/**", kind = "file" } } } },
            }
          end
        end,
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        eslint = function()
          return true
        end,
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      if LazyVim.has("neoconf.nvim") then
        local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
        require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))
      end

      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if server ~= "*" and type(server_opts) == "table" and server_opts.keys then
          require("lazyvim.plugins.lsp.keymaps").set({ name = server }, server_opts.keys)
        end
      end

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = require("lazyvim.config").icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = require("mason-lspconfig").get_available_servers()
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server ~= "*" and server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          elseif server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
    end,
  },
  { "hrsh7th/cmp-emoji" },
  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      {
        "tzachar/cmp-tabnine",
        build = "./install.sh",
        config = function()
          require("cmp_tabnine.config"):setup({})
        end,
      },
    },

    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
