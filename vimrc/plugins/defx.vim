let [g:defx_width, g:defx_height] = vimrc#float#get_default_size()
let [g:defx_left, g:defx_top] = vimrc#float#calculate_pos(g:defx_width, g:defx_height)
let g:defx_sidebar_width = g:left_sidebar_width

" Defx Options
let g:defx_win_options                   = '-buffer-name=win-%d'
let g:defx_horizontal_win_options        = '-split=horizontal '.g:defx_win_options
let g:defx_horizontal_bottom_win_options = '-split=horizontal -direction=botright '.g:defx_win_options
let g:defx_vertical_win_options          = '-split=vertical '.g:defx_win_options
let g:defx_vertical_right_win_options    = '-split=vertical -direction=botright '.g:defx_win_options
let g:defx_tab_options                   = '-split=tab -buffer-name=tab-%d'
let g:defx_float_options                 = '-split=floating -buffer-name=float-%d -winwidth='.g:defx_width.' -winheight='.g:defx_height.' -wincol='.g:defx_left.' -winrow='.g:defx_top
let g:defx_sidebar_options               = '-split=vertical -winwidth='.g:defx_sidebar_width.' -direction=topleft -toggle'
let g:defx_new_options                   = '-new'
let g:defx_resume_options                = '-listed -resume'

" Defx key mappings {{{
" TODO Clean up these key mappings
" Sidebar
nnoremap <F4>        :execute 'Defx '.vimrc#defx#get_options('sidebar')<CR>
nnoremap <Space><F4> :execute 'Defx '.vimrc#defx#get_options('sidebar').' '.expand('%:p:h').' -search='.expand('%:p')<CR>
" Currently, it's impossible to type <S-F1> ~ <S-F12> using MobaXterm + tmux.
" MobaXterm with 'Byobu terminal type' + tmux with 'screen-256color' will
" generate keycode for <S-F1> ~ <S-F4> that recognized by neovim as <F13> ~ <F16>.
nnoremap <F16>       :execute 'Defx '.vimrc#defx#get_options('sidebar').' '.expand('%:p:h').' -search='.expand('%:p').' -no-focus'<CR>

" Buffer directory
nnoremap -         :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('win'))<CR>
nnoremap ++        :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('win'))<CR>
nnoremap \-        :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('win'))<CR>
nnoremap <Space>-  :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('horizontal_win'))<CR>
nnoremap _         :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('vertical_win'))<CR>
nnoremap <Space>_  :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('tab'))<CR>
nnoremap <Space>=  :call vimrc#defx#opendir('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('float'))<CR>

" Current working directory
nnoremap \xr       :call vimrc#defx#openpwd('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('win'))<CR>
nnoremap \xs       :call vimrc#defx#openpwd('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('horizontal_win'))<CR>
nnoremap \xv       :call vimrc#defx#openpwd('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('vertical_win'))<CR>
nnoremap \xt       :call vimrc#defx#openpwd('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('tab'))<CR>
nnoremap \xf       :call vimrc#defx#openpwd('Defx '.g:defx_new_options.' '.vimrc#defx#get_options('float'))<CR>

" Resume
nnoremap \Xr :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.vimrc#defx#get_options('win'))<CR>
nnoremap \Xs :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.vimrc#defx#get_options('horizontal_win'))<CR>
nnoremap \Xv :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.vimrc#defx#get_options('vertical_win'))<CR>
nnoremap \Xt :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.vimrc#defx#get_options('tab'))<CR>
nnoremap \Xf :call vimrc#defx#opencmd('Defx '.g:defx_resume_options.' '.vimrc#defx#get_options('float'))<CR>
" }}}

" Defx open
command! -nargs=1 -complete=file DefxOpenSink            call vimrc#defx#open(<q-args>, 'edit')
command! -nargs=1 -complete=file DefxSplitOpenSink       call vimrc#defx#open(<q-args>, 'split')
command! -nargs=1 -complete=file DefxBottomSplitOpenSink call vimrc#defx#open(<q-args>, 'bsplit')
command! -nargs=1 -complete=file DefxVSplitOpenSink      call vimrc#defx#open(<q-args>, 'vsplit')
command! -nargs=1 -complete=file DefxTabOpenSink         call vimrc#defx#open(<q-args>, 'tab')
command! -nargs=1 -complete=file DefxRightVSplitOpenSink call vimrc#defx#open(<q-args>, 'rvsplit')
command! -nargs=1 -complete=file DefxFloatOpenSink       call vimrc#defx#open(<q-args>, 'float')

" Defx open dir
command! -nargs=1 -complete=dir DefxOpenDirSink            call vimrc#defx#open_dir(<q-args>, 'edit')
command! -nargs=1 -complete=dir DefxSplitOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'split')
command! -nargs=1 -complete=dir DefxBottomSplitOpenDirSink call vimrc#defx#open_dir(<q-args>, 'bsplit')
command! -nargs=1 -complete=dir DefxVSplitOpenDirSink      call vimrc#defx#open_dir(<q-args>, 'vsplit')
command! -nargs=1 -complete=dir DefxTabOpenDirSink         call vimrc#defx#open_dir(<q-args>, 'tab')
command! -nargs=1 -complete=dir DefxRightVSplitOpenDirSink call vimrc#defx#open_dir(<q-args>, 'rvsplit')
command! -nargs=1 -complete=dir DefxFloatOpenDirSink       call vimrc#defx#open_dir(<q-args>, 'float')

" Defx switch
command! -nargs=1 -complete=file DefxSwitch call vimrc#open#switch(<q-args>, 'DefxOpenSink')
command! -nargs=1 -complete=file DefxTabSwitch call vimrc#open#switch(<q-args>, 'DefxTabOpenSink')

" Defx search
command! -nargs=1 -complete=file DefxSearch call vimrc#defx#open(<q-args>, 'search')

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
