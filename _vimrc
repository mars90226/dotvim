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
"if v:version >= 800 || has("nvim")
  "call add(g:pathogen_disabled, 'syntastic')
"else
  call s:disable_plugin('ale')
"end

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

" vim-indent-guides {{{
Plug 'nathanaelkane/vim-indent-guides', { 'on': 'IndentGuidesToggle' }
autocmd! User vim-indent-guides call s:vim_indent_guides_settings()
function! s:vim_indent_guides_settings()
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * highlight IndentGuidesOdd  ctermbg=243
  autocmd VimEnter,Colorscheme * highlight IndentGuidesEven ctermbg=240
endfunction

nnoremap <Leader>ig :IndentGuidesToggle<CR>
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
  "Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'] }
  Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] }
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/neco-syntax'
  Plug 'Shougo/neco-vim'
  Plug 'sebastianmarkow/deoplete-rust', { 'for': ['rust'] }

  let g:deoplete#enable_at_startup = 1

  let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-3.8/lib/libclang.so.1"
  let g:deoplete#sources#clang#clang_header = "/usr/lib/llvm-3.8/lib/clang"
  "let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'

  let g:deoplete#sources#rust#racer_binary = $HOME."/.cargo/bin/racer"
  let g:deoplete#sources#rust#rust_source_path = $HOME."/rust/src"
endif
" }}}

" supertab {{{
if !s:is_disabled_plugin('supertab')
  Plug 'ervandew/supertab'
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
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

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

" tmux-complete.vim {{{
Plug 'wellle/tmux-complete.vim'
" }}}
" }}}

" File Navigation {{{
" ====================================================================
" CtrlP {{{
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }
Plug 'sgur/ctrlp-extensions.vim', { 'on': 'CtrlP' }
Plug 'tacahiroy/ctrlp-funky', { 'on': 'CtrlP' }
Plug 'mattn/ctrlp-hackernews', { 'on': 'CtrlP' }
Plug 'fisadev/vim-ctrlp-cmdpalette', { 'on': 'CtrlP' }

if has("python")
  Plug 'FelikZ/ctrlp-py-matcher', { 'on': 'CtrlP' }

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_cmdpalette_execute = 1

nnoremap <C-p> :CtrlP<CR>
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

  " Fix backspace not work problem
  nmap <silent><buffer>       <C-h>     <Plug>(vimfiler_switch_to_parent_directory)

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

let g:unite_source_history_yank_enable = 1
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite
        \ -buffer-name=files buffer bookmark file<CR>
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
nnoremap <Space>a :execute 'Unite anzu:' . input ('anzu: ')<CR>
nnoremap <Space>ua :Unite apropos -start-insert<CR>
nnoremap <Space>ub :UniteWithBufferDir
        \ -buffer-name=files -prompt=%\  buffer bookmark file<CR>
nnoremap <Space>uc :UniteWithCurrentDir
        \ -buffer-name=files buffer bookmark file<CR>
nnoremap <Space>uC :Unite change<CR>
nnoremap <Space>ud :Unite directory<CR>
nnoremap <Space>uD :UniteWithBufferDir directory<CR>
nnoremap <Space>u<C-d> :execute 'Unite directory:' . input('dir: ')<CR>
nnoremap <Space>uf :Unite function -start-insert<CR>
nnoremap <Space>uh :Unite help<CR>
nnoremap <Space>uj :Unite jump -start-insert<CR>
nnoremap <Space>uk :execute 'Unite grep:.::' . expand('<cword>') . ' -wrap'<CR>
nnoremap <Space>uK :execute 'Unite grep:.::' . expand('<cWORD>') . ' -wrap'<CR>
nnoremap <Space>u8 :execute 'Unite grep:.::\\b' . expand('<cword>') . '\\b -wrap'<CR>
nnoremap <Space>u* :execute 'Unite grep:.::\\b' . expand('<cWORD>') . '\\b -wrap'<CR>
vnoremap <Space>uk :<C-u>execute 'Unite grep:.::' . <SID>escape_colon_and_backslash(<SID>get_visual_selection()) . ' -wrap'<CR>
vnoremap <Space>u8 :<C-u>execute 'Unite grep:.::\\b' . <SID>escape_colon_and_backslash(<SID>get_visual_selection()) . '\\b -wrap'<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>uo :Unite outline<CR>
nnoremap <Space>uO :Unite output -start-insert<CR>
nnoremap <Space>up :UniteWithProjectDir
        \ -buffer-name=files -prompt=&\  buffer bookmark file<CR>
