local my_goto_preview = require("vimrc.plugins.goto-preview")

local check = require("vimrc.check")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

lsp.config = {
  enable_format_on_sync = false,
}

lsp.servers = {
  ["*"] = {
    capabilities = (function(override)
      -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
      return vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        override or {}
      )
    end)({
      textDocument = {
        -- nvim-ufo support textDocument.foldingRange
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = false,
        },
        -- neovim 0.12 support textDocument.onTypeFormatting
        onTypeFormatting = {
          dynamicRegistration = false,
        },
      },
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = not choose.is_disabled_plugin("nvim-lsp-workspace-didChangeWatchedFiles"),
        },
      },
    }),
    flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    },
    on_attach = function(client, bufnr)
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
      my_goto_preview.on_attach(client)

      -- Setup keymaps
      vim.keymap.set("n", "K", function()
        require("vimrc.lsp").show_doc()
      end, { silent = true, buffer = true, desc = "LSP show hover documentation" })
      vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
      end, { silent = true, buffer = true, desc = "LSP show definition" })
      vim.keymap.set("n", "1gD", function()
        vim.lsp.buf.type_definition()
      end, { silent = true, buffer = true, desc = "LSP show type definition" })
      vim.keymap.set("n", "2gD", function()
        vim.lsp.buf.declaration()
      end, { silent = true, buffer = true, desc = "LSP show declaration" })
      vim.keymap.set("n", "gi", function()
        vim.lsp.buf.implementation()
      end, { silent = true, buffer = true, desc = "LSP show definition" })
      vim.keymap.set("n", "gR", function()
        vim.lsp.buf.references()
      end, { silent = true, buffer = true, desc = "LSP show references" })
      vim.keymap.set("n", "g0", function()
        vim.lsp.buf.document_symbol()
      end, { silent = true, buffer = true, desc = "LSP show document symbol" })
      vim.keymap.set("n", "gy", function()
        vim.lsp.buf.signature_help()
      end, { silent = true, buffer = true, desc = "LSP show signature help" })
      vim.keymap.set("n", "<Space>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { silent = true, buffer = true, desc = "LSP format" })
      vim.keymap.set("x", "<Space>lf", vim.lsp.buf.format, { silent = true, buffer = true, desc = "LSP format" })
      vim.keymap.set("n", "<Space>lI", function()
        if vim.fn.exists(":LspInfo") == 2 then
          vim.cmd([[LspInfo]])
        elseif vim.fn.exists(":Lsp") == 2 then
          vim.cmd([[Lsp info]])
        else
          vim.notify("No LSP info!", vim.log.levels.ERROR)
        end
      end, { silent = true, buffer = true, desc = "LSP show info" })
      vim.keymap.set("n", "yof", function()
        require("vimrc.lsp").toggle_format_on_sync()
      end, { silent = true, buffer = true, desc = "LSP toggle format on sync" })
      -- TODO: Add key mapping to toggle inlay hints globally
      vim.keymap.set("n", "yoI", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { silent = true, buffer = true, desc = "LSP toggle inlay hints" })

      -- Remap for K
      local maparg
      maparg = vim.fn.maparg("gK", "n", false, true)
      if maparg == {} or maparg["buffer"] ~= 1 then
        vim.keymap.set("n", "gK", "K", { buffer = true })
      end
      -- Remap for gi
      maparg = vim.fn.maparg("gI", "n", false, true)
      if maparg == {} or maparg["buffer"] ~= 1 then
        vim.keymap.set("n", "gI", "gi", { buffer = true })
      end
      -- Remap for gI
      maparg = vim.fn.maparg("g<C-I>", "n", false, true)
      if maparg == {} or maparg["buffer"] ~= 1 then
        vim.keymap.set("n", "g<C-I>", "gI", { buffer = true })
      end

      if vim.b.disable_inlay_hints ~= true then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      vim.lsp.document_color.enable(true, bufnr)
      vim.lsp.on_type_formatting.enable(true)

      vim.bo.omnifunc = [[v:lua.vim.lsp.omnifunc]]
      vim.bo.tagfunc = [[v:lua.vim.lsp.tagfunc]]
      vim.bo.formatexpr = [[v:lua.vim.lsp.formatexpr({})]]
      -- NOTE: Enable 'signcolumn' on LSP attached buffer if it's not a "nofile" buffer to avoid diagnostics keeping toggling 'signcolumn'
      -- TODO: This check seems only work when calling hover request after a while after the LSP is
      -- initialized and ready to show hover.
      if vim.bo[bufnr].buftype ~= "nofile" then
        vim.wo.signcolumn = "yes"
      end

      -- Setup commands
      vim.api.nvim_buf_create_user_command(bufnr, "LspLog", function()
        vim.cmd.split(vim.lsp.log.get_filename())
      end, { desc = "Open LSP log in split" })

      -- format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[augroup lsp_format_on_save]])
        vim.cmd([[  autocmd! * <buffer>]])
        vim.cmd([[  autocmd BufWritePre <buffer> lua require("vimrc.lsp").formatting_sync()]])
        vim.cmd([[augroup END]])
      end

      -- TODO: Fix the 'signcolumn' of not-current window to avoid window layout kept being changed
      -- TODO: Fix LSP attached to artificial buffers like fugitive buffers due to using `vim.lsp.enable`.
      -- The `vim.lsp.enable` is used in `LspStart`, `LspStop`, `LspRestart` commands defined in
      -- nvim-lspconfig.
      -- Ref: https://github.com/neovim/neovim/issues/33225
      -- Ref: https://github.com/neovim/neovim/issues/33061#issuecomment-2754364821
      -- Ref: https://github.com/neovim/nvim-lspconfig/pull/3734

      vim.cmd([[ do User LspAttachBuffers ]])
    end,
  },
  basedpyright = {
    -- NOTE: basedpyright watch too many files, disable workspace/didChangeWatchedFiles dynamic registration
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
        },
      },
    },
  },
  bashls = {
    settings = {
      -- NOTE: If want to disable shellcheck integration and use nvim-lint to lint on save, set this
      -- to empty string
      -- shellcheckPath = "",
    },
  },
  buf_ls = {
    condition = check.has_linux_build_env(),
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
    condition = check.has_linux_build_env(),
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
    capabilities = {
      memoryUsageProvider = true,
    },
    -- NOTE: Disable clangd on protobuf
    -- Ref: https://github.com/neovim/nvim-lspconfig/pull/2125#issuecomment-1291968687
    filetypes = { "c", "cpp" },
  },
  -- TODO: Detect deno.json for denols
  -- denols = {
  --   init_options = {
  --     enable = true,
  --     lint = true,
  --     unstable = true,
  --   },
  -- },
  esbonio = {},
  -- TODO: Suppress the error log of not finding eslint in local repo
  eslint = {
    condition = check.has_linux_build_env(),
  },
  gopls = {
    condition = check.has_linux_build_env(),
  },
  harper_ls = {
    condition = check.has_linux_build_env(),
    settings = {
      ["harper-ls"] = {
        -- NOTE: Use workspace dictionary introduced in harper 0.55.0
        -- Ref: https://github.com/Automattic/harper/pull/1669
        -- Ref: https://writewithharper.com/docs/integrations/language-server#Workspace-Dictionary
        linters = {
          ToDoHyphen = false,
        },
      },
    },
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
    on_attach = function(client)
      vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
    end,
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
    custom_config = function(lsp_opts)
      lsp_opts.settings.json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      }

      return lsp_opts
    end,
  },
  -- TODO: Add recommended config from nvim-lspconfig.
  -- Ref: https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/lua_ls.lua
  lua_ls = {
    -- TODO: Refine condition
    condition = check.has_linux_build_env(),
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
    condition = check.has_linux_build_env(),
  },
  nushell = {
    condition = plugin_utils.is_executable("nu"),
  },
  perlnavigator = {},
  -- NOTE: Use rustaceanvim to setup custom lsp to use rust_analyzer
  -- rust_analyzer = {
  --   condition = check.has_linux_build_env(),
  -- },
  rustaceanvim = {
    condition = check.has_linux_build_env(),
    mason = false,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
        cargo = {
          loadOutDirsFromCheck = true,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
  ruff = {
    on_attach = function(client)
      -- Disable hover in favor of basedpyright
      client.server_capabilities.hoverProvider = false
    end,
  },
  solargraph = {
    condition = check.has_linux_build_env(),
  },
  sqls = {
    -- TODO: sqls requires Go 1.21
    condition = check.has_linux_build_env(),
    -- Check settings example: https://github.com/sqls-server/sqls
  },
  vtsls = {
    condition = check.has_linux_build_env(),
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
        tsserver = {},
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
    custom_config = function(lsp_opts)
      -- Setup global plugins
      if check.has_linux_build_env() then
        -- NOTE: mason.nvim 2.0 does not support getting installation path of LSP server
        -- Instead, we get the executable path of vue-language-server and use it to get the typescript
        -- plugin path.
        local vue_typescript_plugin = vim.fs.dirname(
          vim.fs.dirname(vim.fn.resolve(vim.fn.exepath("vue-language-server")))
        ) .. "/node_modules/@vue/typescript-plugin"

        lsp_opts.settings.vtsls.tsserver.globalPlugins = {
          -- Use typescript language server along with vue typescript plugin
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        }
      end

      return lsp_opts
    end,
  },
  -- NOTE: Disabled due to high CPU usage
  -- Ref: https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1109
  -- TODO: Enable tailwindcss
  -- Ref: https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1109#issuecomment-2612844262
  -- tailwindcss = {},
  vimls = {},
  -- TODO: Rename to vue_ls
  -- Not sure why nvim-lspconfig complains that vue_ls not found
  -- Ref: https://github.com/neovim/nvim-lspconfig/pull/3843
  volar = {
    condition = check.has_linux_build_env(),
  },
  -- TODO: add settings for schemas
  yamlls = {
    settings = {},
    custom_config = function(lsp_opts)
      lsp_opts.settings.yaml = {
        schemaStore = {
          -- NOTE: Use SchemaStore.nvim to provide schemas
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
        schemas = require("schemastore").yaml.schemas(),
        validate = { enable = true },
      }

      return lsp_opts
    end,
  },
}

lsp.show_doc = function()
  if choose.is_enabled_plugin("nvim-ufo") then
    -- preview fold > normal hover
    local ufo_winid = require("ufo").peekFoldedLinesUnderCursor()
    if ufo_winid then
      return
    end
  end

  local current_filetype = vim.bo.filetype

  -- Setup filetype-specific actions
  local filetype_actions = {
    {
      filetypes = { "help", "vim" },
      action = function()
        vim.cmd("help " .. vim.fn.expand("<cword>"))
      end,
    },
    {
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
      action = function()
        require("better-type-hover").better_type_hover()
      end,
    },
  }

  -- Find and execute a filetype-specific action
  for _, handler_spec in ipairs(filetype_actions) do
    if vim.tbl_contains(handler_spec.filetypes, current_filetype) then
      handler_spec.action()
      return
    end
  end

  -- Default action if no specific handler was found
  vim.lsp.buf.hover({
    border = "rounded",
  })
end

lsp.get_servers = function(for_mason)
  local checked_servers = {}

  for server_name, server_opts in pairs(lsp.servers) do
    -- NOTE: We only exclude server with condition == false, but include server
    -- without condition
    -- NOTE: Ignore wildcard server name '*'
    if server_opts.condition == false or server_name == "*" then
      -- do not include server
    elseif for_mason and server_opts.mason == false then
      -- do not include server
    else
      checked_servers[server_name] = server_opts
    end
  end

  return checked_servers
end

lsp.calculate_server_opts = function(server, custom_opts)
  return vim.tbl_deep_extend("force", lsp.servers[server] or {}, custom_opts or {})
end

lsp.setup_server = function(server, custom_opts)
  local lsp_opts = lsp.calculate_server_opts(server, custom_opts)

  -- NOTE: Lazy load init options
  if type(lsp_opts.init_options) == "function" then
    lsp_opts.init_options = lsp_opts.init_options()
  end

  if lsp_opts.custom_config then
    lsp_opts = lsp_opts.custom_config(lsp_opts)
  end

  vim.lsp.config(server, lsp_opts)
end

lsp.init_mason_map = function()
  -- mason-lspconfig.nvim 2.1.0 filetype mappings
  -- Ref: https://github.com/mason-org/mason-lspconfig.nvim/pull/555
  lsp.mason_map = require("mason-lspconfig.mappings").get_all()
end

lsp.setup_servers = function()
  vim.lsp.config("*", lsp.servers["*"] or {})

  for server, _ in pairs(lsp.get_servers()) do
    -- NOTE: We delegate install to mason-tool-installer.nvim and do not try
    -- to install LSP on filetype. Because it seems a little hard to wait for
    -- installation finished.
    lsp.setup_server(server, {})
    vim.lsp.enable(server)
  end
end

lsp.setup_lsp_install = function()
  local mason_tool_installer = require("mason-tool-installer")

  local lspconfig_servers = vim.tbl_keys(lsp.get_servers(true))
  -- TODO: Check if this can be precompiled to improve startup time
  local mason_package_servers = {}

  -- TODO: Use mason-lspconfig api
  -- FIXME: This may have a bug that causing 'harper_ls' not installed
  for _, lspconfig_server in ipairs(lspconfig_servers) do
    table.insert(mason_package_servers, lsp.mason_map.lspconfig_to_package[lspconfig_server])
  end

  mason_tool_installer.setup({
    ensure_installed = mason_package_servers,
  })
end

lsp.setup_plugins = function()
  -- Do nothing for now
end

lsp.setup_commands = function()
  vim.api.nvim_create_user_command("LspStopIdleServers", function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      if #client.attached_buffers == 0 then
        client:stop()
      end
    end
  end, {})
end

lsp.setup = function(settings)
  lsp.config = vim.tbl_extend("force", lsp.config, settings)

  lsp.init_mason_map()
  lsp.setup_lsp_install()
  lsp.setup_servers()
  lsp.setup_plugins()
  lsp.setup_commands()
end

-- TODO: project level notify
-- TODO: Improve notify settings
-- See [neoconf.nvimluaneoconfpluginslspconfig.lua at 4a36457c389fab927c885d53fba6e07f4eedf1f4 · folkeneoconf.nvim](https://github.com/folke/neoconf.nvim/blob/4a36457c389fab927c885d53fba6e07f4eedf1f4/lua/neoconf/plugins/lspconfig.lua#L67) as reference
lsp.notify_settings = function(server, settings)
  for _, lsp_client in ipairs(vim.lsp.get_clients({ name = server })) do
    lsp_client.config.settings = vim.tbl_deep_extend("force", lsp_client.config.settings or {}, settings)
    lsp_client:notify("workspace/didChangeConfiguration", {
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

return lsp
