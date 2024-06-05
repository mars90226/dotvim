local my_lspsaga = require("vimrc.plugins.lspsaga")
local my_goto_preview = require("vimrc.plugins.goto-preview")

local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

-- TODO: Refactor
local vue_typescript_plugin = require("mason-registry").get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"
  .. "/node_modules/@vue/typescript-plugin"

lsp.config = {
  enable_format_on_sync = false,
  show_diagnostics = true,
}

-- NOTE: Change it also need to change lsp.servers_by_filetype
lsp.servers = {
  bashls = {
    -- NOTE: Disable shellcheck integration and use nvim-lint to lint on save
    cmd_env = { SHELLCHECK_PATH = "" },
  },
  bufls = {
    condition = plugin_utils.has_linux_build_env(),
  },
  cssls = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  },
  clangd = {
    condition = plugin_utils.has_linux_build_env(),
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
      "--suggest-missing-includes",
    },
    -- NOTE: Workaround for "warning: multiple different client offset_encodings detected for buffer, this is not supported yet".
    -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
    capabilities = {
      offsetEncoding = { "utf-16" },
      memoryUsageProvider = true,
    },
    -- NOTE: Disable clangd on protobuf
    -- Ref: https://github.com/neovim/nvim-lspconfig/pull/2125#issuecomment-1291968687
    filetypes = { "c", "cpp" },
  },
  -- NOTE: Use tsserver again
  -- denols = {
  --   init_options = {
  --     enable = true,
  --     lint = true,
  --     unstable = true,
  --   },
  -- },
  esbonio = {},
  -- TODO: Suppress the error log of not finding eslint in local repo
  eslint = {},
  gopls = {
    condition = plugin_utils.has_linux_build_env(),
  },
  html = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  },
  jsonls = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
    settings = {},
    custom_setup = function(server, lsp_opts)
      lsp_opts.settings.json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      }
      require("lspconfig")[server].setup(lsp_opts)
    end,
  },
  -- TODO: Grammar check is unhelpful when article is not in English.
  -- NOTE: Cause error when hovering using LSP
  -- ltex = {
  --   on_attach = function(client, bufnr)
  --     require("ltex_extra").setup()
  --
  --     -- NOTE: ltex consume too much memory. Stop ltex when commit message is closed.
  --     local ltex_augroup_id = vim.api.nvim_create_augroup("ltex_settings", {})
  --     vim.api.nvim_create_autocmd({ "BufUnload" }, {
  --       group = ltex_augroup_id,
  --       pattern = "COMMIT_EDITMSG",
  --       callback = function()
  --         vim.cmd([[LspStopIdleServers]])
  --       end,
  --     })
  --   end,
  -- },
  -- TODO: Add recommended config from nvim-lspconfig.
  -- Ref: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
  lua_ls = {
    -- TODO: Refine condition
    condition = plugin_utils.has_linux_build_env(),
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
      },
    },
  },
  marksman = {},
  neocmake = {
    condition = plugin_utils.has_linux_build_env(),
  },
  perlnavigator = {},
  -- pyls_ms = {},
  -- NOTE: use plugins: pyflakes, pycodestyle, pyls-flake8, pylsp-mypy, python-lsp-black, python-lsp-ruff
  -- TODO: Replaced with ruff server when completion is supported
  -- Ref: https://astral.sh/blog/ruff-v0.4.5
  pylsp = {
    on_attach = function(client, bufnr)
      local python = require("vimrc.ftplugins.python")

      python.check_pylsp_linter_feasibility(bufnr)
      python.setup_mappings()
    end,
    settings = require("vimrc.ftplugins.python").pylsp_default_settings,
  },
  -- TODO: pylyzer not supporting documentSymbolProvider, disabled for now
  -- pylyzer = {},
  -- TODO: Use pyright again, seems to have better performance with higher CPU usages
  -- TODO: Check pyright settings disableLanguageServices
  -- ref: https://github.com/microsoft/pyright/blob/893d08be8c70297fcf082ba812c14cf4aecefc97/docs/settings.md
  -- pyright = {},
  -- NOTE: Use rustaceanvim to setup custom lsp to use rust_analyzer
  -- rust_analyzer = {
  --   condition = plugin_utils.has_linux_build_env(),
  -- },
  solargraph = {
    condition = plugin_utils.has_linux_build_env(),
  },
  sqls = {
    -- TODO: sqls requires Go 1.21
    condition = plugin_utils.has_linux_build_env(),
    -- Check settings example: https://github.com/sqls-server/sqls
  },
  -- NOTE: Use vtsls
  -- tsserver = {
  --   custom_setup = function(server, lsp_opts)
  --     require("typescript").setup({
  --         disable_commands = false, -- prevent the plugin from creating Vim commands
  --         debug = false, -- enable debug logging for commands
  --         go_to_source_definition = {
  --             fallback = true, -- fall back to standard LSP definition on failure
  --         },
  --         server = lsp_opts,
  --     })
  --   end,
  -- },
  vtsls = {
    -- Ref: [LazyVim TypeScript config](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/typescript.lua)
    -- Ref: [LazyVim Vue config](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/vue.lua)
    -- Ref: [AstroNvim TypeScript config](https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/typescript/init.lua)
    -- Ref: [AstroNvim Vue config](https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/pack/vue/init.lua)
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        experimental = {
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
        tsserver = {
          globalPlugins = {
            -- Use typescript language server along with vue typescript plugin
            {
              name = "@vue/typescript-plugin",
              -- TODO: Move to custom setup to avoid error when vue plugin is not installed
              location = vue_typescript_plugin,
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
      typescript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
      javascript = {
        updateImportsOnFileMove = { enabled = "always" },
        suggest = {
          completeFunctionCalls = true,
        },
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          parameterNames = { enabled = "literals" },
          parameterTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          variableTypes = { enabled = false },
        },
      },
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
    },
  },
  tailwindcss = {},
  -- NOTE: Use vtsls
  -- ["typescript-tools"] = {
  --   capabilities = {
  --     textDocument = {
  --       foldingRange = {
  --         dynamicRegistration = true,
  --       },
  --     },
  --   },
  --   settings = {
  --     -- Ref: LazyVim
  --     typescript = {
  --       format = {
  --         indentSize = vim.o.shiftwidth,
  --         convertTabsToSpaces = vim.o.expandtab,
  --         tabSize = vim.o.tabstop,
  --       },
  --     },
  --     javascript = {
  --       format = {
  --         indentSize = vim.o.shiftwidth,
  --         convertTabsToSpaces = vim.o.expandtab,
  --         tabSize = vim.o.tabstop,
  --       },
  --     },
  --     completions = {
  --       completeFunctionCalls = true,
  --     },
  --   },
  -- },
  vimls = {},
  volar = {},
  -- TODO: add settings for schemas
  yamlls = {
    settings = {},
    custom_setup = function(server, lsp_opts)
      lsp_opts.settings.yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
      }
      require("lspconfig")[server].setup(lsp_opts)
    end,
  },
  -- NOTE: Failed to install zk 0.11.1, try marksman
  -- zk = {},
}
lsp.servers_by_filetype = {}
lsp.server_setuped = {}

