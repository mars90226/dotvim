local my_goto_preview = require("vimrc.plugins.goto-preview")

local check = require("vimrc.check")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local lsp = {}

lsp.config = {
  enable_format_on_sync = false,
}

lsp.servers = {
  ["*"] = {
    settings = {},
    before_init = function(params, config)
      require("vimrc.plugins.codesettings").before_init(params, config)
    end,
    capabilities = (function(override)
      -- Enable some language servers with the additional completion capabilities offered by blink.cmp
      return vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities(),
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
      if client.server_capabilities.signatureHelpProvider then
        require("vimrc.plugins.lsp_overloads").on_attach(client)
      end

      -- My plugin configs
      my_goto_preview.on_attach(client)

      -- Setup keymaps
      -- TODO: Consider special buffers that have buffer key mappings
      utils.set_keymap("n", "K", function()
        require("vimrc.lsp").show_doc()
      end, { silent = true, buffer = true, desc = "LSP show hover documentation" }, "global")
      utils.set_keymap("n", "gd", function()
        vim.lsp.buf.definition()
      end, { silent = true, buffer = true, desc = "LSP show definition" }, "global")
      utils.set_keymap("n", "1gD", function()
        vim.lsp.buf.type_definition()
      end, { silent = true, buffer = true, desc = "LSP show type definition" }, "global")
      utils.set_keymap("n", "2gD", function()
        vim.lsp.buf.declaration()
      end, { silent = true, buffer = true, desc = "LSP show declaration" }, "global")
      utils.set_keymap("n", "gi", function()
        vim.lsp.buf.implementation()
      end, { silent = true, buffer = true, desc = "LSP show definition" }, "global")
      utils.set_keymap("n", "gR", function()
        vim.lsp.buf.references()
      end, { silent = true, buffer = true, desc = "LSP show references" }, "global")
      utils.set_keymap("n", "g0", function()
        vim.lsp.buf.document_symbol()
      end, { silent = true, buffer = true, desc = "LSP show document symbol" }, "global")
      utils.set_keymap("n", "gy", function()
        vim.lsp.buf.signature_help()
      end, { silent = true, buffer = true, desc = "LSP show signature help" }, "global")
      utils.set_keymap("n", "<Space>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { silent = true, buffer = true, desc = "LSP format" }, "global")
      utils.set_keymap("x", "<Space>lf", vim.lsp.buf.format, { silent = true, buffer = true, desc = "LSP format" }, "global")
      utils.set_keymap("n", "<Space>lI", function()
        if vim.fn.exists(":LspInfo") == 2 then
          vim.cmd([[LspInfo]])
        elseif vim.fn.exists(":Lsp") == 2 then
          vim.cmd([[Lsp info]])
        else
          vim.notify("No LSP info!", vim.log.levels.ERROR)
        end
      end, { silent = true, buffer = true, desc = "LSP show info" }, "global")
      utils.set_keymap("n", "yof", function()
        require("vimrc.lsp").toggle_format_on_sync()
      end, { silent = true, buffer = true, desc = "LSP toggle format on sync" }, "global")
      -- TODO: Add key mapping to toggle inlay hints globally
      utils.set_keymap("n", "coi", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { silent = true, buffer = true, desc = "LSP toggle inlay hints" }, "global")

      -- Remap for K
      utils.set_keymap("n", "gK", "K", { buffer = true }, "global")
      -- Remap for gi
      utils.set_keymap("n", "gI", "gi", { buffer = true }, "global")
      -- Remap for gI
      utils.set_keymap("n", "g<C-I>", "gI", { buffer = true }, "global")

      if vim.b.disable_inlay_hints ~= true then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      vim.lsp.document_color.enable(true, { bufnr = bufnr })
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
        vim.cmd([[  autocmd BufWritePre <buffer> lua require("vimrc.lsp").format_sync()]])
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
  -- TODO: Monitor the performance of watcher for workspace/didChangeWatchedFiles
  basedpyright = {},
  bashls = {
    settings = {
      bashIde = {
        -- NOTE: If want to disable shellcheck integration and use nvim-lint to lint on save, set this
        -- to empty string
        -- It seems that bashls always use `--external-sources`, which makes it use too much CPU and
        -- memory when there are many files in the workspace.
        -- Ref: https://github.com/bash-lsp/bash-language-server/blob/main/server/src/shellcheck/index.ts#L124
        -- TODO: Enable it again when the performance issue is fixed
        shellcheckPath = "",
        -- NOTE: Disable shellcheck's extend analysis to reduce CPU usage and OOM issue
        -- Ref: https://github.com/bash-lsp/bash-language-server/issues/1267
        -- Ref: https://github.com/koalaman/shellcheck/issues/3177#issuecomment-2767641325
        shellcheckArguments = { "--extended-analysis=false" },
      }
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
    -- NOTE: nvim-lspconfig attaches harper_ls to most programming languages to check comments, which
    -- keeps it running in most sessions. Only start it for prose by default, and use
    -- `:LspEnableHarperForCode` to restore nvim-lspconfig's filetypes.
    filetypes = { "asciidoc", "gitcommit", "jjdescription", "markdown", "tex", "typst" },
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
        },
      },
    },
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
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
        },
      },
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
  -- NOTE: Use emmylua_ls instead of lua_ls for lower memory usage. Library is provided by lazydev.nvim
  -- through `vimrc.plugins.lazydev`.
  emmylua_ls = {
    -- TODO: Refine condition
    condition = check.has_linux_build_env(),
    settings = {
      emmylua = {
        runtime = {
          version = "LuaJIT",
        },
      },
    },
  },
  marksman = {
    -- NOTE: marksman can grow without bound and push the machine into swap thrashing before the
    -- kernel OOM killer reacts. Cap the .NET GC heap at 1 GiB so marksman fails alone instead.
    cmd_env = {
      DOTNET_GCHeapHardLimit = "0x40000000",
    },
  },
  neocmake = {
    condition = check.has_linux_build_env(),
  },
  nginx_language_server = {},
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
  -- TODO: Disabled due to high RAM usage & seldom use
  -- tailwindcss = {
  --   capabilities = {
  --     workspace = {
  --       didChangeWatchedFiles = {
  --         dynamicRegistration = false,
  --       },
  --     },
  --   },
  -- },
  vimls = {},
  vue_ls = {
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
  local before_init = vim.lsp.config[server].before_init
  if before_init and before_init ~= lsp.servers["*"].before_init then
    vim.lsp.config(server, {
      before_init = function(params, config)
        local ok, err = pcall(lsp.servers["*"].before_init, params, config)
        before_init(params, config)
        if not ok then
          error(err, 0)
        end
      end,
    })
  end
end

lsp.setup_servers = function()
  vim.lsp.config("*", lsp.servers["*"] or {})

  for server, _ in pairs(lsp.get_servers()) do
    -- Mason installs tools separately from filetype-based LSP activation.
    lsp.setup_server(server, {})
    vim.lsp.enable(server)
  end
end

local function get_mason_packages()
  local packages = require("mason-lspconfig").get_mappings().lspconfig_to_package
  local ensure_installed = {}

  for server in pairs(lsp.get_servers(true)) do
    local package = packages[server]
    if package then
      table.insert(ensure_installed, package)
    end
  end

  return ensure_installed
end

local function install_cached_mason_packages(registry, names)
  local pending, attempted = {}, {}
  for _, name in ipairs(names) do
    if registry.has_package(name) then
      local package = registry.get_package(name)
      if not package:is_installed() and not package:is_installing() and not package:is_uninstalling() then
        table.insert(pending, package)
        table.insert(attempted, name)
      end
    end
  end

  local remaining = #pending
  local function complete()
    vim.api.nvim_exec_autocmds("User", { pattern = "MasonToolsUpdateCompleted", data = attempted })
  end

  if remaining == 0 then
    complete()
    return
  end

  -- Keep mason-tool-installer's event contract when bypassing its registry refresh.
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "MasonToolsStartingInstall" })
  end)
  for _, package in ipairs(pending) do
    local on_install = vim.schedule_wrap(function(success)
      if success then
        vim.notify("Mason installed " .. package.name)
      else
        vim.notify("Mason failed to install " .. package.name, vim.log.levels.ERROR)
      end
      remaining = remaining - 1
      if remaining == 0 then
        complete()
      end
    end)
    package:install({}, on_install)
  end
