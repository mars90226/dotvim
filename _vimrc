" Bootstrap {{{
" ====================================================================
let g:mapleader=","

" Detect operating system
if has("win32") || has("win64")
  let s:os = "windows"
else
  let s:os = system("uname -a")
endif

" Set $VIMHOME
if s:os =~ "windows"
  let $VIMHOME = $VIM."/vimfiles"
else
  let $VIMHOME = $HOME."/.vim"
endif

" Set Encoding
if s:os =~ "windows"
  set encoding=utf8
endif

" plugin choosing {{{
let g:plugin_disabled = []

function! s:disable_plugin(plugin)
  call add(g:plugin_disabled, a:plugin)
endfunction

function! s:is_disabled_plugin(plugin)
  return index(g:plugin_disabled, a:plugin) != -1
endfunction

" Choose autocompletion plugin {{{
" YouCompleteMe, supertab, deoplete.nvim
if s:os =~ "windows" || s:os =~ "synology"
  " supertab
  call s:disable_plugin('YouCompleteMe')
  call s:disable_plugin('deoplete.nvim')
elseif has("nvim") && has("python3")
  " deoplete.nvim
  call s:disable_plugin('YouCompleteMe')
  call s:disable_plugin('supertab')
else
  " YouCompleteMe
  call s:disable_plugin('deoplete.nvim')
  call s:disable_plugin('supertab')
endif
" }}}

" Choose Lint plugin
" syntastic, ale
if v:version >= 800 || has("nvim")
  call s:disable_plugin('syntastic')
else
  call s:disable_plugin('ale')
end

if !has("python")
  call s:disable_plugin('github-issues.vim')
endif

if !((v:version >= 800 || has("nvim")) && has("python3"))
  call s:disable_plugin('denite.nvim')
end
" }}}

" Autoinstall vim-plug {{{
" TODO Add Windows support
if empty(glob($VIMHOME.'/autoload/plug.vim'))
  silent! !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://rawgithubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}
" }}}

" Plugin Settings Begin {{{
" vim-plug
call plug#begin($VIMHOME.'/plugged')
" }}}

" Appearance {{{
" ====================================================================
" vim-airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'https://gist.github.com/jbkopecky/a2f66baa8519747b388f2a1617159c07',
    \ { 'as': 'vim-airline-seoul256', 'do': 'mkdir -p autoload/airline/themes; cp -f *.vim autoload/airline/themes' }

let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled       = 1
let g:airline#extensions#tabline#show_buffers  = 1
let g:airline#extensions#tabline#tab_nr_type   = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr   = 1
let g:airline#extensions#tabline#fnamemod      = ':p:.'
let g:airline#extensions#tabline#fnamecollapse = 1

" TODO Fix the colors the match seoul256 theme
"let g:airline_theme = 'seoul256'
let g:airline_theme = 'zenburn'
" }}}

" indentLine {{{
Plug 'Yggdroot/indentLine', { 'on': ['IndentLinesEnable', 'IndentLinesToggle'] }

let g:indentLine_color_term = 243
let g:indentLine_color_gui = '#AAAAAA'

nnoremap <Space>il :IndentLinesToggle<CR>

autocmd! User indentLine doautocmd indentLine Syntax
" }}}

" vim-devicons {{{
" Disable for now as Fira Code nerd fonts is not patched
Plug 'ryanoasis/vim-devicons', { 'for': [] }
" }}}

" Colors {{{
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'
" }}}
" }}}

" Completion {{{
" ====================================================================

" FIXME Completion popup still appear after select completion.
" completion setting {{{
" inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
" }}}

" YouCompleteMe {{{
if !s:is_disabled_plugin('YouCompleteMe')
  Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang_completer' }

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

" deoplete.nvim {{{
if !s:is_disabled_plugin('deoplete.nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Currently prefer deoplete-clang over clang_complete
  " Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'], 'do': 'make install' }
  Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] }
  " Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp'] }
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/neco-syntax'
  Plug 'Shougo/neco-vim'
  Plug 'sebastianmarkow/deoplete-rust', { 'for': ['rust'] }
  " Disabled for now
  " Plug 'autozimu/LanguageClient-neovim', {
  "   \ 'branch': 'next',
  "   \ 'do': './install.sh'
  "   \ }

  " Use deoplete.
  let g:deoplete#enable_at_startup = 1
  " Use smartcase.
  let g:deoplete#enable_smart_case = 1
  " Disable auto_complete
  " let g:deoplete#disable_auto_complete = 1

  " deoplete_clang
  let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-5.0/lib/libclang.so.1"
  let g:deoplete#sources#clang#clang_header = "/usr/lib/llvm-5.0/lib/clang"

  " clang_complete
  " let g:clang_library_path='/usr/lib/llvm-5.0/lib/libclang.so.1'
  "
  " let g:clang_debug = 1
  " let g:clang_use_library = 1
  " let g:clang_complete_auto = 0
  " let g:clang_auto_select = 0
  " let g:clang_omnicppcomplete_compliance = 0
  " let g:clang_make_default_keymappings = 0

  " deoplete_rust
  let g:deoplete#sources#rust#racer_binary = $HOME."/.cargo/bin/racer"
  let g:deoplete#sources#rust#rust_source_path = "/code/rust/src"

  " LanguageClient-neovim
  " let g:LanguageClient_serverCommands = {
  "     \ 'c': ['cquery', '--language-server'],
  "     \ 'cpp': ['cquery', '--language-server'],
  "     \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
  "     \ }
  " let g:LanguageClient_loadSettings = 1
  " let g:LanguageClient_settingsPath = $VIMHOME."/settings.json"

  " <Tab>: completion.
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ deoplete#manual_complete()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction "}}}

  " <S-Tab>: completion back.
  inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  inoremap <expr> <Esc> pumvisible() ? deoplete#smart_close_popup() : "\<Esc>"
  inoremap <expr> <C-e><C-e> deoplete#smart_close_popup()

  inoremap <expr><C-g><C-g> deoplete#refresh()
  inoremap <silent><expr><C-l> deoplete#complete_common_string()
endif
" }}}

" supertab {{{
if !s:is_disabled_plugin('supertab')
  Plug 'ervandew/supertab'
