augroup netrw_mapping_for_defx
  autocmd!
  autocmd FileType netrw call vimrc#defx#netrw_mapping_for_defx()
augroup END

nnoremap <F4>        :Defx -split=vertical -winwidth=35 -direction=topleft -toggle<CR>
nnoremap <Space><F4> :Defx -split=vertical -winwidth=35 -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>
nnoremap -           :call vimrc#defx#opendir('Defx')<CR>
nnoremap ++          :call vimrc#defx#opendir('Defx')<CR>
nnoremap \-          :call vimrc#defx#opendir('Defx')<CR>
nnoremap \=          :call vimrc#defx#opendir('Defx -new')<CR>
nnoremap _           :call vimrc#defx#opendir('Defx -split=vertical')<CR>
nnoremap <Space>-    :call vimrc#defx#opendir('Defx -split=horizontal')<CR>
nnoremap <Space>_    :call vimrc#defx#opendir('Defx -split=tab -buffer-name=tab')<CR>
nnoremap \.          :Defx .<CR>
nnoremap <Space>=    :Defx -split=vertical .<CR>
nnoremap <Space>+    :Defx -split=tab -buffer-name=tab .<CR>

" Defx open
command! -nargs=1 -complete=file DefxOpenSink            call vimrc#defx#open(<q-args>, 'edit')
command! -nargs=1 -complete=file DefxSplitOpenSink       call vimrc#defx#open(<q-args>, 'split')
command! -nargs=1 -complete=file DefxVSplitOpenSink      call vimrc#defx#open(<q-args>, 'vsplit')
command! -nargs=1 -complete=file DefxTabOpenSink         call vimrc#defx#open(<q-args>, 'tab split')
command! -nargs=1 -complete=file DefxRightVSplitOpenSink call vimrc#defx#open(<q-args>, 'rightbelow vsplit')

" Defx open dir
command! -nargs=1 -complete=file DefxOpenDirSink            call vimrc#defx#open_dir(<q-args>, 'edit')
command! -nargs=1 -complete=file DefxSplitOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'split')
command! -nargs=1 -complete=file DefxVSplitOpenDirSink      call vimrc#defx#open_dir(<q-args>, 'vsplit')
command! -nargs=1 -complete=file DefxTabOpenDirSink         call vimrc#defx#open_dir(<q-args>, 'tab split')
command! -nargs=1 -complete=file DefxRightVSplitOpenDirSink call vimrc#defx#open_dir(<q-args>, 'rightbelow vsplit')

augroup defx_mappings
  autocmd!
  autocmd FileType defx call vimrc#defx#mappings()
augroup END
