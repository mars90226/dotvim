local my_goto_preview = require("vimrc.plugins.goto-preview")

local check = require("vimrc.check")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

-- TODO: Refactor
local vue_typescript_plugin = nil
if check.has_linux_build_env() then
  vue_typescript_plugin = require("mason-registry").get_package("vue-language-server"):get_install_path()
    .. "/node_modules/@vue/language-server"
    .. "/node_modules/@vue/typescript-plugin"
end

lsp.config = {
  enable_format_on_sync = false,
}

-- NOTE: For project level settings
-- TODO: Need to review if this works with multiple working directories
local project_root = vim.fs.root(0, ".git")

-- TODO: Refactor this to use `vim.lsp.config` & `vim.lsp.enable` after neovim 0.11.0 is released
-- Ref: [feat(lsp) add `vim.lsp.config` and `vim.lsp.enable` by lewis6991 · Pull Request 31031 · neovim/neovim](https://github.com/neovim/neovim/pull/31031)
-- NOTE: Change it also need to change lsp.servers_by_filetype
lsp.servers = {
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
    -- NOTE: Disable shellcheck integration and use nvim-lint to lint on save
    cmd_env = { SHELLCHECK_PATH = "" },
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
        -- TODO: Only use project dictionary when it's available
        -- Need to check if project dictionary is exist without affecting performance for other lsp servers
        userDictPath = project_root and project_root .. "/.harper/project.txt" or "",
        fileDictPath = project_root and project_root .. "/.harper" or "",
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
  -- NOTE: Disabled due to high CPU usage
  -- Ref: https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1109
  -- TODO: Enable tailwincss
  -- Ref: https://github.com/tailwindlabs/tailwindcss-intellisense/issues/1109#issuecomment-2612844262
  -- tailwindcss = {},
  vimls = {},
  volar = {
    condition = check.has_linux_build_env(),
  },
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
}
lsp.servers_by_filetype = {
  -- TODO: Wait for mason-lspconfig to support this
  nu = { "nushell" },
}
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
    -- TODO: Refactor this to be extendable
    if vim.tbl_contains({ "help", "vim" }, vim.bo.filetype) then
      vim.cmd([[help ]] .. vim.fn.expand("<cword>"))
    elseif
      vim.tbl_contains(
        { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" },
        vim.bo.filetype
      )
    then
      require("better-type-hover").better_type_hover()
    else
      vim.lsp.buf.hover({
        border = "rounded",
      })
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
  my_goto_preview.on_attach(client)

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
    -- NOTE: Enable inlay hints
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
  -- TODO: Enable document color
  -- Ref: [feat(lsp) support `textDocumentdocumentColor` by MariaSolOs · Pull Request 33440 · neovimneovim](https://github.com/neovim/neovim/pull/33440)

  vim.bo.omnifunc = [[v:lua.vim.lsp.omnifunc]]
  vim.bo.tagfunc = [[v:lua.vim.lsp.tagfunc]]
  vim.bo.formatexpr = [[v:lua.vim.lsp.formatexpr({})]]
  -- NOTE: Enable 'signcolumn' on LSP attached buffer if it's not a "nofile" buffer to avoid diagnostics keeping toggling 'signcolumn'
  -- TODO: This check seems only work when calling hover request after a while after the LSP is
  -- initialized and ready to show hover.
  if vim.bo[bufnr].buftype ~= "nofile" then
    vim.wo.signcolumn = "yes"
  end

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

  if choose.is_disabled_plugin("nvim-lsp-workspace-didChangeWatchedFiles") then
    capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  else
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

  -- TODO: Use mason-lspconfig api
  -- FIXME: This may have a bug that causing 'harper_ls' not installed
  for _, lspconfig_server in ipairs(lspconfig_servers) do
    table.insert(mason_package_servers, mason_lspconfig_mappings_server.lspconfig_to_package[lspconfig_server])
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
-- FIXME: Seems broken after neovim 0.11.0 release?
-- See [neoconf.nvimluaneoconfpluginslspconfig.lua at 4a36457c389fab927c885d53fba6e07f4eedf1f4 · folkeneoconf.nvim](https://github.com/folke/neoconf.nvim/blob/4a36457c389fab927c885d53fba6e07f4eedf1f4/lua/neoconf/plugins/lspconfig.lua#L67) as reference
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

return lsp