endif
" }}}

" neosnippet {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

let g:neosnippet#snippets_directory = $VIMHOME.'/plugged/neosnippet-snippets/neosnippets'
let g:neosnippet#snippets_directory = $VIMHOME.'/plugged/vim-snippets/snippets'

" Plugin key-mappings.
" <C-j>: expand or jump or select completion
imap <silent><expr> <C-j>
      \ pumvisible() && !neosnippet#expandable_or_jumpable() ?
      \ "\<C-y>" :
      \ "\<Plug>(neosnippet_expand_or_jump)"
smap <C-j> <Plug>(neosnippet_expand_or_jump)
xmap <C-j> <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" }}}

" tmux-complete.vim {{{
Plug 'wellle/tmux-complete.vim'
" }}}
" }}}

" File Navigation {{{
" ====================================================================
" CtrlP {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mattn/ctrlp-hackernews'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'ivalkeen/vim-ctrlp-tjump'

if has("python")
  Plug 'FelikZ/ctrlp-py-matcher'

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" let g:ctrlp_cmdpalette_execute = 1

nnoremap <C-p> :CtrlP<CR>
nnoremap <Space>cf :CtrlPFunky<CR>
nnoremap <Space>cp :CtrlPCmdPalette<CR>
nnoremap <Space>cm :CtrlPCmdline<CR>
nnoremap <Space>c] :CtrlPtjump<CR>
xnoremap <Space>c] :CtrlPtjumpVisual<CR>

if executable('fd')
  let g:ctrlp_user_command = 'fd --type f --no-ignore --hidden --follow --exclude .git --exclude node_modules "" %s'
endif
" }}}

" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number
" }}}

" Vinegar {{{
Plug 'tpope/vim-vinegar'

nmap <silent> _ <Plug>VinegarVerticalSplitUp
" }}}

" tagbar {{{
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }

nnoremap <F8> :TagbarToggle<CR>
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
let g:tagbar_type_ps1 = {
    \ 'ctagstype' : 'powershell',
    \ 'kinds'     : [
      \ 'f:function',
      \ 'i:filter',
      \ 'a:alias'
    \ ]
    \ }
" }}}

" vim-rtags {{{
"if s:os !~ "windows" && s:os !~ "synology"
  "Plug 'lyuts/vim-rtags'
"endif
" }}}

" vimfiler {{{
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/neossh.vim'

let g:vimfiler_as_default_explorer = 1
nnoremap <F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit<CR>
nnoremap <Space><F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit -find<CR>
autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
  " Runs "tabopen" action by <C-t>.
  nmap <silent><buffer><expr> <C-t>     vimfiler#do_action('tabopen')

  " Runs "choose" action by <C-c>.
  nmap <silent><buffer><expr> <C-c>     vimfiler#do_action('choose')

  " Toggle no_quit with <C-n>
  nmap <silent><buffer>       <C-n>     :let b:vimfiler.context.quit = !b:vimfiler.context.quit<CR>

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer>       `         <Plug>(vimfiler_toggle_mark_current_line)
endfunction
" }}}

" vim-choosewin {{{
Plug 't9md/vim-choosewin'

" seoul256 colors
let g:choosewin_color_label_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
let g:choosewin_color_label = { 'gui': ['#719872', ''], 'cterm': [65, 0] }
let g:choosewin_color_other = { 'gui': ['#757575', '#BFBFBF'], 'cterm': [241, 249] }
let g:choosewin_color_overlay_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
let g:choosewin_color_overlay = { 'gui': ['#007173', '#DEDFBD'], 'cterm': [23, 187, 'bold'] }
nmap + <Plug>(choosewin)
nmap <Leader>= <Plug>(choosewin)
" }}}

" Unite {{{
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite-session'
Plug 'tsukkee/unite-tag'
Plug 'blindFS/unite-workflow'
Plug 'kmnk/vim-unite-giti'
Plug 'Shougo/vinarise.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/unite-help'
Plug 'thinca/vim-unite-history'
Plug 'hewes/unite-gtags'
Plug 'osyo-manga/unite-quickfix'

let g:unite_source_history_yank_enable = 1
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite -buffer-name=files buffer bookmark file<CR>
if has("nvim")
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>/ :Unite grep:.<CR>
nnoremap <Space>y :Unite history/yank<CR>
nnoremap <Space>S :Unite source<CR>
nnoremap <Space>m :Unite file_mru<CR>
nnoremap <Space>M :Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <Space>o :Unite outline<CR>
nnoremap <Space>a :execute 'Unite anzu:' . input ('anzu: ')<CR>
nnoremap <Space>ua :Unite apropos -start-insert<CR>
nnoremap <Space>ub :UniteWithBufferDir -buffer-name=files -prompt=%\  buffer bookmark file<CR>
nnoremap <Space>uc :UniteWithCurrentDir -buffer-name=files buffer bookmark file<CR>
nnoremap <Space>uC :Unite change<CR>
nnoremap <Space>ud :Unite directory<CR>
nnoremap <Space>uD :UniteWithBufferDir directory<CR>
nnoremap <Space>u<C-d> :execute 'Unite directory:' . input('dir: ')<CR>
nnoremap <Space>uf :Unite function -start-insert<CR>
nnoremap <Space>uh :Unite help<CR>
nnoremap <Space>uH :Unite history/unite<CR>
nnoremap <Space>ugc :Unite gtags/context<CR>
nnoremap <Space>ugd :Unite gtags/def<CR>
nnoremap <Space>ugf :Unite gtags/file<CR>
nnoremap <Space>ugg :Unite gtags/grep<CR>
nnoremap <Space>ugp :Unite gtags/path<CR>
nnoremap <Space>ugr :Unite gtags/ref<CR>
nnoremap <Space>ugx :Unite gtags/completion<CR>
nnoremap <Space>uj :Unite jump -start-insert<CR>
nnoremap <Space>uk :execute 'Unite grep:.::' . <SID>escape_symbol(expand('<cword>')) . ' -wrap'<CR>
nnoremap <Space>uK :execute 'Unite grep:.::' . <SID>escape_symbol(expand('<cWORD>')) . ' -wrap'<CR>
nnoremap <Space>u8 :execute 'Unite grep:.::\\b' . <SID>escape_symbol(expand('<cword>')) . '\\b -wrap'<CR>
nnoremap <Space>u* :execute 'Unite grep:.::\\b' . <SID>escape_symbol(expand('<cWORD>')) . '\\b -wrap'<CR>
xnoremap <Space>uk :<C-u>execute 'Unite grep:.::' . <SID>escape_symbol(<SID>get_visual_selection()) . ' -wrap'<CR>
xnoremap <Space>u8 :<C-u>execute 'Unite grep:.::\\b' . <SID>escape_symbol(<SID>get_visual_selection()) . '\\b -wrap'<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>uL :Unite location_list<CR>
nnoremap <Space>uo :Unite output -start-insert<CR>
nnoremap <Space>uO :Unite outline<CR>
nnoremap <Space>up :UniteWithProjectDir -buffer-name=files -prompt=&\  buffer bookmark file<CR>
nnoremap <Space>uq :Unite quickfix<CR>
nnoremap <Space>ur :Unite -buffer-name=register register<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>ut :Unite tag<CR>
nnoremap <Space>uu :UniteResume<CR>
nnoremap <Space>uU :Unite -buffer-name=resume resume<CR>
nnoremap <Space>uw :Unite window<CR>
nnoremap <Space>uma :Unite mapping<CR>
nnoremap <Space>ume :Unite output:message<CR>
nnoremap <Space>ump :Unite output:map<CR>
nnoremap <Space>u: :Unite history/command<CR>
nnoremap <Space>u; :Unite command<CR>
nnoremap <Space>u/ :Unite history/search<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r><C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-x><C-x>     <Plug>(unite_complete)
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  " Move cursor in insert mode
  imap <buffer> <C-j>     <Plug>(unite_select_next_line)
  imap <buffer> <C-k>     <Plug>(unite_select_previous_line)

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

  " Runs "switch" action by <M-s>.
  imap <silent><buffer><expr> <M-s>     unite#do_action('switch')
  nmap <silent><buffer><expr> <M-s>     unite#do_action('switch')

  " Runs "tabswitch" action by <M-t>.
  imap <silent><buffer><expr> <M-t>     unite#do_action('tabswitch')
  nmap <silent><buffer><expr> <M-t>     unite#do_action('tabswitch')

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
  nmap <silent><buffer><expr> <C-s>     unite#do_action('split')

  " Runs "vsplit" action by <C-v>.
  imap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')

  " Runs "persist_open" action by <C-]>.
  imap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')
  nmap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer> ` <Plug>(unite_toggle_mark_current_candidate)