nnoremap <Space>ur :Unite
        \ -buffer-name=register register<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>uu :UniteResume<CR>
nnoremap <Space>uU :Unite
        \ -buffer-name=resume resume<CR>
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
  imap <buffer> <C-y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-y>     <Plug>(unite_input_directory)
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

  " Runs "persist_open" action by P.
  imap <silent><buffer><expr> P         unite#do_action('persist_open')
  nmap <silent><buffer><expr> P         unite#do_action('persist_open')

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer> ` <Plug>(unite_toggle_mark_current_candidate)
endfunction "}}}

function! s:escape_colon_and_backslash(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')

  return l:expr
endfunction

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>/ :Unite grep:. -wrap<CR>
endif
" }}}

" Denite {{{
if !s:is_disabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim'

  nnoremap <Space>db :DeniteBufferDir -buffer-name=files buffer file<CR>
  nnoremap <Space>dc :Denite change<CR>
  nnoremap <Space>dd :Denite directory_rec<CR>
  nnoremap <Space>dD :Denite directory_mru<CR>
  nnoremap <Space>dj :Denite jump<CR>
  nnoremap <Space>dk :execute 'Denite grep:.::' . expand('<cword>')<CR>
  nnoremap <Space>dK :execute 'Denite grep:.::' . expand('<cWORD>')<CR>
  nnoremap <Space>d8 :execute 'Denite grep:.::\\b' . expand('<cword>') . '\\b'<CR>
  nnoremap <Space>d* :execute 'Denite grep:.::\\b' . expand('<cWORD>') . '\\b'<CR>
  vnoremap <Space>dk :<C-u>execute 'Denite grep:.::' . <SID>escape_colon_and_backslash(<SID>get_visual_selection())<CR>
  vnoremap <Space>d8 :<C-u>execute 'Denite grep:.::\\b' . <SID>escape_colon_and_backslash(<SID>get_visual_selection()) . '\\b'<CR>
  nnoremap <Space>dl :Denite line<CR>
  nnoremap <Space>dm :Denite file_mru<CR>
  nnoremap <Space>do :Denite outline<CR>
  nnoremap <Space>dO :execute 'Denite output:' . input('output: ')<CR>
  nnoremap <Space>dp :Denite -buffer-name=files buffer file<CR>
  nnoremap <Space>dP :Denite -buffer-name=files file_rec<CR>
  nnoremap <Space>d<C-p> :DeniteProjectDir -buffer-name=files buffer file<CR>
  nnoremap <Space>dr :Denite register<CR>
  nnoremap <Space>du :Denite -resume -refresh<CR>
  nnoremap <Space>d: :Denite command_history<CR>
  nnoremap <Space>d; :Denite command<CR>
  nnoremap <Space>d/ :Denite grep:.<CR>
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

" Mapping selecting mappings
nmap <Leader><Tab> <Plug>(fzf-maps-n)
imap <Leader><Tab> <Plug>(fzf-maps-i)
xmap <Leader><Tab> <Plug>(fzf-maps-x)
omap <Leader><Tab> <Plug>(fzf-maps-o)

" Insert mode completion
imap <C-x><C-k> <Plug>(fzf-complete-word)
imap <C-x><C-f> <Plug>(fzf-complete-path)
imap <C-x><C-j> <Plug>(fzf-complete-file-ag)
imap <C-x><C-l> <Plug>(fzf-complete-line)
inoremap <expr> <C-x><C-d> fzf#vim#complete#path('fd -t d')

command! -bar -bang Helptags call fzf#vim#helptags(<bang>0)
command! -bang -nargs=+ -complete=dir LLocate call fzf#vim#locate(<q-args>, <bang>0)

let g:rg_command = '
    \ rg --column --line-number --no-heading --ignore-case --no-ignore --hidden --follow --color "always"
    \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,lua,pm,vim,sh}"
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

nnoremap <Leader>fa :execute 'Ag ' . input('Ag: ')<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fc :BCommits<CR>
nnoremap <Leader>fC :Commits<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fF :Filetypes<CR>
nnoremap <Leader>fg :GFiles<CR>
nnoremap <Leader>fG :execute 'GGrep ' . input('Git grep: ')<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fH :Helptags<CR>
nnoremap <Leader>fk :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <Leader>fK :execute 'Rg ' . expand('<cWORD>')<CR>
nnoremap <Leader>f8 :execute 'Rg \b' . expand('<cword>') . '\b'<CR>
nnoremap <Leader>f* :execute 'Rg \b' . expand('<cWORD>') . '\b'<CR>
vnoremap <Leader>fk :<C-u>execute 'Rg ' . <SID>get_visual_selection()<CR>
vnoremap <Leader>f8 :<C-u>execute 'Rg \b' . <SID>get_visual_selection() . '\b'<CR>
nnoremap <Leader>fl :BLines<CR>
nnoremap <Leader>fL :Lines<CR>
nnoremap <Leader>fm :Mru<CR>
nnoremap <Leader>fM :Maps<CR>
nnoremap <Leader>fo :execute 'LLocate ' . input('Locate: ')<CR>
nnoremap <Leader>fr :execute 'Rg ' . input('Rg: ')<CR>
nnoremap <Leader>ft :BTags<CR>
nnoremap <Leader>fT :Tags<CR>
nnoremap <Leader>fw :Windows<CR>
nnoremap <Leader>f` :Marks<CR>
nnoremap <Leader>f: :History:<CR>
vnoremap <Leader>f: :<C-u>History:<CR>
nnoremap <Leader>f; :Commands<CR>
vnoremap <Leader>f; :<C-u>Commands<CR>
nnoremap <Leader>f/ :History/<CR>
nnoremap <Leader>f] :execute 'Tags ' . expand('<cword>')<CR>

