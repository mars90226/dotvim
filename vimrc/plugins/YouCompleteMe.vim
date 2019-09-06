let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf    = 0
let g:ycm_key_invoke_completion = '<M-/>'

nnoremap <Leader>yy :let g:ycm_auto_trigger = 0<CR>
nnoremap <Leader>yY :let g:ycm_auto_trigger = 1<CR>

nnoremap <Leader>yr :YcmRestartServer<CR>
nnoremap <Leader>yi :YcmDiags<CR>

nnoremap <Leader>yI :YcmCompleter GoToInclude<CR>
nnoremap <Leader>yg :YcmCompleter GoTo<CR>
nnoremap <Leader>yG :YcmCompleter GoToImprecise<CR>
nnoremap <Leader>yR :YcmCompleter GoToReferences<CR>
nnoremap <Leader>yt :YcmCompleter GetType<CR>
nnoremap <Leader>yT :YcmCompleter GetTypeImprecise<CR>
nnoremap <Leader>yp :YcmCompleter GetParent<CR>
nnoremap <Leader>yd :YcmCompleter GetDoc<CR>
nnoremap <Leader>yD :YcmCompleter GetDocImprecise<CR>
nnoremap <Leader>yf :YcmCompleter FixIt<CR>

nnoremap <Leader>ysI :split <Bar> YcmCompleter GoToInclude<CR>
nnoremap <Leader>ysg :split <Bar> YcmCompleter GoTo<CR>
nnoremap <Leader>ysG :split <Bar> YcmCompleter GoToImprecise<CR>
nnoremap <Leader>ysR :split <Bar> YcmCompleter GoToReferences<CR>
nnoremap <Leader>yst :split <Bar> YcmCompleter GetType<CR>
nnoremap <Leader>ysT :split <Bar> YcmCompleter GetTypeImprecise<CR>
nnoremap <Leader>ysp :split <Bar> YcmCompleter GetParent<CR>
nnoremap <Leader>ysd :split <Bar> YcmCompleter GetDoc<CR>
nnoremap <Leader>ysD :split <Bar> YcmCompleter GetDocImprecise<CR>
nnoremap <Leader>ysf :split <Bar> YcmCompleter FixIt<CR>

nnoremap <Leader>yvI :vsplit <Bar> YcmCompleter GoToInclude<CR>
nnoremap <Leader>yvg :vsplit <Bar> YcmCompleter GoTo<CR>
nnoremap <Leader>yvG :vsplit <Bar> YcmCompleter GoToImprecise<CR>
nnoremap <Leader>yvR :vsplit <Bar> YcmCompleter GoToReferences<CR>
nnoremap <Leader>yvt :vsplit <Bar> YcmCompleter GetType<CR>
nnoremap <Leader>yvT :vsplit <Bar> YcmCompleter GetTypeImprecise<CR>
nnoremap <Leader>yvp :vsplit <Bar> YcmCompleter GetParent<CR>
nnoremap <Leader>yvd :vsplit <Bar> YcmCompleter GetDoc<CR>
nnoremap <Leader>yvD :vsplit <Bar> YcmCompleter GetDocImprecise<CR>
nnoremap <Leader>yvf :vsplit <Bar> YcmCompleter FixIt<CR>

nnoremap <Leader>yxI :tab split <Bar> YcmCompleter GoToInclude<CR>
nnoremap <Leader>yxg :tab split <Bar> YcmCompleter GoTo<CR>
nnoremap <Leader>yxG :tab split <Bar> YcmCompleter GoToImprecise<CR>
nnoremap <Leader>yxR :tab split <Bar> YcmCompleter GoToReferences<CR>
nnoremap <Leader>yxt :tab split <Bar> YcmCompleter GetType<CR>
nnoremap <Leader>yxT :tab split <Bar> YcmCompleter GetTypeImprecise<CR>
nnoremap <Leader>yxp :tab split <Bar> YcmCompleter GetParent<CR>
nnoremap <Leader>yxd :tab split <Bar> YcmCompleter GetDoc<CR>
nnoremap <Leader>yxD :tab split <Bar> YcmCompleter GetDocImprecise<CR>
nnoremap <Leader>yxf :tab split <Bar> YcmCompleter FixIt<CR>