endfunction "}}}

" Escape colon, backslash and space
function! s:escape_symbol(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>/ :Unite grep:. -wrap<CR>
  nnoremap <Space>g/ :execute "Unite grep:.:-g\\ '" . input('glob: ') . "'"<CR>
endif
" }}}

" Denite {{{
if !s:is_disabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim'

  nnoremap <Space>db :DeniteBufferDir -buffer-name=files buffer file<CR>
  nnoremap <Space>dc :Denite change<CR>
  nnoremap <Space>dd :Denite directory_rec<CR>
  nnoremap <Space>dD :Denite directory_mru<CR>
  nnoremap <Space>dh :Denite help<CR>
  nnoremap <Space>dj :Denite jump<CR>
  nnoremap <Space>di :Denite grep:.::!<CR>
  nnoremap <Space>dk :execute 'Denite grep:.::' . <SID>escape_symbol(expand('<cword>'))<CR>
  nnoremap <Space>dK :execute 'Denite grep:.::' . <SID>escape_symbol(expand('<cWORD>'))<CR>
  nnoremap <Space>d8 :execute 'Denite grep:.::\\b' . <SID>escape_symbol(expand('<cword>')) . '\\b'<CR>
  nnoremap <Space>d* :execute 'Denite grep:.::\\b' . <SID>escape_symbol(expand('<cWORD>')) . '\\b'<CR>
  xnoremap <Space>dk :<C-u>execute 'Denite grep:.::' . <SID>escape_symbol(<SID>get_visual_selection())<CR>
  xnoremap <Space>d8 :<C-u>execute 'Denite grep:.::\\b' . <SID>escape_symbol(<SID>get_visual_selection()) . '\\b'<CR>
  nnoremap <Space>dl :Denite line<CR>
  nnoremap <Space>dm :Denite file_mru<CR>
  nnoremap <Space>do :execute 'Denite output:' . input('output: ')<CR>
  nnoremap <Space>dO :Denite outline<CR>
  nnoremap <Space>dp :Denite -buffer-name=files buffer file<CR>
  nnoremap <Space>dP :Denite -buffer-name=files file_rec<CR>
  nnoremap <Space>d<C-p> :DeniteProjectDir -buffer-name=files buffer file<CR>
  nnoremap <Space>dr :Denite register<CR>
  nnoremap <Space>dt :Denite tag<CR>
  nnoremap <Space>du :Denite -resume -refresh<CR>
  nnoremap <Space>d: :Denite command_history<CR>
  nnoremap <Space>d; :Denite command<CR>
  nnoremap <Space>d/ :Denite grep:.<CR>

  if executable('rg')
    nnoremap <Space>dg/ :execute "Denite grep:.:-g\\ '" . input('glob: ') . "'"<CR>
  endif
endif
" }}}

" Ack {{{
Plug 'mileszs/ack.vim', { 'on': ['Ack', 'AckFile'] }
" }}}

" gj {{{
Plug 'fcamel/gj', { 'on': 'Gj' }

nnoremap <Leader>gj :Gj! <C-R>=expand("<cword>")<CR>
" }}}

" vim-grepper {{{
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<Plug>(GrepperOperator)'] }

nnoremap <Leader>gg :Grepper -tool git<CR>
nnoremap <Leader>ga :Grepper -tool ag<CR>
nnoremap gss        :Grepper -tool rg<CR>

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
Plug 'dyng/ctrlsf.vim', { 'on': 'CtrlSF' }

nnoremap <Space><C-f> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
nnoremap <F5> :CtrlSFToggle<CR>
" }}}

" ranger.vim {{{
Plug 'rbgrouleff/bclose.vim'
Plug 'francoiscabrol/ranger.vim', { 'on': 'Ranger' }

let g:ranger_map_keys = 0
nnoremap <Space>rr :Ranger<CR>
nnoremap <Space>rs :split     <Bar> Ranger<CR>
nnoremap <Space>rv :vsplit    <Bar> Ranger<CR>
nnoremap <Space>rt :tab split <Bar> Ranger<CR>
" }}}

" fzf {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cclose
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Mapping selecting mappings
nmap <Space><Tab> <Plug>(fzf-maps-n)
imap <M-`> <Plug>(fzf-maps-i)
xmap <Space><Tab> <Plug>(fzf-maps-x)
omap <Space><Tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)
inoremap <expr> <C-x><C-d> fzf#vim#complete#path('fd -t d')

command! -bar -bang Helptags call fzf#vim#helptags(<bang>0)
command! -bang -nargs=+ -complete=dir LLocate call fzf#vim#locate(<q-args>, <bang>0)

" let g:rg_command = '
"     \ rg --column --line-number --no-heading --ignore-case --no-ignore --hidden --follow --color "always"
"     \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,lua,pm,vim,sh,h,hpp}"
"     \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '
let g:rg_command = 'rg --column --line-number --no-heading --smart-case --color=always '
let g:rg_all_command = 'rg --column --line-number --no-heading --smart-case --no-ignore --hidden --follow --color=always '
command! -bang -nargs=* Rg call fzf#vim#grep(
      \ <bang>0 ? g:rg_all_command.shellescape(<q-args>)
      \         : g:rg_command.shellescape(<q-args>), 1,
      \ <bang>0 ? fzf#vim#with_preview('up:60%')
      \         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0)
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

function! s:tselect_sink(line)
  let list = matchlist(a:line, '^\%(\s\+\S\+\)\{4}\s\+\(\S\+\)') " # pri kind tag file
  call execute("edit " . list[1])
endfunction

function! s:get_tselect(query)
  return split(execute("tselect " . a:query, "silent!"), "\n")
endfunction
command! -nargs=1 Tselect call fzf#run(fzf#wrap({
      \ 'source': s:get_tselect(<q-args>),
      \ 'sink':   function('s:tselect_sink'),
      \ 'option': '-m -x +s',
      \ 'down':   '40%'}))
" TODO Add expect keys
" TODO Add Jumps command preview
function! s:jump_sink(line)
  let list = matchlist(a:line, '^\s\+\S\+\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(.*\)') " jump line col file/text
  if list[3] !~ '\s'
    call execute("edit " . list[3])
  endif
  call cursor(list[1], list[2])
endfunction

function! s:jumps()
  return split(execute("jumps", "silent!"), "\n")
endfunction
command! Jump call fzf#run(fzf#wrap({
      \ 'source': s:jumps(),
      \ 'sink':   function('s:jump_sink'),
      \ 'option': '-m -x +s',
      \ 'down':   '40%'}))

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

nnoremap <Space>fa :execute 'Ag ' . input('Ag: ')<CR>
nnoremap <Space>fb :Buffers<CR>
nnoremap <Space>fB :Files %:h<CR>
nnoremap <Space>fc :BCommits<CR>
nnoremap <Space>fC :Commits<CR>
nnoremap <Space>fd :execute 'Tags ' . expand('<cword>')<CR>
nnoremap <Space>ff :Files<CR>
nnoremap <Space>fg :GFiles<CR>
nnoremap <Space>fG :execute 'GGrep ' . input('Git grep: ')<CR>
nnoremap <Space>fh :Helptags<CR>
nnoremap <Space>fH :History<CR>
nnoremap <Space>fj :Jump<CR>
nnoremap <Space>fk :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <Space>fK :execute 'Rg ' . expand('<cWORD>')<CR>
nnoremap <Space>f8 :execute 'Rg \b' . expand('<cword>') . '\b'<CR>
nnoremap <Space>f* :execute 'Rg \b' . expand('<cWORD>') . '\b'<CR>
xnoremap <Space>fk :<C-u>execute 'Rg ' . <SID>get_visual_selection()<CR>
xnoremap <Space>f8 :<C-u>execute 'Rg \b' . <SID>get_visual_selection() . '\b'<CR>
nnoremap <Space>fl :BLines<CR>
nnoremap <Space>fL :Lines<CR>
nnoremap <Space>f<C-l> :execute 'BLines ' . expand('<cword>')<CR>
nnoremap <Space>fm :Mru<CR>
nnoremap <Space>fM :Maps<CR>
nnoremap <Space>fo :execute 'LLocate ' . input('Locate: ')<CR>
nnoremap <Space>fr :execute 'Rg ' . input('Rg: ')<CR>
nnoremap <Space>fR :execute 'Rg! ' . input('Rg!: ')<CR>
nnoremap <Space>fs :GFiles?<CR>
nnoremap <Space>ft :BTags<CR>
nnoremap <Space>fT :Tags<CR>
nnoremap <Space>fw :Windows<CR>
nnoremap <Space>fy :Filetypes<CR>
nnoremap <Space>f` :Marks<CR>
nnoremap <Space>f: :History:<CR>
xnoremap <Space>f: :<C-u>History:<CR>
nnoremap <Space>f; :Commands<CR>
xnoremap <Space>f; :<C-u>Commands<CR>
nnoremap <Space>f/ :History/<CR>
nnoremap <Space>f] :execute 'Tags ' . expand('<cword>')<CR>
nnoremap <Space>f} :execute 'Tselect ' . expand('<cword>')<CR>