if has("nvim")
  function! s:fzf_statusline()
    highlight fzf1 ctermfg=242 ctermbg=236
    highlight fzf2 ctermfg=143
    highlight fzf3 ctermfg=15 ctermbg=239
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fzf%#fzf3#
  endfunction

  autocmd! User FzfStatusLine call <SID>fzf_statusline()
endif
" }}}

Plug 'vim-scripts/a.vim', { 'on': 'A' }
Plug 'brooth/far.vim', { 'on': ['Far', 'Farp', 'F'] }
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

map <Space><Space>w <Plug>(easymotion-bd-wl)
map <Space><Space>f <Plug>(easymotion-bd-fl)

map <Plug>(easymotion-prefix)f <Plug>(easymotion-bd-f)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)L <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

if s:os !~ "synology"
  nmap <Plug>(easymotion-prefix)f <Plug>(easymotion-overwin-f)
  nmap <Plug>(easymotion-prefix)s <Plug>(easymotion-overwin-f2)
  nmap <Plug>(easymotion-prefix)L <Plug>(easymotion-overwin-line)
  nmap <Plug>(easymotion-prefix)w <Plug>(easymotion-overwin-w)
endif
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
if !has("nvim") && s:os !~ "windows"
  set <M-/>=/
  set <M-?>=?
endif
vmap <M-/> <Esc><Plug>(incsearch-forward)\%V
vmap <M-?> <Esc><Plug>(incsearch-backward)\%V
if s:os =~ "windows"
  set encoding& " make sure mapping is correct in default encoding
  vmap <M-/> <Esc><Plug>(incsearch-forward)\%V
  vmap <M-?> <Esc><Plug>(incsearch-backward)\%V
  set encoding=utf8
endif
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

noremap <silent><expr> <Leader><Leader>/ incsearch#go(<SID>config_easyfuzzymotion())
" }}}

" CamelCaseMotion {{{
Plug 'bkad/CamelCaseMotion'

map ,mw <Plug>CamelCaseMotion_w
map ,mb <Plug>CamelCaseMotion_b
map ,me <Plug>CamelCaseMotion_e
map ,mge <Plug>CamelCaseMotion_ge
" }}}

" clever-f.vim {{{
Plug 'rhysd/clever-f.vim'

let g:clever_f_smart_case = 1
" }}}

Plug 'wellle/targets.vim'
" }}}

