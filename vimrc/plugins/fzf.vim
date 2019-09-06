if has("nvim") || has("gui_running")
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:fzf_history_dir = $HOME.'/.local/share/fzf-history'

let g:misc_fzf_action = {
      \ 'ctrl-q': function('vimrc#fzf#build_quickfix_list'),
      \ 'alt-c':  function('vimrc#fzf#copy_results'),
      \ 'alt-e':  'cd',
      \ }
if has('nvim')
  let g:misc_fzf_action['alt-t'] = function('vimrc#fzf#open_terminal')
endif
let g:default_fzf_action = extend({
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'alt-v':  'rightbelow vsplit',
      \ }, g:misc_fzf_action)
let g:fzf_action = g:default_fzf_action

" Mapping selecting mappings
nmap <Space><Tab> <Plug>(fzf-maps-n)
imap <M-`>        <Plug>(fzf-maps-i)
xmap <Space><Tab> <Plug>(fzf-maps-x)
omap <Space><Tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <C-X><C-K> <Plug>(fzf-complete-word)
imap <C-X><C-F> <Plug>(fzf-complete-path)
" <C-J> is <NL>
imap <C-X><C-J> <Plug>(fzf-complete-file-ag)
imap <C-X><C-L> <Plug>(fzf-complete-line)
inoremap <expr> <C-X><C-D> fzf#vim#complete#path('fd -t d')

" fzf functions & commands {{{
command! -bar  -bang                  Helptags call fzf#vim#helptags(<bang>0)
command! -bang -nargs=? -complete=dir Files    call vimrc#fzf#files(<q-args>, <bang>0)
command! -bang -nargs=?               GFiles   call vimrc#fzf#gitfiles(<q-args>, <bang>0)
command! -bang -nargs=+ -complete=dir Locate   call vimrc#fzf#locate(<q-args>, <bang>0)
command! -bang -nargs=*               History  call vimrc#fzf#history(<q-args>, <bang>0)
command! -bar  -bang                  Windows  call fzf#vim#windows(vimrc#fzf#preview#windows(), <bang>0)
command! -bar  -nargs=* -bang         BLines   call fzf#vim#buffer_lines(<q-args>, vimrc#fzf#preview#buffer_lines(), <bang>0)

" Rg
command! -bang -nargs=* Rg call vimrc#fzf#rg#grep(<q-args>, <bang>0)

" Rg with option, using ':' to separate option and query
command! -bang -nargs=* RgWithOption call vimrc#fzf#rg#grep_with_option(<q-args>, <bang>0)

" Fd all files
command! -bang -nargs=? -complete=dir AllFiles call vimrc#fzf#dir#all_files(<q-args>, <bang>0)

" Git diff
command! -bang -nargs=* -complete=dir GitDiffFiles call vimrc#fzf#git#diff_tree(<bang>0, <f-args>)
command! -bang -nargs=* -complete=dir RgGitDiffFiles call vimrc#fzf#git#rg_diff_tree(<bang>0, <f-args>)

" Mru
command! Mru        call vimrc#fzf#mru#mru()
command! ProjectMru call vimrc#fzf#mru#project_mru()

" DirectoryMru
command! -bang DirectoryMru      call vimrc#fzf#mru#directory_mru(<bang>0)
command! -bang DirectoryMruFiles call vimrc#fzf#mru#directory_mru_files(<bang>0)
command! -bang DirectoryMruRg    call vimrc#fzf#mru#directory_mru_rg(<bang>0)

" Directory
command! -bang -nargs=? Directories    call vimrc#fzf#dir#directories(<q-args>, <bang>0)
command! -bang -nargs=? DirectoryFiles call vimrc#fzf#dir#directory_files(<q-args>, <bang>0)
command! -bang -nargs=? DirectoryRg    call vimrc#fzf#dir#directory_rg(<q-args>, <bang>0)

" Tselect
command! -nargs=1 Tselect call vimrc#fzf#tag#tselect(<q-args>)

" Jump
command! Jump call vimrc#fzf#jump()

" Registers
command! Registers call vimrc#fzf#registers()

" DirectoryAncestors
command! DirectoryAncestors call vimrc#fzf#dir#directory_ancestors()

" Range
command! -nargs=? -range SelectLines call vimrc#fzf#range#range_lines('SelectLines', 1, <line1>, <line2>, <q-args>)
command! -nargs=?        ScreenLines call vimrc#fzf#range#screen_lines(<q-args>)

" FilesWithQuery
command! -nargs=1 FilesWithQuery call vimrc#fzf#files_with_query(<q-args>)

" CurrentPlacedSigns
command! CurrentPlacedSigns call vimrc#fzf#current_placed_signs()

" Functions
command! Functions call vimrc#fzf#functions()

" Git commit command {{{
" GitGrepCommit
command! -nargs=+ -complete=customlist,fugitive#CompleteObject GitGrepCommit call vimrc#fzf#git#grep_commit(<f-args>)
command! -bang -nargs=* GitGrep call vimrc#fzf#git#grep_commit('', <q-args>)

" GitDiffCommit
command! -nargs=? -complete=customlist,fugitive#CompleteObject GitDiffCommit call vimrc#fzf#git#diff_commit(<f-args>)

" GitFilesCommit
command! -nargs=1 -complete=customlist,fugitive#CompleteObject GitFilesCommit call vimrc#fzf#git#files_commit(<q-args>)
" }}}

if has("nvim")
  augroup fzf_statusline
    autocmd!
    autocmd User FzfStatusLine call vimrc#fzf#statusline()
  augroup END

  " Tags
  command! -bang -nargs=* ProjectTags call vimrc#fzf#tag#project_tags(<q-args>, <bang>0)
  " Too bad fzf cannot toggle case sensitive interactively
  command! -bang -nargs=* BTagsCaseSentitive       call fzf#vim#buffer_tags(<q-args>, { 'options': ['+i'] }, <bang>0)
  command! -bang -nargs=* TagsCaseSentitive        call fzf#vim#tags(<q-args>,        { 'options': ['+i'] }, <bang>0)
  command! -bang -nargs=* ProjectTagsCaseSentitive call vimrc#fzf#tag#project_tags(<q-args>,      { 'options': ['+i'] }, <bang>0)

  command! TagbarTags call vimrc#fzf#tag#tagbar_tags()
endif

if vimrc#plugin#is_enabled_plugin('defx')
  command! -bang -nargs=? -complete=dir Files    call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#files(<q-args>, <bang>0) })
  command! -bang -nargs=?               GFiles   call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#gitfiles(<q-args>, <bang>0) })
  command! -bang -nargs=+ -complete=dir Locate   call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#locate(<q-args>, <bang>0) })

  command! -bang          DirectoryMru      call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#mru#directory_mru(<bang>0) })
  command! -bang -nargs=? Directories       call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#dir#directories(<q-args>, <bang>0) })
endif
" }}}

" fzf key mappings {{{
nnoremap <Space>fa :execute 'Ag ' . input('Ag: ')<CR>
nnoremap <Space>fA :AllFiles<CR>
nnoremap <Space>fb :Buffers<CR>
nnoremap <Space>fB :Files %:h<CR>
nnoremap <Space>fc :BCommits<CR>
nnoremap <Space>fC :Commits<CR>
nnoremap <Space>fd :Directories<CR>
nnoremap <Space>fD :DirectoryFiles<CR>
nnoremap <Space>ff :Files<CR>
nnoremap <Space>fF :DirectoryRg<CR>
nnoremap <Space>f<C-F> :execute 'Files ' . expand('<cfile>')<CR>
nnoremap <Space>fg :GFiles -co --exclude-standard<CR>
nnoremap <Space>fG :execute 'GitGrep ' . input('Git grep: ')<CR>
nnoremap <Space>f<C-G> :execute 'GitGrepCommit ' . input('Commit: ') . ' ' . input('Git grep: ')<CR>
nnoremap <Space>fh :Helptags<CR>
nnoremap <Space>fH :execute 'GitFilesCommit ' . input('Commit: ')<CR>
nnoremap <Space>fi :History<CR>
nnoremap <Space>fj :Jump<CR>
nnoremap <Space>fk :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <Space>fK :execute 'Rg ' . expand('<cWORD>')<CR>
nnoremap <Space>f8 :execute 'Rg \b' . expand('<cword>') . '\b'<CR>
nnoremap <Space>f* :execute 'Rg \b' . expand('<cWORD>') . '\b'<CR>
xnoremap <Space>fk :<C-U>execute 'Rg ' . vimrc#get_visual_selection()<CR>
xnoremap <Space>f8 :<C-U>execute 'Rg \b' . vimrc#get_visual_selection() . '\b'<CR>
nnoremap <Space>fl :BLines<CR>
nnoremap <Space>fL :Lines<CR>
nnoremap <Space>f<C-L> :execute 'BLines ' . expand('<cword>')<CR>
nnoremap <Space>fm :Mru<CR>
nnoremap <Space>fM :DirectoryMru<CR>
nnoremap <Space>f<C-M> :ProjectMru<CR>
nnoremap <Space>fn :execute 'FilesWithQuery ' . expand('<cword>')<CR>
nnoremap <Space>fN :execute 'FilesWithQuery ' . expand('<cWORD>')<CR>
nnoremap <Space>f% :execute 'FilesWithQuery ' . expand('%:t:r')<CR>
xnoremap <Space>fn :<C-U>execute 'FilesWithQuery ' . vimrc#get_visual_selection()<CR>
nnoremap <Space>fo :execute 'Locate ' . input('Locate: ')<CR>
nnoremap <Space>fr :execute 'Rg ' . input('Rg: ')<CR>
nnoremap <Space>fR :execute 'Rg! ' . input('Rg!: ')<CR>
nnoremap <Space>f4 :execute 'RgWithOption .:' . input('Option: ') . ':' . input('Rg: ')<CR>
nnoremap <Space>f$ :execute 'RgWithOption! .:' . input('Option: ') . ':' . input('Rg!: ')<CR>
nnoremap <Space>f? :execute 'RgWithOption .:' . vimrc#rg_current_type_option() . ':' . input('Rg: ')<CR>
nnoremap <Space>f5 :execute 'RgWithOption ' . expand('%:h') . '::' . input('Rg: ')<CR>
nnoremap <Space>fs :GFiles?<CR>
nnoremap <Space>fS :CurrentPlacedSigns<CR>
nnoremap <Space>ft :BTags<CR>
nnoremap <Space>fT :Tags<CR>
nnoremap <Space>fu :DirectoryAncestors<CR>
nnoremap <Space>fU :DirectoryFiles ..<CR>
nnoremap <Space>fw :Windows<CR>
nnoremap <Space>fy :Filetypes<CR>
nnoremap <Space>fY :execute 'GitFilesCommit ' . vimrc#fugitive#commit_sha()<CR>
nnoremap <Space>f<C-Y> :execute 'GitGrepCommit ' . vimrc#fugitive#commit_sha() . ' ' . input('Git grep: ')<CR>
nnoremap <Space>f' :Registers<CR>
nnoremap <Space>f` :Marks<CR>
nnoremap <Space>f: :History:<CR>
xnoremap <Space>f: :<C-U>History:<CR>
nnoremap <Space>f; :Commands<CR>
xnoremap <Space>f; :<C-U>Commands<CR>
nnoremap <Space>f/ :History/<CR>
nnoremap <Space>f] :execute "BTags '" . expand('<cword>')<CR>
xnoremap <Space>f] :<C-U>execute "BTags '" . vimrc#get_visual_selection()<CR>
nnoremap <Space>f} :execute "Tags '" . expand('<cword>')<CR>
xnoremap <Space>f} :<C-U>execute "Tags '" . vimrc#get_visual_selection()<CR>
nnoremap <Space>f<C-]> :execute 'Tselect ' . expand('<cword>')<CR>
xnoremap <Space>f<C-]> :<C-U>execute 'Tselect ' . vimrc#get_visual_selection()<CR>

" DirectoryMru
nnoremap <Space><C-D><C-D> :DirectoryMru<CR>
nnoremap <Space><C-D><C-F> :DirectoryMruFiles<CR>
nnoremap <Space><C-D><C-R> :DirectoryMruRg<CR>

nmap     <Space>sf vaf:SelectLines<CR>
xnoremap <Space>sf :SelectLines<CR>
nnoremap <Space>sl :ScreenLines<CR>
nnoremap <Space>sL :execute 'ScreenLines ' . expand('<cword>')<CR>
xnoremap <Space>sL :<C-U>execute 'ScreenLines ' . vimrc#get_visual_selection()<CR>
nnoremap <Space>ss :History:<CR>mks vim sessions

" fzf & cscope key mappings {{{
nnoremap <silent> <Leader>cs :call vimrc#fzf#cscope#cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call vimrc#fzf#cscope#cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call vimrc#fzf#cscope#cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call vimrc#fzf#cscope#cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call vimrc#fzf#cscope#cscope('4', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call vimrc#fzf#cscope#cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call vimrc#fzf#cscope#cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call vimrc#fzf#cscope#cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ca :call vimrc#fzf#cscope#cscope('9', expand('<cword>'))<CR>

xnoremap <silent> <Leader>cs :<C-U>call vimrc#fzf#cscope#cscope('0', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>cg :<C-U>call vimrc#fzf#cscope#cscope('1', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>cd :<C-U>call vimrc#fzf#cscope#cscope('2', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>cc :<C-U>call vimrc#fzf#cscope#cscope('3', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>ct :<C-U>call vimrc#fzf#cscope#cscope('4', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>ce :<C-U>call vimrc#fzf#cscope#cscope('6', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>cf :<C-U>call vimrc#fzf#cscope#cscope('7', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>ci :<C-U>call vimrc#fzf#cscope#cscope('8', vimrc#get_visual_selection())<CR>
xnoremap <silent> <Leader>ca :<C-U>call vimrc#fzf#cscope#cscope('9', vimrc#get_visual_selection())<CR>