nnoremap <Space>ss :History:<CR>mks vim sessions 

if has("nvim")
  function! s:fzf_statusline()
    highlight fzf1 ctermfg=242 ctermbg=236
    highlight fzf2 ctermfg=143
    highlight fzf3 ctermfg=15 ctermbg=239
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fzf%#fzf3#
  endfunction
  autocmd! User FzfStatusLine call <SID>fzf_statusline()

  function! s:project_tags()
    let s:origin_tags = &tags
    set tags-=./tags;
    augroup project_tags_callback
      autocmd!
      autocmd TermClose term://*fzf*
            \ let &tags = s:origin_tags |
            \ autocmd! project_tags_callback
    augroup END
    Tags
  endfunction
  nnoremap <Space>fp :call <SID>project_tags()<CR>
endif
" }}}

" vifm {{{
Plug 'vifm/vifm.vim'
" }}}

Plug 'vim-scripts/a.vim', { 'on': 'A' }
Plug 'brooth/far.vim', { 'on': ['Far', 'Farp', 'F'] }
if has('job') || (has('nvim') && exists('*jobwait'))
  Plug 'ludovicchabant/vim-gutentags'
endif
" }}}

" Text Navigation {{{
" ====================================================================
" matchit {{{
runtime macros/matchit.vim
" }}}

