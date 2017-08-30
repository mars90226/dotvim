" Bootstrap {{{
" ====================================================================
let g:mapleader=","

" Detect operating system
if has("win32") || has("win64")
  let s:uname = "windows"
else
  let s:uname = system("uname -a")
endif

" Set Encoding
if s:uname =~ "windows"
  set encoding=utf8
endif

" pathogen {{{
runtime bundle/vim-pathogen/autoload/pathogen.vim
let g:pathogen_disabled = ['racer']

" Choose autocompletion plugin
if s:uname =~ "windows" || s:uname =~ "synology"
  call add(g:pathogen_disabled, 'YouCompleteMe')
else
  call add(g:pathogen_disabled, 'supertab')
endif

if !has("python")
  call add(g:pathogen_disabled, 'github-issues.vim')
endif

call pathogen#infect()
call pathogen#helptags()
" }}}

" Vim basic setting
set nocompatible
if exists(":packadd") != 0
  source $VIMRUNTIME/vimrc_example.vim
endif

" source mswin.vim
if s:uname !~ "synology"
  source $VIMRUNTIME/mswin.vim
  behave mswin

  if s:uname !~ "windows"
    silent! unmap <C-a>
    silent! iunmap <C-a>
    silent! cunmap <C-a>
  endif

  if has("gui")
    silent! unmap <C-f>
    silent! iunmap <C-f>
    silent! cunmap <C-f>
  endif
endif
" }}}

" Plugin Settings Begin {{{
" }}}

" Appearance {{{
" ====================================================================
" vim-airline {{{
if s:uname !~ "windows"
  let g:airline_powerline_fonts = 1
endif

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 1
let g:airline#extensions#tabline#tab_nr_type   = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr   = 1
let g:airline#extensions#tabline#fnamemod      = ':p:.'
let g:airline#extensions#tabline#fnamecollapse = 1

let g:airline_theme = 'zenburn'
" }}}

" vim-indent-guides {{{
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd  ctermbg=243
autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=240
" }}}
" }}}

" Completion {{{
" ====================================================================
" YouCompleteMe {{{
if !pathogen#is_disabled("YouCompleteMe")
  let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
  let g:ycm_confirm_extra_conf    = 0
  let g:ycm_key_invoke_completion = '<M-/>'

  nnoremap <Leader>yy :let g:ycm_auto_trigger=0<CR>
  nnoremap <Leader>yY :let g:ycm_auto_trigger=1<CR>

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
endif
" }}}

" completion setting {{{
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" }}}

" neosnippet {{{
" Plugin key-mappings.
imap <C-l> <Plug>(neosnippet_expand_or_jump)
smap <C-l> <Plug>(neosnippet_expand_or_jump)
xmap <C-l> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<Tab>"
smap <expr><Tab> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)"
      \: "\<Tab>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" }}}
" }}}

" File Navigation {{{
" ====================================================================
" CtrlP {{{
if has("python")
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" }}}

" Vim-CtrlP-CmdPalette {{{
let g:ctrlp_cmdpalette_execute = 1
" }}}

" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number
" }}}

" Vinegar {{{
nmap <silent> _ <Plug>VinegarVerticalSplitUp
" }}}

" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
nnoremap <F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit<CR>
" }}}

" vim-choosewin {{{
nmap + <Plug>(choosewin)
" }}}

" Unite {{{
let g:unite_source_history_yank_enable = 1
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite
        \ -buffer-name=files buffer bookmark file<CR>
if has("nvim")
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>P :Unite -start-insert file_rec<CR>
nnoremap <Space>/ :Unite grep:.<CR>
nnoremap <Space>? :Unite grep:.:-r<CR>
nnoremap <Space>y :Unite history/yank<CR>
nnoremap <Space>S :Unite source<CR>
nnoremap <Space>m :Unite file_mru<CR>
nnoremap <Space>M :Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <Space>uj :Unite jump -start-insert<CR>
nnoremap <Space>uo :Unite outline<CR>
nnoremap <Space>uO :Unite output -start-insert<CR>
nnoremap <Space>ud :Unite directory<CR>
nnoremap <Space>uD :UniteWithBufferDir directory<CR>
nnoremap <Space>uC :Unite change<CR>
nnoremap <Space>uc :UniteWithCurrentDir
        \ -buffer-name=files buffer bookmark file<CR>