lsp.on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

lsp.show_doc = function()
  local ufo = require("ufo")

  -- preview fold > vim help | lsp hover
  local winid = ufo.peekFoldedLinesUnderCursor()
  if not winid then
    if vim.o.filetype == "help" then
      vim.cmd([[help ]] .. vim.fn.expand("<cword>"))
    else
      vim.cmd([[Lspsaga hover_doc]])
    end
  end
end

lsp.on_attach = function(client, bufnr)
  -- Plugins
  if choose.is_enabled_plugin("nvim-navic") and client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end
  if choose.is_enabled_plugin("nvim-navbuddy") and client.server_capabilities.documentSymbolProvider then
    require("nvim-navbuddy").attach(client, bufnr)
  end
  if client.server_capabilities.signatureHelpProvider then
    require("vimrc.plugins.lsp_overloads").on_attach(client)
  end

  -- My plugin configs
  my_lspsaga.on_attach(client)
  my_goto_preview.on_attach(client)

  nnoremap("K", function()
    require("vimrc.lsp").show_doc()
  end, "silent", "buffer")
  nnoremap("gD", function()
    vim.lsp.buf.definition()
  end, "silent", "buffer")
  nnoremap("1gD", function()
    vim.lsp.buf.type_definition()
  end, "silent", "buffer")
  nnoremap("gR", function()
    vim.lsp.buf.references()
  end, "silent", "buffer")
  nnoremap("g0", function()
    vim.lsp.buf.document_symbol()
  end, "silent", "buffer")
  nnoremap("gy", function()
    vim.lsp.buf.signature_help()
  end, "silent", "buffer")
  nnoremap("<Space>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "silent", "buffer")
  vim.keymap.set("x", "<Space>lf", vim.lsp.buf.format, { silent = true, buffer = true })
  nnoremap("<Space>lI", function()
    if vim.fn.exists(":LspInfo") == 2 then
      vim.cmd([[LspInfo]])
    elseif vim.fn.exists(":Lsp") == 2 then
      vim.cmd([[Lsp info]])
    else
      vim.notify("No LSP info!", vim.log.levels.ERROR)
    end
  end, "silent", "buffer")
  nnoremap("yof", function()
    require("vimrc.lsp").toggle_format_on_sync()
  end, "silent", "buffer")
  nnoremap("yoo", function()
    require("vimrc.lsp").toggle_show_diagnostics()
  end, "silent", "buffer")
  nnoremap("yoI", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "silent", "buffer")

  -- NOTE: Enable inlay hints
  vim.lsp.inlay_hint.enable(true)

  vim.bo.omnifunc = [[v:lua.vim.lsp.omnifunc]]
  vim.bo.tagfunc = [[v:lua.vim.lsp.tagfunc]]
  vim.bo.formatexpr = [[v:lua.vim.lsp.formatexpr({})]]
  -- NOTE: Always enable 'signcolumn' on LSP attached buffer to avoid diagnostics keeping toggling 'signcolumn'
  vim.wo.signcolumn = "yes"

  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[augroup lsp_format_on_save]])
    vim.cmd([[  autocmd! * <buffer>]])
    vim.cmd([[  autocmd BufWritePre <buffer> lua require("vimrc.lsp").formatting_sync()]])
    vim.cmd([[augroup END]])
  end

  -- TODO: Fix the 'signcolumn' of not-current window to avoid window layout kept being changed

  vim.cmd([[ do User LspAttachBuffers ]])