end

lsp.setup_lsp_install = function()
  local mason_tool_installer = require("mason-tool-installer")
  local registry = require("mason-registry")
  local ensure_installed = get_mason_packages()
  local install_on_start = vim.v.vim_did_enter == 0

  -- Manual installer commands need the cached list even while a refresh is pending.
  mason_tool_installer.setup({ run_on_start = false, ensure_installed = ensure_installed })
  registry.refresh(vim.schedule_wrap(function(success, updated_registries)
    if success and #updated_registries > 0 then
      ensure_installed = get_mason_packages()
      mason_tool_installer.setup({ ensure_installed = ensure_installed })
    end
    if not install_on_start or #ensure_installed == 0 then
      return
    end

    local function install()
      if success then
        mason_tool_installer.check_install()
        return
      end

      -- The tool installer would retry the failed refresh before using the cached list.
      install_cached_mason_packages(registry, ensure_installed)
    end

    -- A startup command can process the registry callback before VimEnter.
    if vim.v.vim_did_enter == 1 then
      install()
      return
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        vim.schedule(install)
      end,
    })
  end))
end

lsp.setup_plugins = function()
  -- Do nothing for now
end

lsp.setup_commands = function()
  vim.api.nvim_create_user_command("LspStopOptionalServers", function()
    vim.lsp.enable({ "harper_ls", "marksman" }, false)
  end, { desc = "Stop optional LSP servers and disable automatic startup for this session" })

  vim.api.nvim_create_user_command("LspEnableHarperForCode", function()
    if not lsp.get_servers().harper_ls then
      vim.notify("harper_ls is not available in this environment", vim.log.levels.WARN)
      return
    end

    local default_config = dofile(vim.api.nvim_get_runtime_file("lsp/harper_ls.lua", false)[1])
    vim.lsp.config("harper_ls", { filetypes = default_config.filetypes })
    -- Also attaches to already loaded buffers
    vim.lsp.enable("harper_ls")
  end, { desc = "Enable harper_ls for all filetypes supported by nvim-lspconfig in this session" })

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

  lsp.setup_lsp_install()
  lsp.setup_servers()
  lsp.setup_plugins()
  lsp.setup_commands()
end

-- TODO: project level notify
-- TODO: Improve notify settings
lsp.notify_settings = function(server, settings)
  for _, lsp_client in ipairs(vim.lsp.get_clients({ name = server })) do
    lsp_client.config.settings = vim.tbl_deep_extend("force", lsp_client.config.settings or {}, settings)
    lsp_client:notify("workspace/didChangeConfiguration", {
      settings = lsp_client.config.settings,
    })
  end
end

lsp.format_sync = function()
  if lsp.config.enable_format_on_sync then
    vim.lsp.buf.format({ async = false })
  end
end

lsp.toggle_format_on_sync = function()
  lsp.config.enable_format_on_sync = not lsp.config.enable_format_on_sync
end

return lsp
