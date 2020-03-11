" TODO Consider install through :LspInstall

" Setup bashls (bash-language-server)
if executable('bash-language-server')
  lua require'nvim_lsp'.bashls.setup{}
endif