" Text Manipulation {{{
" ====================================================================
" Tabular {{{
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

nnoremap <Leader>a=    :Tabularize /=<CR>
vnoremap <Leader>a=    :Tabularize /=<CR>
nnoremap <Leader>a:    :Tabularize /:\zs<CR>
vnoremap <Leader>a:    :Tabularize /:\zs<CR>
nnoremap <Leader>athen :Tabularize /then<CR>
vnoremap <Leader>athen :Tabularize /then<CR>
" }}}

" EasyAlign {{{
Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" auto-pairs {{{
Plug 'jiangmiao/auto-pairs'

let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

augroup autoPairsFileTypeSpecific
  autocmd!

  autocmd Filetype xml let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<': '>'}
augroup END
" }}}

" eraseSubword {{{
Plug 'vim-scripts/eraseSubword'

let g:EraseSubword_insertMap = '<C-e><C-e>'
" }}}

" NERDCommenter {{{
Plug 'scrooloose/nerdcommenter'

let g:NERDCustomDelimiters = {
  \ 'pfmain': { 'left': '#' }
  \ }
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" }}}

" Text Objects {{{
" ====================================================================
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

  let g:syntastic_ignore_files = ['\m^/usr/include/', '\m\c\.h$']
  nnoremap <Space><F8> :SyntasticCheck<CR>
end
" }}}

" ale {{{
if !s:is_disabled_plugin('ale')
  Plug 'w0rp/ale'

  let g:ale_linters = {
        \ 'cpp': ['g++']
        \}
end
" }}}

Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'moll/vim-node'
Plug 'tpope/vim-rails'
Plug 'etaoins/vim-volt-syntax'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/vim-slumlord'
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

