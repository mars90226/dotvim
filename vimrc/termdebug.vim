" For :Termdebug plugin, see :help terminal-debug
packadd! termdebug

" Mappings
nnoremap <Leader>dd :Termdebug<Space>
nnoremap <Leader>dD :TermdebugCommand<Space>

nnoremap <Leader>dr :Run<Space>
nnoremap <Leader>da :Arguments<Space>

nnoremap <Leader>db :Break<CR>
nnoremap <Leader>dC :Clear<CR>

nnoremap <Leader>ds :Step<CR>
nnoremap <Leader>do :Over<CR>
nnoremap <Leader>df :Finish<CR>
nnoremap <Leader>dc :Continue<CR>
nnoremap <Leader>dS :Stop<CR>

" `:Evaluate` evaluate cursor variable and show result in floating window
" which may not be large enough to contain all result
nnoremap <Leader>de :Evaluate<Space>
xnoremap <Leader>de :Evaluate
" `:Evaluate variable` show result in echo
nnoremap <Leader>dk :execute 'Evaluate '.expand('<cword>')<CR>
nnoremap <Leader>dK :execute 'Evaluate '.expand('<cWORD>')<CR>

nnoremap <Leader>dg :Gdb<CR>
nnoremap <Leader>dp :Program<CR>
nnoremap <Leader>dO :Source<CR>

nnoremap <Leader>d, :call TermDebugSendCommand(input('Gdb command> '))<CR>
