" Detect operating system
if has("win32") || has("win64")
  let s:uname = "windows"
else
  let s:uname = system("uname -a")
endif

" pathogen
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
" pathogen

set nocompatible
if exists(":packadd") != 0
  source $VIMRUNTIME/vimrc_example.vim
endif

" source mswin.vim
if s:uname !~ "synology"
  source $VIMRUNTIME/mswin.vim
  behave mswin

  if s:uname !~ "windows"
    cunmap <C-a>
  endif
endif

" add key mapping for suspend
nnoremap <Space><C-z> :suspend<CR>

let mapleader=","

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
    set encoding=utf8 " make sure mapping is correct in UTF-8
    nmap <M-h> <C-w>h
    nmap <M-j> <C-w>j
    nmap <M-k> <C-w>k
    nmap <M-l> <C-w>l
    set encoding&
  endif

  " Move in insert mode
  imap <M-h> <Left>
  imap <M-j> <Down>
  imap <M-k> <Up>
  imap <M-l> <Right>
  if s:uname =~ "windows"
    set encoding=utf8 " make sure mapping is correct in UTF-8
    imap <M-h> <Left>
    imap <M-j> <Down>
    imap <M-k> <Up>
    imap <M-l> <Right>
    set encoding&
  endif
endif

" Quickly switch tab
nnoremap <C-j> gT
nnoremap <C-k> gt

" Quickly adjust window size
map <C-w><Space>- <C-w>10-
map <C-w><Space>+ <C-w>10+
map <C-w><Space>< <C-w>10<
map <C-w><Space>> <C-w>10>

" add mapping to delete in insert mode
inoremap <C-b> <Right><BS>

" Win32
"nmap <Leader>x :execute ':! "'.expand('%').'"'<CR>
nmap <Leader>x :!start cmd /c "%:p"<CR>
nmap <Leader>X :!start cmd /K cd /D %:p:h<CR>
nmap <Leader>E :exec "!start explorer \"".expand("%:p:h:gs?\\??:gs?/?\\?")."\""<CR>

" Tabular
nmap <Leader>a=    :Tabularize /=<CR>
vmap <Leader>a=    :Tabularize /=<CR>
nmap <Leader>a:    :Tabularize /:\zs<CR>
vmap <Leader>a:    :Tabularize /:\zs<CR>
nmap <Leader>athen :Tabularize /then<CR>
vmap <Leader>athen :Tabularize /then<CR>
" Tabular

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" EasyAlign

" CtrlP
if has("python")
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" CtrlP

" Vim-CtrlP-CmdPalette
let g:ctrlp_cmdpalette_execute = 1
" Vim-CtrlP-CmdPalette

" emmet
let g:user_emmet_leader_key = '<C-e>'
" emmet

" delimitMate
imap <silent> <C-y> <Plug>delimitMateS-Tab
" delimitMate

" eraseSubword
let g:EraseSubword_insertMap = '<C-e><C-e>'
" eraseSubword

" netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number
nnoremap <silent> <F4> :Lexplore<CR>
" netrw

" Vinegar
nmap <silent> _ <Plug>VinegarVerticalSplitUp
" Vinegar

" vim-airline
set laststatus=2
if s:uname !~ "windows"
  let g:airline_powerline_fonts = 1
endif

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 1
let g:airline#extensions#tabline#tab_nr_type   = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr   = 1
let g:airline#extensions#tabline#fnamemod      = ':p:.'
let g:airline#extensions#tabline#fnamecollapse = 1

let g:airline_theme = 'tomorrow'
" vim-airline

if s:uname !~ "synology"
  " YouCompleteMe
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
  " YouCompleteMe
endif

" completion setting
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" completion setting

" neosnippet
" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

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
" neosnippet