nnoremap <silent> ]h :<C-u>execute v:count1 . "GitGutterNextHunk"<CR>
nnoremap <silent> [h :<C-u>execute v:count1 . "GitGutterPrevHunk"<CR>
nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gt :GitGutterAll<CR>
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

autocmd! FileType GV nnoremap <buffer> <silent> + :call <sid>gv_expand()<cr>
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
nnoremap <Leader>R :Rooter<CR>
" }}}

" vimwiki {{{
Plug 'vimwiki/vimwiki', { 'for': 'vimwiki' }

nnoremap <Leader>wg :VimwikiToggleListItem<CR>
" }}}

" orgmode {{{
Plug 'jceb/vim-orgmode', { 'for': 'org' }
" }}}

" vimoutliner {{{
Plug 'vimoutliner/vimoutliner', { 'for': 'votl' }
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

  let g:neoterm_position = 'horizontal'
  let g:neoterm_automap_keys = ',tt'

  nnoremap <silent> <Space>` :execute 'T ' . input("Terminal: ")<CR>
  nnoremap <silent> <Leader>` :Ttoggle<CR>
  nnoremap <silent> <Space><F3> :TREPLSendFile<CR>
  nnoremap <silent> <F3> :TREPLSendLine<CR>
  vnoremap <silent> <F3> :TREPLSendSelection<CR>

  " Useful maps
  " hide/close terminal
  nnoremap <silent> <Leader>th :Tclose<CR>
  " clear terminal
  nnoremap <silent> <Leader>tl :Tclear<CR>
  " kills the current job (send a <c-c>)
  nnoremap <silent> <Leader>tc :Tkill<CR>
endif
" }}}

Plug 'vim-scripts/dbext.vim'
Plug 'tyru/open-browser.vim'
Plug 'tpope/vim-abolish'
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'alx741/vinfo', { 'on': 'Vinfo' }
Plug 'mattn/webapi-vim'
Plug 'tpope/vim-scriptease'
Plug 'kana/vim-arpeggio'
Plug 'kopischke/vim-fetch'
Plug 'Valloric/ListToggle'
Plug 'tpope/vim-eunuch'
" }}}

" Plugin Settings End {{{
" vim-plug
call plug#end()
" }}}

" Post-loaded Plugin Settings {{{
" Denite {{{
if !s:is_disabled_plugin('denite.nvim')
  " Change mappings
  call denite#custom#map(
        \ 'insert',
        \ '<C-r>',
        \ '<denite:toggle_matchers:matcher_substring>',
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

" Arpeggio {{{
call arpeggio#load()
" }}}
" }}}

" General Settings {{{
" ====================================================================

" Vim basic setting
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
" Quickly escape insert mode
Arpeggio inoremap jk <Esc>

" Add key mapping for suspend
nnoremap <Space><C-z> :suspend<CR>

" Quickly switch window {{{
" Fix meta key in vim
if !has("nvim") && s:os !~ "windows"
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
if s:os =~ "windows"
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
if s:os =~ "windows"
  set encoding& " make sure mapping is correct in default encoding
  imap <M-h> <Left>
  imap <M-j> <Down>
  imap <M-k> <Up>
  imap <M-l> <Right>
  set encoding=utf8
endif
" }}}

" Saner command-line history {{{
" Fix meta key in vim
if !has("nvim") && s:os !~ "windows"
  set <M-n>=n
  set <M-p>=p
endif

cnoremap <M-n> <Down>
cnoremap <M-p> <Up>
if s:os =~ "windows"
  set encoding& " make sure mapping is correct in default encoding
  cnoremap <M-n> <Down>
  cnoremap <M-p> <Up>
  set encoding=utf8
endif
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
map <C-w><Space>- <C-w>10-
map <C-w><Space>+ <C-w>10+
map <C-w><Space>< <C-w>10<
map <C-w><Space>> <C-w>10>

" Add mapping to delete in insert mode
inoremap <C-b> <Del>

" Create new line in insert mode {{{
" Fix meta key in vim
if !has("nvim") && s:os !~ "windows"
  set <M-o>=o
  set <M-S-o>=O
endif

imap <M-o> <C-o>o
imap <M-S-o> <C-o>O
" }}}

" Save
nnoremap <C-s> :update<CR>

" Quit
nnoremap <Space>q :q<CR>
nnoremap <Space>Q :qa!<CR>

" Win32
"nmap <Leader>x :execute ':! "'.expand('%').'"'<CR>
nmap <Leader>x :!start cmd /c "%:p"<CR>
nmap <Leader>X :!start cmd /K cd /D %:p:h<CR>
nmap <Leader>E :execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'<CR>

" Easier file status
nnoremap <Space><C-g> 2<C-g>

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
if !has("nvim") && s:os !~ "windows"
  set <M-1>=1
endif
nmap <M-1> :execute "tabn " . g:last_tab<CR>
if s:os =~ "windows"
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
if !has("gui_running") && s:os =~ "windows"
  set term=xterm
  set mouse=a
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  colorscheme seoul256
endif
" }}}

" neovim terminal key mapping
if has("nvim")
  " For quick terminal access
  nnoremap <silent> <Leader>tT :tabnew<CR>:terminal<CR>i
  nnoremap <silent> <Leader>ts :new<CR>:terminal<CR>i
  nnoremap <silent> <Leader>tv :vnew<CR>:terminal<CR>i

  tnoremap <Space><F1> <C-\><C-n>
  tnoremap <Space><F2> <C-\><C-n>:tabnew<CR>:terminal<CR>i

  " Quickly switch window in terminal
  tnoremap <M-S-h> <C-\><C-n><C-w>h
  tnoremap <M-S-j> <C-\><C-n><C-w>j
  tnoremap <M-S-k> <C-\><C-n><C-w>k
  tnoremap <M-S-l> <C-\><C-n><C-w>l

  " Quickly switch tab in terminal
  tnoremap <M-C-j> <C-\><C-n>gT
  tnoremap <M-C-k> <C-\><C-n>gt

  tnoremap <M-1> <C-\><C-n>:exe "tabn " . g:last_tab<CR>
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

if has("nvim")
  augroup terminalSettings
    autocmd!
    autocmd WinEnter term://* startinsert
    autocmd TermClose term://* call nvim_input('<CR>')
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
" }}}

" Backspace in ConEmu will translate to 0x07F when using xterm
" https://conemu.github.io/en/VimXterm.html
" https://github.com/Maximus5/ConEmu/issues/641
if !empty($ConEmuBuild)
  let &t_kb = nr2char(127)
  let &t_kD = "^[[3~"

  " Disable Background Color Erase
  set t_ut=
endif
" vim: set sw=2 ts=2 sts=2 et foldlevel=0 foldmethod=marker:
