local lsp = {}

lsp.servers = {
  bashls = {},
  ccls = {
    init_options = {
      cache = {
        directory = vim.env.HOME .. '/.cache/ccls'
      },
      client = {
        snippetSupport = true
      },
      highlight = {
        lsRanges = true
      },
      index = {
        threads = 2
      }
    }
  },
  cmake = {},
  gopls = {},
  perlls = {},
  pylsp = {},
  -- TODO: Check pyright settings disableLanguageServices
  -- ref: https://github.com/microsoft/pyright/blob/893d08be8c70297fcf082ba812c14cf4aecefc97/docs/settings.md
  -- pyright = {},
  rust_analyzer = {},
  solargraph = {},
  sumneko_lua = {},
  tsserver = {},
  vimls = {},
}

lsp.on_attach = function()
  nnoremap('<C-]>',     '<Cmd>lua vim.lsp.buf.definition()<CR>', 'silent', 'buffer')
  nnoremap('1gD',       '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'silent', 'buffer')
  nnoremap('gR',        '<Cmd>lua vim.lsp.buf.references()<CR>', 'silent', 'buffer')
  nnoremap('g0',        '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', 'silent', 'buffer')
  nnoremap('<Space>lf', '<Cmd>lua vim.lsp.buf.formatting()<CR>', 'silent', 'buffer')
  xnoremap('<Space>lf', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', 'silent', 'buffer')
  nnoremap('<Space>lI', '<Cmd>LspInfo<CR>', 'silent', 'buffer')

  -- Remap for K
  nnoremap('gK', 'K', 'buffer')

  vim.bo.omnifunc = [[v:lua.vim.lsp.omnifunc]]
  vim.bo.formatexpr = [[v:lua.vim.lsp.formatexpr]]
end

lsp.setup_server = function(server, custom_opts)
  local lsp_opts = lsp.servers[server] or {}
  lsp_opts = vim.tbl_extend('keep', lsp_opts, custom_opts or {})

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  lsp_opts.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  lsp_opts.on_attach = lsp.on_attach

  require'lspconfig'[server].setup(lsp_opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end

lsp.notify_settings = function(server, settings)
  for _, lsp_client in ipairs(vim.lsp.get_active_clients()) do
    if lsp_client.name == server then
      lsp_client.notify('workspace/didChangeConfiguration', {
        settings = settings
      })
    end
  end
end

return lsp