" EasyMotion {{{
Plug 'easymotion/vim-easymotion'

let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ; <Plug>(easymotion-s2)

map \w <Plug>(easymotion-bd-wl)
map \f <Plug>(easymotion-bd-fl)

map <Leader>f <Plug>(easymotion-bd-f)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)L <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

nmap <Leader>; <Plug>(easymotion-next)
nmap <Leader>, <Plug>(easymotion-prev)
nmap <Leader>. <Plug>(easymotion-repeat)

map <Plug>(easymotion-prefix)J <Plug>(easymotion-eol-j)
map <Plug>(easymotion-prefix)K <Plug>(easymotion-eol-k)

map <Plug>(easymotion-prefix); <Plug>(easymotion-jumptoanywhere)

" overwin is slow, disabled
" if s:os !~ "synology"
"   nmap <Leader>f <Plug>(easymotion-overwin-f)
"   nmap <Plug>(easymotion-prefix)s <Plug>(easymotion-overwin-f2)
"   nmap <Plug>(easymotion-prefix)L <Plug>(easymotion-overwin-line)
"   nmap <Plug>(easymotion-prefix)w <Plug>(easymotion-overwin-w)
" endif
" }}}

" vim-asterisk {{{
Plug 'haya14busa/vim-asterisk'

map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
map z*  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
map z#  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)
" }}}

" vim-anzu {{{
Plug 'osyo-manga/vim-anzu'

map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

command! AnzuToggleUpdate let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
function! s:AnzuToggleUpdate()
  let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus
        \ = get(g:, 'anzu_enable_CursorHold_AnzuUpdateSearchStatus', 2)
  if g:anzu_enable_CursorHold_AnzuUpdateSearchStatus == 0
    g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2
  else
    g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
  endif
endfunction

augroup anzuDisableUpdateOnLargeFile
  autocmd!

  " Disabled on file larger than 10MB
  autocmd BufWinEnter,WinEnter *
        \ if getfsize(expand(@%)) > 10 * 1024 * 1024 |
        \   let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0 |
        \ else |
        \   let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2 |
        \ endif
augroup END
" }}}

" incsearch {{{
Plug 'haya14busa/incsearch.vim'

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1

" Replace by vim-anzu
"map n  <Plug>(incsearch-nohl-n)
"map N  <Plug>(incsearch-nohl-N)

" Replace by vim-asterisk
"map *  <Plug>(incsearch-nohl-*)
"map #  <Plug>(incsearch-nohl-#)
"map g* <Plug>(incsearch-nohl-g*)
"map g# <Plug>(incsearch-nohl-g#)

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Search within visual selection
xmap <M-/> <Esc><Plug>(incsearch-forward)\%V
xmap <M-?> <Esc><Plug>(incsearch-backward)\%V
" }}}

" incsearch-fuzzy {{{
Plug 'haya14busa/incsearch-fuzzy.vim'

map z/  <Plug>(incsearch-fuzzy-/)
map z?  <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)
" }}}

" incsearch-easymotion {{{
Plug 'haya14busa/incsearch-easymotion.vim'

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

noremap <silent><expr> \/ incsearch#go(<SID>config_easyfuzzymotion())
" }}}

" CamelCaseMotion {{{
Plug 'bkad/CamelCaseMotion'

map <Leader>mw <Plug>CamelCaseMotion_w
map <Leader>mb <Plug>CamelCaseMotion_b
map <Leader>me <Plug>CamelCaseMotion_e
map <Leader>mge <Plug>CamelCaseMotion_ge
" }}}

" clever-f.vim {{{
Plug 'rhysd/clever-f.vim'

let g:clever_f_smart_case = 1
" }}}

Plug 'wellle/targets.vim'
" }}}

" Text Manipulation {{{
" ====================================================================
" EasyAlign {{{
Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

xmap <Space>ga <Plug>(LiveEasyAlign)
" }}}

" auto-pairs {{{
Plug 'jiangmiao/auto-pairs'

let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
" let g:AutoPairsMapCR = 0

augroup autoPairsFileTypeSpecific
  autocmd!

  autocmd Filetype xml let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<': '>'}
augroup END
" }}}

" eraseSubword {{{
Plug 'vim-scripts/eraseSubword'

let g:EraseSubword_insertMap = '<C-b>'
" }}}

" tcomment_vim {{{
Plug 'tomtom/tcomment_vim'
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" }}}

" Text Objects {{{
" ====================================================================
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function'
Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
" }}}

" Languages {{{
" ====================================================================
" emmet {{{
Plug 'mattn/emmet-vim'

let g:user_emmet_leader_key = '<C-e>'
" }}}

" cscope-macros.vim {{{
Plug 'vim-scripts/cscope_macros.vim'

nnoremap <F11> :call <SID>generate_cscope_files()<CR>
function! s:generate_cscope_files()
  !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
  !cscope -b -i cscope.files -f cscope.out<CR>
  cscope kill -1<CR>
  cscope add cscope.out<CR>
endfunction
" }}}

