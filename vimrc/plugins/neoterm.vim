let g:neoterm_default_mod = 'botright'
let g:neoterm_automap_keys = '<Leader>T'
let g:neoterm_size = &lines / 2

nnoremap <silent> <Space>` :execute 'T ' . input('Terminal: ', '', 'shellcmd')<CR>
nnoremap <silent> <Leader>` :Ttoggle<CR>
nnoremap <silent> <Space><F3> :TREPLSendFile<CR>
nnoremap <silent> <F3> :TREPLSendLine<CR>
xnoremap <silent> <F3> :TREPLSendSelection<CR>

" Useful maps
" hide/close terminal
nnoremap <silent> <Leader>th :Tclose<CR>
" clear terminal
nnoremap <silent> <Leader>tl :Tclear<CR>
" kills the current job (send a <c-c>)
nnoremap <silent> <Leader>tc :Tkill<CR>