end

lsp.get_servers = function()
  local checked_servers = {}

  for server_name, server_opts in pairs(lsp.servers) do
    -- NOTE: We only exclude server with condition == false, but include server
    -- without condition
    if server_opts.condition == false then
      -- do not include server
    else
      checked_servers[server_name] = server_opts
    end
  end

  return checked_servers
end

lsp.calculate_server_opts = function(server, custom_opts)
  local lsp_opts = lsp.servers[server] or {}
  lsp_opts = vim.tbl_deep_extend("keep", lsp_opts, custom_opts or {})

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  -- nvim-ufo support foldingRange
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- NOTE: Use `fswatch` to watch file changes
  -- Ref: https://github.com/neovim/neovim/pull/27347
  if choose.is_disabled_plugin("nvim-lsp-workspace-didChangeWatchedFiles") then
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  else
    -- TODO: neovim 0.10.0 nightly currently disable "workspace/didChangeWatchedFiles" on Linux
    -- Ref: https://github.com/neovim/neovim/commit/c1a95d9653f39c5e118d030270e4b77ebd20139e
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  end

  -- Allow customizing each lsp server's capabilities
  capabilities = vim.tbl_deep_extend("force", capabilities, lsp_opts.capabilities or {})

  lsp_opts = vim.tbl_extend("keep", lsp_opts, {
    flags = {
      debounce_text_changes = 150,
    },
  })
  -- NOTE: Call general on_init/on_attach then LSP-specific on_init/on_attach.
  local lsp_opts_on_init = lsp_opts.on_init
  local lsp_opts_on_attach = lsp_opts.on_attach
  lsp_opts = vim.tbl_extend("force", lsp_opts, {
    on_init = function(...)
      lsp.on_init(...)
      if lsp_opts_on_init then
        lsp_opts_on_init(...)
      end
    end,
    on_attach = function(...)
      lsp.on_attach(...)
      if lsp_opts_on_attach then
        lsp_opts_on_attach(...)
      end
    end,
    capabilities = capabilities,
  })

  return lsp_opts
end

lsp.setup_server = function(server, custom_opts)
  local lsp_opts = lsp.calculate_server_opts(server, custom_opts)

  -- NOTE: Lazy load init options
  if type(lsp_opts.init_options) == "function" then
    lsp_opts.init_options = lsp_opts.init_options()
  end

  if lsp_opts.custom_setup then
    lsp_opts.custom_setup(server, lsp_opts)
  else
    require("lspconfig")[server].setup(lsp_opts)
  end

  lsp.server_setuped[server] = true
end

lsp.supported_servers = nil
lsp.is_supported_server = function(server)
  if not lsp.supported_servers then
    lsp.supported_servers = {}
    for server_name, server_opts in pairs(lsp.servers) do
      -- NOTE: We only exclude server with condition == false, but include server
      -- without condition
      if server_opts.condition == false then
        -- do not include server
      else
        lsp.supported_servers[server_name] = server_opts
      end
    end
  end

  return lsp.supported_servers[server] ~= nil
end

lsp.init_servers_by_filetype = function()
  local mason_lspconfig_mappings_filetype = require("mason-lspconfig.mappings.filetype")

  for filetype, servers in pairs(mason_lspconfig_mappings_filetype) do
    for _, server in ipairs(servers) do
      if lsp.is_supported_server(server) then
        if not lsp.servers_by_filetype[filetype] then
          lsp.servers_by_filetype[filetype] = {}
        end

        table.insert(lsp.servers_by_filetype[filetype], server)
      end
    end
  end
end

-- TODO: Monitor if there's multiple lsp servers attached to buffer which has
-- different lsp server configuration
lsp.setup_servers_on_filetype = function(filetype)
  if not lsp.servers_by_filetype[filetype] then
    return
  end

  for _, server in ipairs(lsp.servers_by_filetype[filetype]) do
    if not lsp.server_setuped[server] then
      -- NOTE: We delegate install to mason-tool-installer.nvim and do not try
      -- to install LSP on filetype. Because it seems a little hard to wait for
      -- installation finished.
      lsp.setup_server(server, {})

      -- TODO: Change to vim.lsp.start()
      require("lspconfig")[server].launch()
    end
  end
end

lsp.setup_lsp_install = function()
  local mason_lspconfig_mappings_server = require("mason-lspconfig.mappings.server")
  local mason_tool_installer = require("mason-tool-installer")

  local lspconfig_servers = vim.tbl_keys(lsp.get_servers())
  -- TODO: Check if this can be precompiled to improve startup time
  local mason_package_servers = {}

  for _, lspconfig_server in ipairs(lspconfig_servers) do
    table.insert(mason_package_servers, mason_lspconfig_mappings_server.lspconfig_to_package[lspconfig_server])
  end

  mason_tool_installer.setup({
    ensure_installed = mason_package_servers,
  })
end

lsp.setup_plugins = function()
  my_lspsaga.setup()
end

lsp.setup_commands = function()
  vim.api.nvim_create_user_command("LspStopIdleServers", function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if #client.attached_buffers == 0 then
        client.stop()
      end
    end
  end, {})
end

lsp.setup = function(settings)
  lsp.config = vim.tbl_extend("force", lsp.config, settings)

  lsp.init_servers_by_filetype()
  lsp.setup_lsp_install()
  lsp.setup_plugins()
  lsp.setup_commands()

  -- TODO: Maybe setup basic lsp server?
  local lsp_setup_server_on_ft_augroup_id = vim.api.nvim_create_augroup("lsp_setup_server_on_ft", {})
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = lsp_setup_server_on_ft_augroup_id,
    pattern = "*",
    callback = function()
      lsp.setup_servers_on_filetype(vim.bo.filetype)
    end,
  })
end

-- TODO: project level notify
lsp.notify_settings = function(server, settings)
  for _, lsp_client in ipairs(vim.lsp.get_clients({ name = server })) do
    lsp_client.config.settings = vim.tbl_deep_extend("force", lsp_client.config.settings, settings)
    lsp_client.notify("workspace/didChangeConfiguration", {
      settings = lsp_client.config.settings,
    })
  end
end

-- TODO: Rename to format to follow neovim's API
lsp.formatting_sync = function()
  if lsp.config.enable_format_on_sync then
    vim.lsp.buf.formatting_sync()
  end
end

lsp.toggle_format_on_sync = function()
  lsp.config.enable_format_on_sync = not lsp.config.enable_format_on_sync
end

lsp.toggle_show_diagnostics = function()
  lsp.config.show_diagnostics = not lsp.config.show_diagnostics
  if lsp.config.show_diagnostics then
    vim.diagnostic.show()
  else
    vim.diagnostic.hide()
  end
end

return lsp