" vim-seeing-is-believing {{{
Plug 'hwartig/vim-seeing-is-believing', { 'for': 'ruby' }

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
if !s:is_disabled_plugin('syntastic')
  Plug 'vim-syntastic/syntastic'

  " Automatically setup by airline
  "set statusline+=%#warningmsg#
  "set statusline+=%{SyntasticStatuslineFlag()}
  "set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list            = 2
  let g:syntastic_check_on_open            = 1
  let g:syntastic_check_on_wq              = 0

  let g:syntastic_ruby_checkers = ['mri', 'rubylint']
  let g:syntastic_tex_checkers  = ['lacheck']
  let g:syntastic_c_checkers    = ['gcc']
  let g:syntastic_cpp_checkers  = ['gcc']

  let g:syntastic_ignore_files = ['\m^/usr/include/', '\m^/synosrc/packages/build_env/', '\m\c\.h$']
  nnoremap <Space><F8> :SyntasticCheck<CR>
  command! -bar SyntasticCheckHeader call <SID>SyntasticCheckHeader()
  function! s:SyntasticCheckHeader()
    let header_pattern_index = index(g:syntastic_ignore_files, '\m\c\.h$')
    if header_pattern_index >= 0
      call remove(g:syntastic_ignore_files, header_pattern_index)
    endif

    let g:syntastic_c_check_header = 1
    let g:syntastic_cpp_check_header = 1
    SyntasticCheck
  endfunction
end
" }}}

" ale {{{
if !s:is_disabled_plugin('ale')
  Plug 'w0rp/ale'

  let g:ale_linters = {
        \ 'c': ['gcc'],
        \ 'cpp': ['g++']
        \}

  nmap ]a <Plug>(ale_next_wrap)
  nmap [a <Plug>(ale_previous_wrap)
end
" }}}

Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'moll/vim-node', { 'for': [] }
Plug 'tpope/vim-rails', { 'for': [] }
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/vim-slumlord'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'hotchpotch/perldoc-vim'
" }}}

" Git {{{
" ====================================================================
" vim-fugitive {{{
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }

nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>ge :Gedit<CR>
nnoremap <silent> <Leader>gE :Gedit<space>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gL :Glog -- %<CR>
nnoremap <silent> <Leader>gr :Gread<CR>
nnoremap <silent> <Leader>gR :Gread<space>
nnoremap <silent> <Leader>gw :Gwrite<CR>
nnoremap <silent> <Leader>gW :Gwrite!<CR>
nnoremap <silent> <Leader>gq :Gwq<CR>
nnoremap <silent> <Leader>gQ :Gwq!<CR>
nnoremap <silent> <Leader>gm :Merginal<CR>

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

let g:fugitive_gitlab_domains = ['https://git.synology.com']
" }}}

" vim-gitgutter {{{
Plug 'airblade/vim-gitgutter'

nmap <silent> [h <Plug>GitGutterPrevHunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gt :GitGutterAll<CR>

omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

command! GVA GV --all

function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <SID>gv_expand()<CR>
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }
" }}}

" Gina {{{
Plug 'lambdalisue/gina.vim'

nnoremap <Space>gb :Gina blame<CR>
xnoremap <Space>gb :Gina blame<CR>
" }}}

Plug 'mattn/gist-vim'
" }}}

" Utility {{{
" ====================================================================
" Gundo {{{
if has('python3')
  Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
  autocmd! User gundo.vim let g:gundo_prefer_python3 = 1

  nnoremap <F9> :GundoToggle<CR>
endif
" }}}

" vim-unimpaired {{{
Plug 'tpope/vim-unimpaired'

nnoremap coe :set expandtab!<CR>
nnoremap cop :set paste!<CR>
" }}}

" vim-characterize {{{
Plug 'tpope/vim-characterize'

nmap gA <Plug>(characterize)
" }}}

" vim-peekaboo {{{
Plug 'junegunn/vim-peekaboo'

let g:peekaboo_delay = 400
" }}}

" colorv {{{
Plug 'Rykka/colorv.vim', { 'on': ['ColorV', 'ColorVName'] }

nnoremap <silent> <Leader>cN :ColorVName<CR>
" }}}

" VimShell {{{
Plug 'Shougo/vimshell.vim', { 'on': ['VimShell', 'VimShellCurrentDir', 'VimShellBufferDir', 'VimShellTab'] }

nnoremap <silent> <Leader>vv :VimShell<CR>
nnoremap <silent> <Leader>vc :VimShellCurrentDir<CR>
nnoremap <silent> <Leader>vb :VimShellBufferDir<CR>
nnoremap <silent> <Leader>vt :VimShellTab<CR>
" }}}

" deol.nvim {{{
if has("nvim")
  Plug 'Shougo/deol.nvim'
endif
" }}}

" vim-rooter {{{
Plug 'airblade/vim-rooter', { 'on': 'Rooter' }

let g:rooter_manual_only = 1
let g:rooter_use_lcd = 1
nnoremap <Leader>r :Rooter<CR>
" }}}

" vimwiki {{{
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

nnoremap <Leader>wg :VimwikiToggleListItem<CR>
" }}}

" orgmode {{{
Plug 'jceb/vim-orgmode'
" }}}

" vimoutliner {{{
Plug 'vimoutliner/vimoutliner'
" }}}

" AnsiEsc.vim {{{
Plug 'powerman/vim-plugin-AnsiEsc', { 'on': 'AnsiEsc' }

nnoremap coa :AnsiEsc<CR>
" }}}

" vim-lastplace {{{
Plug 'farmergreg/vim-lastplace'

let g:lastplace_ignore = "gitcommit,gitrebase,sv,hgcommit"
let g:lastplace_ignore_buftype = "quickfix,nofile,help"
let g:lastplace_open_folds = 0
" }}}