nnoremap <Space>ub :UniteWithBufferDir
        \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>up :UniteWithProjectDir
        \ -buffer-name=files -prompt=&\  buffer bookmark file<CR>
nnoremap <Space>ur :Unite
        \ -buffer-name=register register<CR>
nnoremap <Space>uf :Unite
        \ -buffer-name=resume resume<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>uma :Unite mapping<CR>
nnoremap <Space>ume :Unite output:message<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <Tab>   <Plug>(unite_select_next_line)
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <buffer><expr> S      unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ?
        \ ['sorter_reverse'] : [])

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
  nmap <silent><buffer><expr> <C-s>     unite#do_action('split')

  " Runs "vsplit" action by <C-v>.
  imap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')

  " Runs "persist_open" action by <C-p>.
  imap <silent><buffer><expr> <C-p>     unite#do_action('persist_open')
  nmap <silent><buffer><expr> <C-p>     unite#do_action('persist_open')
endfunction "}}}

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>/ :Unite grep:. -wrap<CR>
  nnoremap <Space>? :Unite grep:. -wrap<CR>
endif
" }}}

" gj {{{
nmap <Leader>g <Nop>
nnoremap <Leader>gj :Ack!<CR>
" }}}

" vim-grepper {{{
nnoremap <Leader>gg :Grepper -tool git<CR>
nnoremap <Leader>ga :Grepper -tool ag<CR>

nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" Optional. The default behaviour should work for most users.
let g:grepper               = {}
let g:grepper.tools         = ['git', 'ag', 'rg']
let g:grepper.jump          = 1
let g:grepper.next_tool     = '<Leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0
" }}}

" ctrlsf.vim {{{
nnoremap <Space><C-f> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" ranger {{{
let g:ranger_map_keys = 0
nnoremap <Space>rr :Ranger<CR>
nnoremap <Space>rs :split     <Bar> Ranger<CR>
nnoremap <Space>rv :vsplit    <Bar> Ranger<CR>
nnoremap <Space>rt :tab split <Bar> Ranger<CR>
" }}}

" fzf-vim {{{
" Mapping selecting mappings
nmap <Leader><Tab> <Plug>(fzf-maps-n)
xmap <Leader><Tab> <Plug>(fzf-maps-x)
omap <Leader><Tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)

command! -bar -bang Helptags call fzf#vim#helptags(<bang>0)

let g:rg_command = '
    \ rg --column --line-number --no-heading --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,lua,pm,vim}"
    \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '
command! -bang -nargs=* Rg call fzf#vim#grep(g:rg_command.shellescape(<q-args>), 1, <bang>0)
command! Mru call fzf#run(fzf#wrap({
      \ 'source':  reverse(s:all_files()),
      \ 'options': '-m -x +s',
      \ 'down':    '40%' }))

" TODO use neomru
function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\\[unite\\]\\|\[Preview\\]\\|__Tagbar__'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

