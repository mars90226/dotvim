nnoremap <silent> gd    <Cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <C-]> <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <Cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <C-K> <Cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <Cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <Cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <Cmd>lua vim.lsp.buf.document_symbol()<CR>

" Remap for K
nnoremap gK K