" neoterm {{{
if has("nvim")
  Plug 'kassio/neoterm'

  let g:neoterm_default_mod = 'botright'
  let g:neoterm_automap_keys = ',T'

  nnoremap <silent> <Space>` :execute 'T ' . input("Terminal: ")<CR>
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
endif
" }}}

" vim-localvimrc {{{
Plug 'embear/vim-localvimrc'

let g:localvimrc_whitelist = ['/synosrc/[^/]*/source/.*']
" }}}

Plug 'tpope/vim-dadbod'
Plug 'tyru/open-browser.vim'
Plug 'tpope/vim-abolish'
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'AndrewRadev/linediff.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'alx741/vinfo', { 'on': 'Vinfo' }
Plug 'mattn/webapi-vim'
Plug 'tpope/vim-scriptease'
Plug 'kana/vim-arpeggio'
Plug 'kopischke/vim-fetch'
Plug 'Valloric/ListToggle'
Plug 'tpope/vim-eunuch'
Plug 'DougBeney/pickachu', { 'on': 'Pick' }
" }}}

" Plugin Settings End {{{
" vim-plug
call plug#end()
" }}}

" Post-loaded Plugin Settings {{{
" Deoplete {{{
if !s:is_disabled_plugin('deoplete.nvim')
  " call deoplete#custom#option('auto_complete_delay', 200)
endif
" }}}

" Denite {{{
if !s:is_disabled_plugin('denite.nvim')
  " Change mappings
  " Insert mode
  call denite#custom#map(
        \ 'insert',
        \ '<A-g>',
        \ '<denite:toggle_matchers:matcher_substring>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-r>',
        \ '<denite:change_sorters:sorter_reverse>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-y>',
        \ '<denite:input_command_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-j>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-k>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-t>',
        \ '<denite:do_action:tabopen>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-s>',
        \ '<denite:do_action:split>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-v>',
        \ '<denite:do_action:vsplit>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-p>',
        \ '<denite:do_action:preview>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-j>',
        \ '<denite:scroll_page_forwards>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-k>',
        \ '<denite:scroll_page_backwards>',
        \ 'noremap'
        \)

  " Normal mode
  call denite#custom#map(
        \ 'normal',
        \ 'r',
        \ '<denite:do_action:quickfix>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-s>',
        \ '<denite:do_action:switch>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-s>',
        \ '<denite:do_action:switch>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-t>',
        \ '<denite:do_action:tabswitch>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-t>',
        \ '<denite:do_action:tabswitch>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<C-s>',
        \ '<denite:do_action:split>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<C-v>',
        \ '<denite:do_action:vsplit>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-h>',
        \ '<denite:wincmd:h>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-j>',
        \ '<denite:wincmd:j>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-k>',
        \ '<denite:wincmd:k>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<A-l>',
        \ '<denite:wincmd:l>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<C-n>',
        \ '<denite:jump_to_next_source>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '<C-p>',
        \ '<denite:jump_to_previous_source>',
        \ 'noremap'
        \)

  if executable('rg')
    call denite#custom#var('file_rec', 'command',
          \ ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--no-heading'])
  elseif executable('ag')
    call denite#custome#var('file_rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  endif

  if has('nvim')
    call denite#custom#source('file_rec,grep', 'matchers',
          \ ['matcher_cpsm'])
  end
endif
" }}}

" Gina {{{
  call gina#custom#mapping#nmap(
          \ '/\%(blame\|commit\|status\|branch\|ls\|grep\|changes\|tag\)',
          \ 'q', ':<C-u> q<CR>', {'noremap': 1, 'silent': 1},
          \)
" }}}

" Arpeggio {{{
call arpeggio#load()
" }}}
" }}}

" General Settings {{{
" ====================================================================

" Vim basic setting {{{
set nocompatible
if exists(":packadd") != 0
  source $VIMRUNTIME/vimrc_example.vim
endif

" source mswin.vim
if s:os !~ "synology"
  source $VIMRUNTIME/mswin.vim
  behave mswin

  if s:os !~ "windows"
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

set number
set hidden
set lazyredraw
set mouse=a
set modeline
set updatetime=100

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
if !has("nvim") " neovim has default folders for these files
  set directory^=~/.vimtmp
  if v:version >= 703
    set undodir^=~/.vimtmp
    set undofile " enable persistent-undo
  endif
endif

" session options
set sessionoptions+=localoptions
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank

" filetype
filetype on
filetype plugin on
filetype indent on

" misc
set shellslash
" set appropriate grep programs
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
else
  set grepprg=grep\ -nH\ $*
endif
set t_Co=256
set foldlevelstart=99

" Complete
set dictionary=/usr/share/dict/words

" }}}

" Indention {{{
" ====================================================================
set smarttab
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" Use cop instead
" set pastetoggle=<F10>
" }}}

" Search {{{
" ====================================================================
set hlsearch
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
if !exists("g:gui_oni")
  colorscheme seoul256
endif
" }}}

" Key Mappings {{{
" ====================================================================
" Quickly escape insert mode
Arpeggio inoremap jk <Esc>

" Add key mapping for suspend
nnoremap <Space><C-z> :suspend<CR>

" Quickly switch window {{{
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l

" Move in insert mode
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>
" }}}

" Saner command-line history {{{
cnoremap <M-n> <Down>
cnoremap <M-p> <Up>
" }}}

" Tab key mapping {{{
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

nnoremap QQ :call <SID>QuitTab()<CR>
nnoremap gl :tablast<CR>
function! s:QuitTab()
  try
    tabclose
  catch /E784/ " Can't close last tab
    qall
  endtry
endfunction
" }}}

" Quickly adjust window size
nnoremap <C-w><Space>- <C-w>10-
nnoremap <C-w><Space>+ <C-w>10+
nnoremap <C-w><Space>< <C-w>10<
nnoremap <C-w><Space>> <C-w>10>

" Create new line in insert mode {{{
inoremap <M-o> <C-o>o
inoremap <M-S-o> <C-o>O
" }}}

" Save
nnoremap <C-s> :update<CR>

" Quit
nnoremap <Space>q :q<CR>
nnoremap <Space>Q :qa!<CR>

" Win32
"nnoremap <Leader>x :execute ':! "'.expand('%').'"'<CR>
nnoremap <Leader>x :!start cmd /c "%:p"<CR>
nnoremap <Leader>X :!start cmd /K cd /D %:p:h<CR>
nnoremap <Leader>E :execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'<CR>

" Easier file status
nnoremap <Space><C-g> 2<C-g>

" Move working directory up
nnoremap <Leader>u :cd ..<CR>

" Move working directory to current buffer's parent folder
nnoremap <Leader>cb :cd %:h<CR>

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
function! s:last_tab()
  execute "tabn " . g:last_tab
endfunction
nnoremap <M-1> :call <SID>last_tab()<CR>

command! -bar LastTab call <SID>last_tab()
au TabLeave * let g:last_tab = tabpagenr()

" Zoom
function! s:zoom()
  if winnr('$') > 1
    tab split
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
  endif
endfunction
nnoremap <silent> <Leader>z :call <SID>zoom()<CR>
vnoremap <silent> <Leader>z y:tabnew<CR>pkdd

" toggle parent folder tag
function! s:toggle_parent_folder_tag()
  let s:parent_folder_tag_pattern = "./tags;"
  if index(split(&tags, ','), s:parent_folder_tag_pattern) != -1
    execute 'set tags-=' . s:parent_folder_tag_pattern
  else
    execute 'set tags+=' . s:parent_folder_tag_pattern
  endif
endfunction
nnoremap <silent> <Leader>p :call <SID>toggle_parent_folder_tag()<CR>
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
nnoremap <Leader>D :Bdi<CR>

function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()
"autocmd BufWritePre * :call TrimWhitespace()

function! s:getchar() abort
  redraw | echo 'Press any key: '
  let c = getchar()
  while c ==# "\<CursorHold>"
    redraw | echo 'Press any key: '
    let c = getchar()
  endwhile
  redraw | echomsg printf('Raw: "%s" | Char: "%s"', c, nr2char(c))
endfunction
command! GetChar call s:getchar()

if s:os !~ "windows"
  command! Args echo system("ps -o command= -p " . getpid())
endif
" }}}
" }}}

" Terminal {{{
" ====================================================================
" xterm-256 in Windows {{{
if !has("nvim") && !has("gui_running") && s:os =~ "windows"
  set term=xterm
  set mouse=a
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  colorscheme seoul256
endif
" }}}

" Pair up with 'set winaltkeys=no' in _gvimrc
" Fix meta key in vim
" terminal meta key fix {{{
if !has("nvim") && !has("gui_running") && s:os !~ "windows"
  set <M-h>=h |
  set <M-j>=j |
  set <M-k>=k |
  set <M-l>=l |
  set <M-o>=o |
  set <M-p>=p |
  set <M-n>=n |
  set <M-/>=/ |
  set <M-?>=? |
  set <M-1>=1 |
  set <M-S-o>=O
endif
" }}}

" neovim terminal key mapping and settings
if has("nvim")
  " Set terminal buffer size to unlimited
  set scrollback=-1

  " For quick terminal access
  nnoremap <silent> <Leader>tr :terminal<CR>i
  nnoremap <silent> <Leader>tt :tabnew<CR>:terminal<CR>i
  nnoremap <silent> <Leader>ts :new<CR>:terminal<CR>i
  nnoremap <silent> <Leader>tv :vnew<CR>:terminal<CR>i

  tnoremap <M-F1> <C-\><C-n>
  tnoremap <M-F2> <C-\><C-n>:tabnew<CR>:terminal<CR>i
  tnoremap \\q <C-\><C-n>

  " Quickly switch window in terminal
  tnoremap <M-S-h> <C-\><C-n><C-w>h
  tnoremap <M-S-j> <C-\><C-n><C-w>j
  tnoremap <M-S-k> <C-\><C-n><C-w>k
  tnoremap <M-S-l> <C-\><C-n><C-w>l

  " Quickly switch tab in terminal
  tnoremap <M-C-j> <C-\><C-n>gT
  tnoremap <M-C-k> <C-\><C-n>gt

  " Quickly switch to last tab in terminal
  tnoremap <M-1> <C-\><C-n>:call <SID>last_tab()<CR>

  " Quickly paste from register
  tnoremap <expr> <M-r> '<C-\><C-n>"' . nr2char(getchar()) . 'pi'
endif
" }}}

" Autocommands {{{
" ====================================================================
augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost _vimrc nested source $MYVIMRC | normal! zzzv
  autocmd BufWritePost .vimrc nested source $MYVIMRC | normal! zzzv
augroup END

augroup fileTypeSpecific
  autocmd!

  " Rack
  autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby

  " gdb
  autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb

  " gitcommit
  autocmd FileType gitcommit setlocal spell complete+=k

  " Custom filetype
  autocmd BufNewFile,BufReadPost *maillog*            set filetype=messages
  autocmd BufNewFile,BufReadPost *conf                set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override set filetype=conf
  autocmd BufNewFile,BufReadPost */rspamd/*.inc       set filetype=conf
  autocmd BufNewFile,BufReadPost Makefile.inc         set filetype=make
  autocmd BufNewFile,BufReadPost depends              set filetype=dosini
  autocmd BufNewFile,BufReadPost .tmux.conf           set filetype=tmux

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

if s:os =~ "windows" && !has("gui_running") && !has("nvim")
  " Windows Terminal keycode will change after startup
  " Maybe it's related to ConEmu
  " This fix will not work after reload .vimrc/_vimrc
  augroup WindowsTerminalKeyFix
    autocmd!
    autocmd VimEnter *
          \ set <M-h>=h |
          \ set <M-j>=j |
          \ set <M-k>=k |
          \ set <M-l>=l |
          \ set <M-o>=o |
          \ set <M-p>=p |
          \ set <M-n>=n |
          \ set <M-/>=/ |
          \ set <M-?>=? |
          \ set <M-1>=1 |
          \ set <M-S-o>=O
  augroup END
endif

if has("nvim")
  augroup terminalSettings
    autocmd!
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
    " Ignore fzf as fzf will close terminal automatically
    autocmd TermClose term://*
          \ if (bufname('%') !~ "fzf") && (bufname('%') !~ "ranger") |
          \   call nvim_input('<CR>')  |
          \ endif
  augroup END
endif
" }}}

" Fix and Workarounds {{{
" ====================================================================
" Prevent CTRL-F to abort the selection (in visual mode)
" This is caused by $VIM/_vimrc ':behave mswin' which sets 'keymodel' to
" include 'stopsel' which means that non-shifted special keys stop selection.
set keymodel=startsel

" disable Background Color Erase (BC) by clearing the `t_ut` on Synology DSM
" see https://sunaku.github.io/vim-256color-bce.html
if s:os =~ "synology"
  set t_ut=
endif

" Backspace in ConEmu will translate to 0x07F when using xterm
" https://conemu.github.io/en/VimXterm.html
" https://github.com/Maximus5/ConEmu/issues/641
if !empty($ConEmuBuild)
  let &t_kb = nr2char(127)
  let &t_kD = "^[[3~"

  " Disable Background Color Erase
  set t_ut=
endif
" }}}

" vim: set sw=2 ts=2 sts=2 et foldlevel=0 foldmethod=marker:
