" Setup bashls (bash-language-server)
if executable('bash-language-server')
  lua require'nvim_lsp'.bashls.setup{}
endif
