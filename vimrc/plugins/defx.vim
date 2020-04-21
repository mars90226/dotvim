augroup netrw_mapping_for_defx
  autocmd!
  autocmd FileType netrw call vimrc#defx#netrw_mapping_for_defx()
augroup END

let [g:defx_width, g:defx_height] = vimrc#float#get_default_size()
let [g:defx_left, g:defx_top] = vimrc#float#calculate_pos(g:defx_width, g:defx_height)
let g:defx_sidebar_width = 35
let g:defx_float_options = '-split=floating -buffer-name=float -winwidth='.g:defx_width.' -winheight='.g:defx_height.' -wincol='.g:defx_left.' -winrow='.g:defx_top

" TODO Clean up these key mappings
nnoremap <F4>            :Defx -split=vertical -winwidth=`g:defx_sidebar_width` -direction=topleft -toggle<CR>
nnoremap <Space><F4>     :Defx -split=vertical -winwidth=`g:defx_sidebar_width` -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>
nnoremap -               :call vimrc#defx#opendir('Defx')<CR>
nnoremap ++              :call vimrc#defx#opendir('Defx')<CR>
nnoremap \-              :call vimrc#defx#opendir('Defx')<CR>
nnoremap \=              :call vimrc#defx#opendir('Defx -new')<CR>
nnoremap _               :call vimrc#defx#opendir('Defx -split=vertical')<CR>
nnoremap <Space>-        :call vimrc#defx#opendir('Defx -split=horizontal')<CR>
nnoremap <Space><Space>- :call vimrc#defx#opendir('Defx -split=horizontal -new')<CR>
nnoremap <Space>_        :call vimrc#defx#opendir('Defx -split=tab -buffer-name=tab')<CR>
nnoremap \.              :Defx .<CR>
nnoremap \>              :Defx -split=vertical .<CR>
nnoremap <Space>=        :Defx -split=horizontal .<CR>
nnoremap <Space>+        :Defx -split=tab -buffer-name=tab .<CR>
nnoremap <Leader>zd      :call vimrc#defx#opendir('Defx '.g:defx_float_options)<CR>
nnoremap <Leader>zr      :execute 'Defx '.g:defx_float_options.' .'<CR>

" Defx open
command! -nargs=1 -complete=file DefxOpenSink            call vimrc#defx#open(<q-args>, 'edit')
command! -nargs=1 -complete=file DefxSplitOpenSink       call vimrc#defx#open(<q-args>, 'split')
command! -nargs=1 -complete=file DefxVSplitOpenSink      call vimrc#defx#open(<q-args>, 'vsplit')
command! -nargs=1 -complete=file DefxTabOpenSink         call vimrc#defx#open(<q-args>, 'tab split')
command! -nargs=1 -complete=file DefxRightVSplitOpenSink call vimrc#defx#open(<q-args>, 'rightbelow vsplit')

" Defx open dir
command! -nargs=1 -complete=dir DefxOpenDirSink            call vimrc#defx#open_dir(<q-args>, 'edit')
command! -nargs=1 -complete=dir DefxSplitOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'split')
command! -nargs=1 -complete=dir DefxVSplitOpenDirSink      call vimrc#defx#open_dir(<q-args>, 'vsplit')
command! -nargs=1 -complete=dir DefxTabOpenDirSink         call vimrc#defx#open_dir(<q-args>, 'tab split')
command! -nargs=1 -complete=dir DefxRightVSplitOpenDirSink call vimrc#defx#open_dir(<q-args>, 'rightbelow vsplit')

" Defx switch
command! -nargs=1 -complete=file DefxSwitch call vimrc#open#switch(<q-args>, 'DefxOpenSink')

augroup defx_mappings
  autocmd!
  autocmd FileType defx call vimrc#defx#mappings()
augroup END

augroup defx_detect_folder
  autocmd!
  " Disable netrw autocmd
  autocmd VimEnter * autocmd! FileExplorer
  autocmd BufEnter * call vimrc#defx#detect_folder(expand('<afile>'))
augroup END
