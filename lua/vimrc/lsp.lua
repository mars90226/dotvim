local ts_utils = require("nvim-lsp-ts-utils")

local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local aerial = require("aerial")
local navic = require("nvim-navic")

local my_lspsaga = require("vimrc.plugins.lspsaga")
local my_goto_preview = require("vimrc.plugins.goto-preview")

local plugin_utils = require("vimrc.plugin_utils")
local winbar = require("vimrc.winbar")

local lsp = {}

lsp.config = {
  enable_format_on_sync = false,
  show_diagnostics = true,
}

lsp.servers = {
  bashls = {
    -- NOTE: Disable shellcheck integration and use nvim-lint to lint on save
    cmd_env = { SHELLCHECK_PATH = '' },
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
  -- FIXME: Currently reply on globally installed vscode-langservers-extracted
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
    handlers = (function()
      if has_lsp_status then
        return lsp_status.extensions.clangd.setup()
      else
        return {}
      end
    end)(),
    condition = plugin_utils.has_linux_build_env(),
    -- NOTE: Workaround for "warning: multiple different client offset_encodings detected for buffer, this is not supported yet".
    -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-997226723
    capabilities = {
      offsetEncoding = { "utf-16" },
      memoryUsageProvider = true,
    },
  },
  cmake = {},
  -- FIXME: Currently reply on globally installed vscode-langservers-extracted
  eslint = {},
  gopls = {
    condition = plugin_utils.has_linux_build_env(),
  },
  perlnavigator = {},
  -- pyls_ms = {
  --   handlers = (function()
  --     if has_lsp_status then
  --       return lsp_status.extensions.myls_ms.setup()
  --     else
  --       return {}
  --     end
  --   end)(),
  -- },
  -- NOTE: use plugins: pyflakes, pycodestyle, pyls-flake8, pylsp-mypy, python-lsp-black
  pylsp = {},
  -- TODO: Use pyright again, seems to have better performance with higher CPU usages
  -- TODO: Check pyright settings disableLanguageServices
  -- ref: https://github.com/microsoft/pyright/blob/893d08be8c70297fcf082ba812c14cf4aecefc97/docs/settings.md
  -- pyright = {},
  rust_analyzer = {
    custom_setup = function(server, lsp_opts)
      require("rust-tools").setup(lsp_opts)
    end,
  },
  solargraph = {
    condition = plugin_utils.has_linux_build_env(),
  },
  sumneko_lua = {
    -- TODO: Refine condition
    condition = plugin_utils.has_linux_build_env(),
  },
  tsserver = {
    init_options = ts_utils.init_options,
    on_attach = function(client, bufnr)
      lsp.on_attach(client, bufnr)

      ts_utils.setup({})
      ts_utils.setup_client(client)
    end,
  },
  vimls = {},
  -- TODO: add settings for schemas
  yamlls = {},
  zk = {},
}

lsp.on_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

lsp.on_attach = function(client, bufnr)
  -- Plugins
  if has_lsp_status then
    lsp_status.on_attach(client)
  end
  aerial.on_attach(client, bufnr)

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- My plugin configs
  my_lspsaga.on_attach(client)
  my_goto_preview.on_attach(client)
  -- TODO: Move back to appearance.lua, see appearance.lua for reason
  vim.wo.winbar = [[%{v:lua.require('vimrc.winbar').winbar()}]]

  -- NOTE: Use <C-]> to call 'tagfunc'
  -- nnoremap("<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "silent", "buffer")
  nnoremap("1gD", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", "silent", "buffer")
  nnoremap("gR", "<Cmd>lua vim.lsp.buf.references()<CR>", "silent", "buffer")
  nnoremap("g0", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", "silent", "buffer")
  nnoremap("<Space>lf", "<Cmd>lua vim.lsp.buf.formatting()<CR>", "silent", "buffer")
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

  if lsp_opts.custom_setup then
    lsp_opts.custom_setup(server, lsp_opts)
  else
    require("lspconfig")[server].setup(lsp_opts)
  end
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

-- TODO: Merge settings
lsp.setup = function(settings)
  lsp.config = vim.tbl_extend("force", lsp.config, settings)
end

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
