local my_lspsaga = require("vimrc.plugins.lspsaga")
local my_goto_preview = require("vimrc.plugins.goto-preview")

local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

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
  -- ccls = {
  --   init_options = {
  --     cache = {
  --       directory = vim.env.HOME .. "/.cache/ccls",
  --     },
  --     client = {
  --       snippetSupport = true,
  --     },
  --     highlight = {
  --       lsRanges = true,
  --     },
  --     index = {
  --       threads = 2,
  --     },
  --   },
  -- },
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
    on_attach = function(client, bufnr)
      local clangd_inlay_hints = require("clangd_extensions.inlay_hints")
      clangd_inlay_hints.setup_autocmd()
      clangd_inlay_hints.set_inlay_hints()
    end,
  },
  -- NOTE: Replaced by neocmake
  -- cmake = {},
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
  },
  -- TODO: Grammar check is unhelpful when article is not in English.
  ltex = {
    on_attach = function(client, bufnr)
      require("ltex_extra").setup()
    end,
  },
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
    condition = plugin_utils.has_linux_build_env()
  },
  perlnavigator = {},
  -- pyls_ms = {},
  -- NOTE: use plugins: pyflakes, pycodestyle, pyls-flake8, pylsp-mypy, python-lsp-black
  pylsp = {},
  -- TODO: pylyzer not supporting documentSymbolProvider, disabled for now
  -- pylyzer = {},
  -- TODO: Use pyright again, seems to have better performance with higher CPU usages
  -- TODO: Check pyright settings disableLanguageServices
  -- ref: https://github.com/microsoft/pyright/blob/893d08be8c70297fcf082ba812c14cf4aecefc97/docs/settings.md
  -- pyright = {},
  rust_analyzer = {
    condition = plugin_utils.has_linux_build_env(),
    custom_setup = function(server, lsp_opts)
      require("rust-tools").setup({
        server = lsp_opts,
      })
    end,
  },
  solargraph = {
    condition = plugin_utils.has_linux_build_env(),
  },
  -- FIXME: Cannot start LSP, maybe the path provided by mason is wrong?
  sqlls = {},
  -- NOTE: Use typescript-tools.nvim to setup custom lsp to use tsserver
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
  ["typescript-tools"] = {
    capabilities = {
      textDocument = {
        foldingRange = {
          dynamicRegistration = true,
        }
      }
    },
    settings = {
      -- Ref: LazyVim
      typescript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      javascript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      completions = {
        completeFunctionCalls = true,
      },
    },
  },
  vimls = {},
  vuels = {},
  -- TODO: add settings for schemas
  yamlls = {},
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

  nnoremap("K", "<Cmd>lua require('vimrc.lsp').show_doc()<CR>", "silent", "buffer")
  -- NOTE: Use <C-]> to call 'tagfunc'
  -- nnoremap("<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "silent", "buffer")
  nnoremap("1gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "silent", "buffer")
  nnoremap("gR", "<Cmd>lua vim.lsp.buf.references()<CR>", "silent", "buffer")
  nnoremap("g0", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", "silent", "buffer")
  nnoremap("gy", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "silent", "buffer")
  nnoremap("<Space>lf", "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>", "silent", "buffer")
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
  nnoremap("yof", [[<Cmd>lua require("vimrc.lsp").toggle_format_on_sync()<CR>]], "silent", "buffer")
  nnoremap("yoo", [[<Cmd>lua require("vimrc.lsp").toggle_show_diagnostics()<CR>]], "silent", "buffer")
  nnoremap("yoI", [[<Cmd>lua vim.lsp.inlay_hint(0)<CR>]], "silent", "buffer")

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

  -- FIXME: Disable workspace/didChangeWatchedFiles as it has huge performance issue for now (using poll instead of watch)
  -- TODO: Enable it after the following pull request is merged
  -- Ref: https://github.com/neovim/neovim/pull/23500
  -- NOTE:Some LSP ask for file watching even through the registration is disabled.
  -- Ref: https://github.com/neovim/neovim/pull/23500#issuecomment-1585986913
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

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

lsp.setup = function(settings)
  lsp.config = vim.tbl_extend("force", lsp.config, settings)

  lsp.init_servers_by_filetype()
  lsp.setup_lsp_install()
  lsp.setup_plugins()

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
  for _, lsp_client in ipairs(vim.lsp.get_active_clients({ name = server })) do
    lsp_client.config.settings = settings
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