map <Leader>fa :execute 'Ag ' . input('Ag: ')<CR>
map <Leader>fb :Buffers<CR>
map <Leader>fc :BCommits<CR>
map <Leader>fC :Commits<CR>
map <Leader>ff :Files<CR>
map <Leader>fF :Filetypes<CR>
map <Leader>fg :GFiles<CR>
map <Leader>fG :execute 'GGrep ' . input('Git grep: ')<CR>
map <Leader>fh :History<CR>
map <Leader>fl :BLines<CR>
map <Leader>fL :Lines<CR>
map <Leader>fm :Mru<CR>
map <Leader>fM :Commands<CR>
map <Leader>fr :execute 'Rg ' . input('Rg: ')<CR>
map <Leader>ft :BTags<CR>
map <Leader>fT :Tags<CR>
map <Leader>fw :Windows<CR>
map <Leader>f` :Marks<CR>
" }}}
" }}}

" Text Navigation {{{
" ====================================================================
" EasyMotion {{{
let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ; <Plug>(easymotion-s2)

map <Space><Space>w <Plug>(easymotion-bd-wl)
map <Space><Space>f <Plug>(easymotion-bd-fl)

map <Plug>(easymotion-prefix)f <Plug>(easymotion-bd-f)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)L <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

if s:uname !~ "synology"
  nmap <Plug>(easymotion-prefix)f <Plug>(easymotion-overwin-f)
  nmap <Plug>(easymotion-prefix)s <Plug>(easymotion-overwin-f2)
  nmap <Plug>(easymotion-prefix)L <Plug>(easymotion-overwin-line)
  nmap <Plug>(easymotion-prefix)w <Plug>(easymotion-overwin-w)
endif
" }}}

" incsearch {{{
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Search within visual selection
if !has("nvim") && s:uname !~ "windows"
  set <M-/>=/
  set <M-?>=?
endif
vmap <M-/> <Esc><Plug>(incsearch-forward)\%V
vmap <M-?> <Esc><Plug>(incsearch-backward)\%V
if s:uname =~ "windows"
  set encoding& " make sure mapping is correct in default encoding
  vmap <M-/> <Esc><Plug>(incsearch-forward)\%V
  vmap <M-?> <Esc><Plug>(incsearch-backward)\%V
  set encoding=utf8
endif

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
" }}}

" incsearch-fuzzy {{{
map z/  <Plug>(incsearch-fuzzy-/)
map z?  <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
" }}}

" incsearch-easymotion {{{
map <Leader>/  <Plug>(incsearch-easymotion-/)
map <Leader>?  <Plug>(incsearch-easymotion-?)
map <Leader>g/ <Plug>(incsearch-easymotion-stay)
" }}}

" incsearch.vim x fuzzy x vim-easymotion {{{
function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Leader><Leader>/ incsearch#go(<SID>config_easyfuzzymotion())
" }}}

" CamelCaseMotion {{{
map ,mw <Plug>CamelCaseMotion_w
map ,mb <Plug>CamelCaseMotion_b
map ,me <Plug>CamelCaseMotion_e
map ,mge <Plug>CamelCaseMotion_ge
" }}}

" clever-f.vim {{{
let g:clever_f_smart_case = 1
" }}}
" }}}

" Text Manipulation {{{
" ====================================================================
" Tabular {{{
nmap <Leader>a=    :Tabularize /=<CR>
vmap <Leader>a=    :Tabularize /=<CR>
nmap <Leader>a:    :Tabularize /:\zs<CR>
vmap <Leader>a:    :Tabularize /:\zs<CR>
nmap <Leader>athen :Tabularize /then<CR>
vmap <Leader>athen :Tabularize /then<CR>
" }}}

" EasyAlign {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" auto-pairs {{{
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}
" }}}

" eraseSubword {{{
let g:EraseSubword_insertMap = '<C-e><C-e>'
" }}}
" }}}

" Languages {{{
" ====================================================================
" emmet {{{
let g:user_emmet_leader_key = '<C-e>'
" }}}

" tagbar {{{
nmap <F8> :TagbarToggle<CR>
let g:tagbar_map_showproto = '<Leader><Space>'
let g:tagbar_expand = 1
let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
      \ 'p:package',
      \ 'i:imports:1',
      \ 'c:constants',
      \ 'v:variables',
      \ 't:types',
      \ 'n:interfaces',
      \ 'w:fields',
      \ 'e:embedded',
      \ 'm:methods',
      \ 'r:constructor',
      \ 'f:functions'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
      \ 't' : 'ctype',
      \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
      \ 'ctype' : 't',
      \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
      \ }
" }}}

" cscope {{{
nmap <F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
      \:!cscope -b -i cscope.files -f cscope.out<CR>
      \:cs kill -1<CR>:cs add cscope.out<CR>
" }}}

" vim-seeing-is-believing {{{
augroup seeingIsBelievingSettings
  autocmd!

  autocmd FileType ruby nmap <buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)
  autocmd FileType ruby xmap <buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)

  autocmd FileType ruby nmap <buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby xmap <buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  autocmd FileType ruby imap <buffer> <Leader>rm <Plug>(seeing-is-believing-mark)

  autocmd FileType ruby nmap <buffer> <Leader>rr <Plug>(seeing-is-believing-run)
  autocmd FileType ruby imap <buffer> <Leader>rr <Plug>(seeing-is-believing-run)
augroup END
" }}}

" Syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:sytastic_check_on_wq               = 0

let g:syntastic_ruby_checkers = ['mri', 'rubylint']
let g:syntastic_tex_checkers  = ['lacheck']
let g:syntastic_c_checkers    = ['gcc']
let g:syntastic_cpp_checkers  = ['gcc']
nnoremap <Space><F8> :SyntasticToggleMode<CR>
" }}}

" racer {{{
if !pathogen#is_disabled("racer")
  let g:racer_cmd = $RACER_CMD
endif
" }}}
" }}}

" Git {{{
" ====================================================================
" vim-fugitive {{{
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
nnoremap <silent> <Leader>gE :Gedit<space>
nnoremap <silent> <Leader>gr :Gread<CR>
nnoremap <silent> <Leader>gR :Gread<space>
nnoremap <silent> <Leader>gw :Gwrite<CR>
nnoremap <silent> <Leader>gW :Gwrite!<CR>
nnoremap <silent> <Leader>gq :Gwq<CR>
nnoremap <silent> <Leader>gQ :Gwq!<CR>

function! ReviewLastCommit()
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction
nnoremap <silent> <Leader>g` :call ReviewLastCommit()<CR>

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END
" }}}

