nnoremap <silent> gd    <Cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <C-]> <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <Cmd>call vimrc#nvim_lsp#show_documentation()<CR>
nnoremap <silent> gD    <Cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gy    <Cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <Cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <Cmd>lua vim.lsp.buf.document_symbol()<CR>

" Remap for K
nnoremap gK K

set omnifunc=v:lua.vim.lsp.omnifunc
