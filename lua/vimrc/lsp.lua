local lsp_installer_servers = require("nvim-lsp-installer.servers")
local metadata = require("nvim-lsp-installer._generated.metadata")

local my_lspsaga = require("vimrc.plugins.lspsaga")
local my_goto_preview = require("vimrc.plugins.goto-preview")

local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local lsp = {}

lsp.config = {
  enable_format_on_sync = false,
  show_diagnostics = true,
  -- Borrowed from trouble.nvim
  signs = {
    -- icons / text used for a diagnostic
    error = { name = "Error", text = "" },
    warning = { name = "Warn", text = "" },
    hint = { name = "Hint", text = "" },
    information = { name = "Info", text = "" },
  },
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
    -- NOTE: Workaround for "warning: multiple different client offset_encodings detected for buffer, this is not supported yet".
    -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
    capabilities = {
      offsetEncoding = { "utf-16" },
      memoryUsageProvider = true,
    },
    custom_setup = function(server, lsp_opts)
      require("clangd_extensions").setup({
        server = lsp_opts,
        extensions = {
          memory_usage = {
            border = "rounded",
          },
          symbol_info = {
            border = "rounded",
          },
        },
      })
    end,
  },
  cmake = {},
  denols = {
    init_options = {
      enable = true,
      lint = true,
      unstable = true,
    },
  },
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
  perlnavigator = {},
  -- pyls_ms = {},
  -- NOTE: use plugins: pyflakes, pycodestyle, pyls-flake8, pylsp-mypy, python-lsp-black
  pylsp = {},
  -- TODO: Use pyright again, seems to have better performance with higher CPU usages
  -- TODO: Check pyright settings disableLanguageServices
  -- ref: https://github.com/microsoft/pyright/blob/893d08be8c70297fcf082ba812c14cf4aecefc97/docs/settings.md
  -- pyright = {},
  rust_analyzer = {
    custom_setup = function(server, lsp_opts)
      require("rust-tools").setup({
        server = lsp_opts,
      })
    end,
  },
  solargraph = {
    condition = plugin_utils.has_linux_build_env(),
  },
  sumneko_lua = {
    -- TODO: Refine condition
    condition = plugin_utils.has_linux_build_env(),
  },
  -- NOTE: Disabled due to poor performance
  -- tsserver = {
  --   init_options = function()
  --     return require("nvim-lsp-ts-utils").init_options
  --   end,
  --   on_attach = function(client, bufnr)
  --     local ts_utils = require("nvim-lsp-ts-utils")
  --
  --     lsp.on_attach(client, bufnr)
  --
  --     ts_utils.setup({
  --       auto_inlay_hints = false, -- We're not writing TypeScript
  --     })
  --     ts_utils.setup_client(client)
  --   end,
  -- },
  vimls = {},
  -- TODO: add settings for schemas
  yamlls = {},
  zk = {},
}
-- TODO: Maybe utilize nvim-lsp-installer._generated.metadata?
lsp.servers_by_filetype = {}
lsp.server_setuped = {}

lsp.on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

lsp.on_attach = function(client, bufnr)
  -- Plugins
  if choose.is_enabled_plugin("nvim-navic") and client.server_capabilities.documentSymbolProvider then
    require("nvim-navic").attach(client, bufnr)
  end

  -- My plugin configs
  my_lspsaga.on_attach(client)
  my_goto_preview.on_attach(client)

  if choose.is_enabled_plugin("nvim-navic") then
    -- TODO: Move back to appearance.lua, see appearance.lua for reason
    require("vimrc.winbar").attach(bufnr)
  end

  -- NOTE: Use <C-]> to call 'tagfunc'
  -- nnoremap("<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "silent", "buffer")
  nnoremap("1gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "silent", "buffer")
  nnoremap("gR", "<Cmd>lua vim.lsp.buf.references()<CR>", "silent", "buffer")
  nnoremap("g0", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", "silent", "buffer")
  nnoremap("<Space>lf", "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>", "silent", "buffer")
  xnoremap("<Space>lf", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", "silent", "buffer")
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

  vim.bo.omnifunc = [[v:lua.vim.lsp.omnifunc]]
  vim.bo.tagfunc = [[v:lua.vim.lsp.tagfunc]]
  vim.bo.formatexpr = [[v:lua.vim.lsp.formatexpr]]
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

lsp.setup_server = function(server, custom_opts)
  local lsp_opts = lsp.servers[server] or {}
  lsp_opts = vim.tbl_extend("keep", lsp_opts, custom_opts or {})

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities = vim.tbl_extend("force", capabilities, lsp_opts.capabilities or {})

  -- nvim-ufo support foldingRange
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  lsp_opts = vim.tbl_extend("keep", lsp_opts, {
    on_init = lsp.on_init,
    on_attach = lsp.on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  })
  lsp_opts = vim.tbl_extend("force", lsp_opts, {
    capabilities = capabilities,
  })

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
  for server, opts in pairs(metadata) do
    if lsp.is_supported_server(server) then
      for _, filetype in ipairs(opts.filetypes) do
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
      local ok, lsp_server = lsp_installer_servers.get_server(server)
      if ok then
        lsp.setup_server(lsp_server.name, lsp_server:get_default_options())
      end

      -- nvim-lsp-installer unsupported servers or install failed servers
      if not ok or not lsp_server:is_installed() then
        -- Maybe lsp_installer not supported language server, but already installed
        -- TODO: use other attribute to record name
        if vim.fn.executable(server) then
          lsp.setup_server(server, {})
        end
      end

      require("lspconfig")[server].launch()
    end
  end
end

lsp.setup_diagnostic = function()
  for _, signs in pairs(lsp.config.signs) do
    local hl = "DiagnosticSign" .. signs.name
    vim.fn.sign_define(hl, { text = signs.text, texthl = hl })
  end
end

lsp.setup = function(settings)
  lsp.config = vim.tbl_extend("force", lsp.config, settings)

  lsp.init_servers_by_filetype()
  lsp.setup_diagnostic()

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
  for _, lsp_client in ipairs(vim.lsp.get_active_clients()) do
    if lsp_client.name == server then
      lsp_client.notify("workspace/didChangeConfiguration", {
        settings = settings,
      })
    end
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
