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
  pyright = {},
  rust_analyzer = {},
  solargraph = {},
  sumneko_lua = {},
  tsserver = {},
  vimls = {},
}

return lsp