" vim gitgutter
nmap <silent> ]h :<C-u>execute v:count1 . "GitGutterNextHunk"<CR>
nmap <silent> [h :<C-u>execute v:count1 . "GitGutterPrevHunk"<CR>
nmap <silent> <Leader>gt :GitGutterToggle<CR>
" vim gitgutter

" fugitive-gitlab
let g:fugitive_gitlab_domains = ['https://git.synology.com']
" fugitive-gitlab

" tagbar
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
" tagbar

" cscope
nmap <F11> :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
      \:!cscope -b -i cscope.files -f cscope.out<CR>
      \:cs kill -1<CR>:cs add cscope.out<CR>
" cscope

" EasyMotion
let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

nmap ; <Plug>(easymotion-s2)
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
" EasyMotion

" incsearch
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

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
" incsearch

" incsearch-fuzzy
map z/  <Plug>(incsearch-fuzzy-/)
map z?  <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
" incsearch-fuzzy

" incsearch-easymotion
map <Leader>/  <Plug>(incsearch-easymotion-/)
map <Leader>?  <Plug>(incsearch-easymotion-?)
map <Leader>g/ <Plug>(incsearch-easymotion-stay)
" incsearch-easymotion

" incsearch.vim x fuzzy x vim-easymotion
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
" incsearch.vim x fuzzy x vim-easymotion

" CamelCaseMotion
map ,mw <Plug>CamelCaseMotion_w
map ,mb <Plug>CamelCaseMotion_b
map ,me <Plug>CamelCaseMotion_e
" CamelCaseMotion

" vim-easy-align
vnoremap <silent> <CR> :EasyAlign<CR>
" vim-easy-align

" vim-ruby-xmpfilter
nmap <Leader>rr <Plug>(xmpfilter-run)
xmap <Leader>rr <Plug>(xmpfilter-run)
imap <Leader>rr <Plug>(xmpfilter-run)

nmap <Leader>rm <Plug>(xmpfilter-mark)
xmap <Leader>rm <Plug>(xmpfilter-mark)
imap <Leader>rm <Plug>(xmpfilter-mark)"
" vim-ruby-xmpfilter

" background toggle
nmap <Leader>bg :let &background = ( &background == "dark" ? "light" : "dark" )<CR>
" background toggle

" Gundo
if has('python3')
  let g:gundo_prefer_python3 = 1
endif
nnoremap <F9> :GundoToggle<CR>
" Gundo

" colorv
nnoremap <silent> <Leader>cN :ColorVName<CR>
" colorv

" VimShell
nnoremap <silent> <Leader>vv :VimShell<CR>
nnoremap <silent> <Leader>vc :VimShellCurrentDir<CR>
nnoremap <silent> <Leader>vb :VimShellBufferDir<CR>
nnoremap <silent> <Leader>vt :VimShellTab<CR>
" VimShell

" Unite
let g:unite_source_history_yank_enable = 1
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite
        \ -buffer-name=files buffer bookmark file<CR>
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
nnoremap <Space>uC :Unite change<CR>
nnoremap <Space>uc :UniteWithCurrentDir
        \ -buffer-name=files buffer bookmark file<CR>
nnoremap <Space>ub :UniteWithBufferDir
        \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
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
" Unite

" gj
nmap <Leader>g <Nop>
nnoremap <Leader>gg :Ack!<CR>
" gj

" Syntastic
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
" Syntastic

" racer
set hidden
let g:racer_cmd = "D:/download/git/racer/target/release/racer"
let $RUST_SRC_PATH = "D:/download/git/rust/src/"
" racer

" vim-indent-guides
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd ctermbg=243
autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=240
" vim-indent-guides

" vim-grepper
nnoremap <Leader>g :Grepper -tool git<CR>
nnoremap <Leader>G :Grepper -tool ag<CR>

nmap gs <Plug>(GrepperOperator)
xmap gs <Plug>(GrepperOperator)

" Optional. The default behaviour should work for most users.
let g:grepper               = {}
let g:grepper.tools         = ['git', 'ag', 'rg']
let g:grepper.jump          = 1
let g:grepper.next_tool     = '<Leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0
" vim-grepper

" ctrlsf.vim
nnoremap <Space><C-f> :CtrlSF 
nnoremap <F5> :CtrlSFToggle<CR>
" ctrlsf.vim

" ranger
let g:ranger_map_keys = 0
nnoremap <Space>rr :Ranger<CR>
nnoremap <Space>rs :split     <Bar> Ranger<CR>
nnoremap <Space>rv :vsplit    <Bar> Ranger<CR>
nnoremap <Space>rt :tab split <Bar> Ranger<CR>
" ranger

" vim-rooter
let g:rooter_manual_only = 1
" vim-rooter

" fzf-vim
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
map <Leader>fr :execute 'Rg ' . input('Rg: ')<CR>
map <Leader>ft :BTags<CR>
map <Leader>fT :Tags<CR>
map <Leader>fw :Windows<CR>
" fzf-vim

" vimwiki
nnoremap <Leader>wg :VimwikiToggleListItem<CR>
" vimwiki

" xterm-256 in Windows
if !has("gui_running") && s:uname =~ "windows"
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
endif
" xterm-256 in Windows

if has("balloon_eval")
  set noballooneval
endif
set backupdir^=~/.vimtmp
set directory^=~/.vimtmp
set nu
set autoindent
set nohlsearch
set ignorecase
set incsearch
set smartcase
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set noexpandtab
set shellslash
set list
set listchars=tab:\|\ 
set grepprg=grep\ -nH\ $*
set t_Co=256
set wildmenu
set foldlevelstart=99
set scrolloff=0
set mouse=a
set sessionoptions+=localoptions
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank
set rtp+=~/.fzf
set background=dark
filetype on
filetype plugin on
filetype indent on
colorscheme Tomorrow-Night

if has("nvim")
  set inccommand=split
endif

" Prevent CTRL-F to abort the selection (in visual mode)
" This is caused by $VIM/_vimrc ':behave mswin' which sets 'keymodel' to
" include 'stopsel' which means that non-shifted special keys stop selection.
set keymodel=startsel

if s:uname =~ "windows"
  let $TMP="C:/tmp"
else
  let $TMP="/tmp"
endif

" disable Background Color Erase (BC) by clearing the `t_ut` on Synology DSM
" see https://sunaku.github.io/vim-256color-bce.html
if s:uname =~ "synology"
  set t_ut=
endif

" Enable omni completion. Not required if they are already set elsewhere in .vimrc
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python        setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

" filetype detection
autocmd BufNewFile,BufReadPost *maillog*            set filetype=messages
autocmd BufNewFile,BufReadPost *conf                set filetype=conf
autocmd BufNewFile,BufReadPost *conf.local          set filetype=conf
autocmd BufNewFile,BufReadPost *conf.local.override set filetype=conf
autocmd BufNewFile,BufReadPost Makefile.inc         set filetype=make
autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb
autocmd BufNewFile,BufReadPost *.build              set filetype=cerr
autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby
" filetype detection

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

nnoremap <Space><F7> :set spell!<CR>

let g:lasttab = 1
if !has("nvim") && s:uname !~ "windows"
  set <M-1>=1
endif
nmap <M-1> :exe "tabn ".g:lasttab<CR>
if s:uname =~ "windows"
  set encoding=utf8 " make sure mapping is correct in UTF-8
  nmap <M-1> :exe "tabn ".g:lasttab<CR>
  set encoding&
endif
au TabLeave * let g:lasttab = tabpagenr()

" neovim terminal key mapping
if has("nvim")
  " For quick terminal access
  nnoremap <Space><F2> :tabe term://$SHELL <Bar> startinsert<CR>
  tnoremap <Space><F2> <C-\><C-n>:tabe term://$SHELL <Bar> startinsert<CR>

  tnoremap <Space><F1> <C-\><C-n>

  tnoremap <M-S-h> <C-\><C-n><C-w>h
  tnoremap <M-S-j> <C-\><C-n><C-w>j
  tnoremap <M-S-k> <C-\><C-n><C-w>k
  tnoremap <M-S-l> <C-\><C-n><C-w>l

  tnoremap <M-C-j> <C-\><C-n>gTi
  tnoremap <M-C-k> <C-\><C-n>gti

  tnoremap <M-1> <C-\><C-n>:exe "tabn ".g:lasttab<CR>
endif
" neovim terminal key mapping

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