nnoremap <silent> <Leader><Leader>cs :call vimrc#fzf#cscope#cscope_query('0')<CR>
nnoremap <silent> <Leader><Leader>cg :call vimrc#fzf#cscope#cscope_query('1')<CR>
nnoremap <silent> <Leader><Leader>cd :call vimrc#fzf#cscope#cscope_query('2')<CR>
nnoremap <silent> <Leader><Leader>cc :call vimrc#fzf#cscope#cscope_query('3')<CR>
nnoremap <silent> <Leader><Leader>ct :call vimrc#fzf#cscope#cscope_query('4')<CR>
nnoremap <silent> <Leader><Leader>ce :call vimrc#fzf#cscope#cscope_query('6')<CR>
nnoremap <silent> <Leader><Leader>cf :call vimrc#fzf#cscope#cscope_query('7')<CR>
nnoremap <silent> <Leader><Leader>ci :call vimrc#fzf#cscope#cscope_query('8')<CR>
nnoremap <silent> <Leader><Leader>ca :call vimrc#fzf#cscope#cscope_query('9')<CR>
" }}}

if has("nvim")
  nnoremap <Space>fp :ProjectTags<CR>
  nnoremap <Space>sp :ProjectTagsCaseSentitive<CR>
  nnoremap <Space>fP :execute "ProjectTags '" . expand('<cword>')<CR>
  xnoremap <Space>fP :<C-U>execute "ProjectTags '" . vimrc#get_visual_selection()<CR>
  nnoremap <Space><F8> :TagbarTags<CR>
endif
