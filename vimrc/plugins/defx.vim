augroup netrw_mapping_for_defx
  autocmd!
  autocmd FileType netrw call vimrc#defx#netrw_mapping_for_defx()
augroup END

let [g:defx_width, g:defx_height] = vimrc#float#get_default_size()
let [g:defx_left, g:defx_top] = vimrc#float#calculate_pos(g:defx_width, g:defx_height)
let g:defx_sidebar_width = 35
let g:defx_resume_options = '-listed -resume'
let g:defx_win_options = '-buffer-name=win-%d'
let g:defx_tab_options = '-buffer-name=tab-%d'
let g:defx_float_options = '-buffer-name=float-%d -winwidth='.g:defx_width.' -winheight='.g:defx_height.' -wincol='.g:defx_left.' -winrow='.g:defx_top

" Defx key mappings {{{
" TODO Clean up these key mappings
" Sidebar
nnoremap <F4>        :Defx -split=vertical -winwidth=`g:defx_sidebar_width` -direction=topleft -toggle<CR>
nnoremap <Space><F4> :Defx -split=vertical -winwidth=`g:defx_sidebar_width` -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>

" Buffer directory
nnoremap -         :call vimrc#defx#opendir('Defx '.g:defx_win_options)<CR>
nnoremap ++        :call vimrc#defx#opendir('Defx '.g:defx_win_options)<CR>
nnoremap \-        :call vimrc#defx#opendir('Defx '.g:defx_win_options)<CR>
nnoremap <Space>-  :call vimrc#defx#opendir('Defx -split=horizontal '.g:defx_win_options)<CR>
nnoremap _         :call vimrc#defx#opendir('Defx -split=vertical '.g:defx_win_options)<CR>
nnoremap <Space>_  :call vimrc#defx#opendir('Defx -split=tab '.g:defx_tab_options)<CR>
nnoremap <Space>=  :call vimrc#defx#opendir('Defx -split=floating '.g:defx_float_options)<CR>

" Current working directory
nnoremap \xr       :call vimrc#defx#openpwd('Defx '.g:defx_win_options)<CR>
nnoremap \xs       :call vimrc#defx#openpwd('Defx -split=horizontal '.g:defx_win_options)<CR>
nnoremap \xv       :call vimrc#defx#openpwd('Defx -split=vertical '.g:defx_win_options)<CR>
nnoremap \xt       :call vimrc#defx#openpwd('Defx -split=tab '.g:defx_tab_options)<CR>
nnoremap \xf       :call vimrc#defx#openpwd('Defx -split=floating '.g:defx_float_options)<CR>

" Resume
nnoremap <Space>xr :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.g:defx_win_options)<CR>
nnoremap <Space>xs :call vimrc#defx#opencmd('Defx -split=horizontal '.g:defx_resume_options.' '.g:defx_win_options)<CR>
nnoremap <Space>xv :call vimrc#defx#opencmd('Defx -split=vertical '.g:defx_resume_options.' '.g:defx_win_options)<CR>
nnoremap <Space>xt :call vimrc#defx#opencmd('Defx -split=tab '.g:defx_resume_options.' '.g:defx_tab_options)<CR>
nnoremap <Space>xf :call vimrc#defx#opencmd('Defx -split=floating '.g:defx_resume_options.' '.g:defx_float_options)<CR>
" }}}

" Defx open
command! -nargs=1 -complete=file DefxOpenSink            call vimrc#defx#open(<q-args>, 'edit')
command! -nargs=1 -complete=file DefxSplitOpenSink       call vimrc#defx#open(<q-args>, 'split')
command! -nargs=1 -complete=file DefxVSplitOpenSink      call vimrc#defx#open(<q-args>, 'vsplit')
command! -nargs=1 -complete=file DefxTabOpenSink         call vimrc#defx#open(<q-args>, 'tab')
command! -nargs=1 -complete=file DefxRightVSplitOpenSink call vimrc#defx#open(<q-args>, 'rvsplit')
command! -nargs=1 -complete=file DefxFloatOpenSink       call vimrc#defx#open(<q-args>, 'float')

" Defx open dir
command! -nargs=1 -complete=dir DefxOpenDirSink            call vimrc#defx#open_dir(<q-args>, 'edit')
command! -nargs=1 -complete=dir DefxSplitOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'split')
command! -nargs=1 -complete=dir DefxVSplitOpenDirSink      call vimrc#defx#open_dir(<q-args>, 'vsplit')
command! -nargs=1 -complete=dir DefxTabOpenDirSink         call vimrc#defx#open_dir(<q-args>, 'tab')
command! -nargs=1 -complete=dir DefxRightVSplitOpenDirSink call vimrc#defx#open_dir(<q-args>, 'rvsplit')
command! -nargs=1 -complete=dir DefxFloatOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'float')

" Defx switch
command! -nargs=1 -complete=file DefxSwitch call vimrc#open#switch(<q-args>, 'DefxOpenSink')

augroup defx_mappings
  autocmd!
  autocmd FileType defx call vimrc#defx#settings()
  autocmd FileType defx call vimrc#defx#mappings()
augroup END

augroup defx_detect_folder
  autocmd!
  " Disable netrw autocmd
  autocmd VimEnter * autocmd! FileExplorer
  autocmd BufEnter * call vimrc#defx#detect_folder(expand('<afile>'))
augroup END