" fugitive-gitlab {{{
let g:fugitive_gitlab_domains = ['https://git.synology.com']
" }}}

" vim gitgutter {{{
nmap <silent> ]h :<C-u>execute v:count1 . "GitGutterNextHunk"<CR>
nmap <silent> [h :<C-u>execute v:count1 . "GitGutterPrevHunk"<CR>
nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gt :GitGutterAll<CR>
" }}}
" }}}

" Utility {{{
" ====================================================================
" Gundo {{{
if has('python3')
  let g:gundo_prefer_python3 = 1
endif
nnoremap <F9> :GundoToggle<CR>
" }}}

" vim-unimpaired {{{
nnoremap coe :set expandtab!<CR>
" }}}

" vim-characterize {{{
nmap gA <Plug>(characterize)
" }}}

" vim-peekaboo {{{
let g:peekaboo_delay = 400
" }}}

" colorv {{{
nnoremap <silent> <Leader>cN :ColorVName<CR>
" }}}

" VimShell {{{
nnoremap <silent> <Leader>vv :VimShell<CR>
nnoremap <silent> <Leader>vc :VimShellCurrentDir<CR>
nnoremap <silent> <Leader>vb :VimShellBufferDir<CR>
nnoremap <silent> <Leader>vt :VimShellTab<CR>
" }}}

" vim-rooter {{{
let g:rooter_manual_only = 1
" }}}

" vimwiki {{{
nnoremap <Leader>wg :VimwikiToggleListItem<CR>
" }}}
" }}}

" Plugin Settings End {{{
" }}}

" General Settings {{{
" ====================================================================
set number
set hidden
set lazyredraw
set mouse=a
set modeline

set scrolloff=0

set diffopt=filler,vertical

" ignore pattern for wildmenu
set wildmenu
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set wildmode=list:longest,full

" show hidden characters
set list
set listchars=tab:\|\ ,extends:›,precedes:‹,nbsp:·,trail:·

set laststatus=2
set showcmd

" no distraction
if has("balloon_eval")
  set noballooneval
endif
set belloff=all

" move temporary files
set backupdir^=~/.vimtmp
set directory^=~/.vimtmp
if v:version >= 703
  set undodir^=~/.vimtmp
endif

" session options
set sessionoptions+=localoptions
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank

" fzf {{{
set runtimepath+=~/.fzf
" }}}

" filetype
filetype on
filetype plugin on
filetype indent on

" misc
set shellslash
set grepprg=grep\ -nH\ $*
set t_Co=256
set foldlevelstart=99
" }}}

" Indention {{{
" ====================================================================
set smarttab
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set pastetoggle=<F10>
" }}}

" Search {{{
" ====================================================================
set nohlsearch
set ignorecase
set incsearch
set smartcase

if has("nvim")
  set inccommand=split
endif
" }}}

" Colors and Highlights {{{
" ====================================================================
set background=dark
colorscheme seoul256
" }}}

" Key Mappings {{{
" ====================================================================
" Add key mapping for suspend
nnoremap <Space><C-z> :suspend<CR>

" Quickly switch window {{{
if s:uname !~ "synology"
  " Fix meta key in vim
  if !has("nvim") && s:uname !~ "windows"
    set <M-h>=h
    set <M-j>=j
    set <M-k>=k
    set <M-l>=l
  endif

  " Pair up with 'set winaltkeys=no' in _gvimrc
  nmap <M-h> <C-w>h
  nmap <M-j> <C-w>j
  nmap <M-k> <C-w>k
  nmap <M-l> <C-w>l
  if s:uname =~ "windows"
    set encoding& " make sure mapping is correct in default encoding
    nmap <M-h> <C-w>h
    nmap <M-j> <C-w>j
    nmap <M-k> <C-w>k
    nmap <M-l> <C-w>l
    set encoding=utf8
  endif

  " Move in insert mode
  imap <M-h> <Left>
  imap <M-j> <Down>
  imap <M-k> <Up>
  imap <M-l> <Right>
  if s:uname =~ "windows"
    set encoding& " make sure mapping is correct in default encoding
    imap <M-h> <Left>
    imap <M-j> <Down>
    imap <M-k> <Up>
    imap <M-l> <Right>
    set encoding=utf8
  endif
endif
" }}}

" Saner command-line history {{{
if s:uname !~ "synology"
  " Fix meta key in vim
  if !has("nvim") && s:uname !~ "windows"
    set <M-n>=n
    set <M-p>=p
  endif

  cnoremap <M-n> <Down>
  cnoremap <M-p> <Up>
  if s:uname =~ "windows"
    set encoding& " make sure mapping is correct in default encoding
    cnoremap <M-n> <Down>
    cnoremap <M-p> <Up>
    set encoding=utf8
  endif
endif
" }}}

" Quickly switch tab
nnoremap <C-j> gT
nnoremap <C-k> gt

nnoremap <Leader>1 1gt
nnoremap <Leader>2 2gt
nnoremap <Leader>3 3gt
nnoremap <Leader>4 4gt
nnoremap <Leader>5 5gt
nnoremap <Leader>6 6gt
nnoremap <Leader>7 7gt
nnoremap <Leader>8 8gt
nnoremap <Leader>9 9gt

" Quickly adjust window size
map <C-w><Space>- <C-w>10-
map <C-w><Space>+ <C-w>10+
map <C-w><Space>< <C-w>10<
map <C-w><Space>> <C-w>10>

" Add mapping to delete in insert mode
inoremap <C-b> <Right><BS>

" Win32
"nmap <Leader>x :execute ':! "'.expand('%').'"'<CR>
nmap <Leader>x :!start cmd /c "%:p"<CR>
nmap <Leader>X :!start cmd /K cd /D %:p:h<CR>
nmap <Leader>E :execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'<CR>

" Custom function {{{
nnoremap <F6> :call ToggleIndentBetweenTabAndSpace()<CR>
function! ToggleIndentBetweenTabAndSpace()
  if &expandtab
    setlocal noexpandtab
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
  else
    setlocal expandtab
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
  endif
endfunction

nnoremap <F7> :call ToggleFoldBetweenManualAndSyntax()<CR>
function! ToggleFoldBetweenManualAndSyntax()
  if &foldmethod == 'manual'
    setlocal foldmethod=syntax
  else
    setlocal foldmethod=manual
  endif
endfunction

let g:last_tab = 1
if !has("nvim") && s:uname !~ "windows"
  set <M-1>=1
endif
nmap <M-1> :execute "tabn " . g:last_tab<CR>
if s:uname =~ "windows"
  set encoding& " make sure mapping is correct in default encoding
  nmap <M-1> :execute "tabn " . g:last_tab<CR>
  set encoding=utf8
endif
au TabLeave * let g:last_tab = tabpagenr()
" }}}

" Custom command {{{
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()
"autocmd BufWritePre * :call TrimWhitespace()
" }}}
" }}}

" Terminal {{{
" ====================================================================
" xterm-256 in Windows {{{
if !has("gui_running") && s:uname =~ "windows"
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
endif
" }}}

" neovim terminal key mapping
if has("nvim")
  " For quick terminal access
  nnoremap <silent> <Leader>tt :tabnew<CR>:terminal<CR>
  nnoremap <silent> <Leader>ts :new<CR>:terminal<CR>
  nnoremap <silent> <Leader>tv :vnew<CR>:terminal<CR>

  tnoremap <Space><F1> <C-\><C-n>
  tnoremap <Space><F2> <C-\><C-n>:tabnew<CR>:terminal<CR>

  " Quickly switch window in terminal
  tnoremap <M-S-h> <C-\><C-n><C-w>h
  tnoremap <M-S-j> <C-\><C-n><C-w>j
  tnoremap <M-S-k> <C-\><C-n><C-w>k
  tnoremap <M-S-l> <C-\><C-n><C-w>l

  " Quickly switch tab in terminal
  tnoremap <M-C-j> <C-\><C-n>gTi
  tnoremap <M-C-k> <C-\><C-n>gti

  tnoremap <M-1> <C-\><C-n>:exe "tabn " . g:last_tab<CR>
endif
" }}}

" Autocommands {{{
" ====================================================================
augroup vimGeneralCallbacks
  autocmd!
  if s:uname =~ "windows"
    autocmd BufWritePost _vimrc nested source $MYVIMRC
  else
    autocmd BufWritePost .vimrc nested source $MYVIMRC
  endif
augroup END

augroup fileTypeSpecific
  autocmd!

  " Rack
  autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby

  autocmd BufNewFile,BufReadPost *maillog*            set filetype=messages
  autocmd BufNewFile,BufReadPost *conf                set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override set filetype=conf
  autocmd BufNewFile,BufReadPost Makefile.inc         set filetype=make
  autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              set filetype=cerr
augroup END

augroup quickfixSettings
  autocmd!
  autocmd FileType qf
        \ nnoremap <buffer> <silent> q :close<CR> |
        \ map <buffer> <silent> <F4> :close<CR> |
        \ map <buffer> <silent> <F8> :close<CR>
augroup END
" }}}

" Fix and Workarounds {{{
" ====================================================================
" Prevent CTRL-F to abort the selection (in visual mode)
" This is caused by $VIM/_vimrc ':behave mswin' which sets 'keymodel' to
" include 'stopsel' which means that non-shifted special keys stop selection.
set keymodel=startsel

" disable Background Color Erase (BC) by clearing the `t_ut` on Synology DSM
" see https://sunaku.github.io/vim-256color-bce.html
if s:uname =~ "synology"
  set t_ut=
endif
" }}}

" vim: set sw=2 ts=2 sts=2 et foldlevel=0 foldmethod=marker:
