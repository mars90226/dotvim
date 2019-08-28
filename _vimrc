"
" Bootstrap {{{
" ====================================================================
" Map Leader
let g:mapleader = ","

" Language
" Always use English to avoid plugin not catching exception due to translation
" E.g. vim-subversive tries to catch 'Unknown Exception'
if !has('nvim')
  " neovim current seems not using system locale
  " And language C seems to break :Denite file
  language C
endif

" Change Menu language
" This should happen before loading plugins to avoid deleting plugins' menus
if has('gui')
  if &langmenu != 'en_US.UTF-8'
    set langmenu=en_US.UTF-8
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
  endif
endif

" Set Encoding
if vimrc#plugin#check#get_os() =~ "windows"
  set encoding=utf8
endif

" Set nvim version
if has("nvim")
  let s:nvim_version = systemlist("nvim --version")[0]
  function! s:get_nvim_version()
    return s:nvim_version
  endfunction

  function! s:get_nvim_patch_version()
    return matchlist(s:nvim_version, '\v^NVIM v\d+\.\d+\.\d+-(\d+)')[1]
  endfunction
endif

" plugin choosing {{{
" enabled plugin management {{{
command! ListDisabledPlugins call vimrc#plugin#get_disabled_plugins()
" }}}

" plugin config cache {{{
command! UpdatePluginConfigCache call vimrc#plugin#update_plugin_config_cache()

call vimrc#plugin#config_cache#read()
call vimrc#plugin#config_cache#init()
" }}}

" Start choosing
call vimrc#plugin#choose#start($VIM_MODE, $NVIM_TERMINAL)
" }}}

" Autoinstall vim-plug {{{
if empty(glob(vimrc#get_vimhome().'/autoload/plug.vim'))
  silent! !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://rawgithubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_install
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif
" }}}
" }}}

" Plugin Settings Begin {{{
" vim-plug
call plug#begin(vimrc#get_vimhome().'/plugged')
" }}}

" Appearance {{{
" ====================================================================
" vim-airline {{{
if vimrc#plugin#is_enabled_plugin('vim-airline')
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

  let g:airline_theme = 'gruvbox'
endif
" }}}

" lightline.vim {{{
if vimrc#plugin#is_enabled_plugin('lightline.vim')
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 'shinchu/lightline-gruvbox.vim'

  " Fugitive special revisions. call '0' "staging" ?
  let s:names = {'0': 'index', '1': 'orig', '2':'fetch', '3':'merge'}
  let s:sha1size = 7

  let g:lightline = {}
  let g:lightline.colorscheme = 'gruvbox'
  let g:lightline.component = {
        \ 'truncate': '%<',
        \ }
  let g:lightline.component_expand = {
        \ 'linter_checking': 'lightline#ale#checking',
        \ 'linter_warnings': 'lightline#ale#warnings',
        \ 'linter_errors': 'lightline#ale#errors',
        \ 'linter_ok': 'lightline#ale#ok',
        \ }
  let g:lightline.component_type = {
        \ 'linter_checking': 'left',
        \ 'linter_warnings': 'warning',
        \ 'linter_errors': 'error',
        \ 'linter_ok': 'left',
        \ }
  let g:lightline.component_function = {
        \ 'fugitive': 'vimrc#lightline#fugitive',
        \ 'filename': 'vimrc#lightline#filename',
        \ 'fileformat': 'vimrc#lightline#fileformat',
        \ 'filetype': 'vimrc#lightline#filetype',
        \ 'fileencoding': 'vimrc#lightline#fileencoding',
        \ 'mode': 'vimrc#lightline#mode',
        \ }
  let g:lightline.tab_component_function = {
        \ 'filename': 'vimrc#lightline#tab_filename',
        \ 'modified': 'vimrc#lightline#tab_modified',
        \ }
  let g:lightline.active = {
        \ 'left': [
        \   [ 'mode', 'paste' ],
        \   [ 'truncate', 'fugitive', 'filename' ] ],
        \ 'right': [
        \   [ 'lineinfo', 'percent' ],
        \   [ 'filetype', 'fileformat', 'fileencoding' ],
        \   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ] ]
        \ }
  let g:lightline.inactive = {
        \ 'left': [
        \   ['filename'] ],
        \ 'right': [
        \   ['lineinfo', 'percent'] ]
        \ }
  let g:lightline.tab = {
        \ 'active': [ 'tabnum', 'filename', 'modified' ],
        \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
endif
" }}}

" indentLine {{{
Plug 'Yggdroot/indentLine', { 'on': ['IndentLinesEnable', 'IndentLinesToggle'] }

let g:indentLine_enabled = 0
let g:indentLine_color_term = 243
let g:indentLine_color_gui = '#AAAAAA'

function! s:toggle_indentline_enabled()
  if g:indentLine_enabled == 0
    let g:indentLine_enabled = 1
  else
    let g:indentLine_enabled = 0
  endif
endfunction

nnoremap <Space>il :IndentLinesToggle<CR>
nnoremap <Space>iL :call <SID>toggle_indentline_enabled()<CR>

augroup indent_line_syntax
  autocmd!
  autocmd User indentLine doautocmd indentLine Syntax
augroup END
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
" completion setting {{{
" FIXME Completion popup still appear after select completion.
" inoremap <expr> <Esc>      pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-N>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-P>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"
inoremap <expr> <Tab>      pumvisible() ? "\<C-N>" : "\<Tab>"

" Workaround of supertab bug
if vimrc#plugin#is_disabled_plugin('supertab')
  inoremap <expr> <S-Tab>    pumvisible() ? "\<C-P>" : "\<S-Tab>"
endif
" }}}

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  Plug 'Shougo/neco-vim'
  Plug 'neoclide/coc-neco'
  Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
  Plug 'neoclide/coc-denite'

  " <Tab>: completion.
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-N>" :
        \ vimrc#check_back_space() ? "\<Tab>" :
        \ coc#refresh()

  " <S-Tab>: completion back.
  inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

  " <M-Space>: trigger completion
  inoremap <silent><expr> <M-Space> coc#refresh()

  " <CR>: confirm completion, or insert <CR> with new undo chain
  inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

  " Define mapping for diff mode to avoid recursive mapping
  nnoremap <silent> <Plug>(diff-prev) [c
  nnoremap <silent> <Plug>(diff-next) ]c
  nmap <silent><expr> [c &diff ? "\<Plug>(diff-prev)" : "\<Plug>(coc-diagnostic-prev)"
  nmap <silent><expr> ]c &diff ? "\<Plug>(diff-next)" : "\<Plug>(coc-diagnostic-next)"

  " mapppings for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " mappings for funcobj
  omap av <Plug>(coc-funcobj-a)
  xmap av <Plug>(coc-funcobj-a)
  omap iv <Plug>(coc-funcobj-i)
  xmap iv <Plug>(coc-funcobj-i)

  " K: show documentation in preview window
  nnoremap <silent> K :call vimrc#coc#show_documentation()<CR>
  " Remap for K
  nnoremap gK K

  " mappings for rename current word
  nmap <Space>cr <Plug>(coc-rename)

  " mappings for format selected region
  nmap <Space>cf <Plug>(coc-format-selected)
  xmap <Space>cf <Plug>(coc-format-selected)

  augroup coc_settings
    autocmd!
    " Highlight symbol under cursor on CursorHold
    " Disabled as not useful and generate a lot of error when not indexed
    " autocmd CursorHold * silent call CocActionAsync('highlight')
    " Setup formatexpr
    autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END

  " mappings for do codeAction of selected region
  nmap <Space>ca <Plug>(coc-codeaction-selected)
  xmap <Space>ca <Plug>(coc-codeaction-selected)

  " mappings for do codeAction of current line
  nmap <Space>cc <Plug>(coc-codeaction)
  " mappings for fix autofix problem of current line
  nmap <Space>cx <Plug>(coc-fix-current)

  " :Format for format current buffer
  command! -nargs=0 Format :call CocAction('format')

  " :Fold for fold current buffer
  command! -nargs=? Fold :call CocAction('fold', <f-args>)

  " TODO Add airline support

  " Show all diagnostics
  nnoremap <silent> <Space>cd :CocList diagnostics<CR>
  " Manage extensions
  nnoremap <silent> <Space>ce :CocList extensions<CR>
  " Show commands
  nnoremap <silent> <Space>c; :CocList commands<CR>
  " Find symbol of current document
  nnoremap <silent> <Space>co :CocList outline<CR>
  " Search workspace symbols
  nnoremap <silent> <Space>cs :CocList -I symbols<CR>
  " Do default action for next item.
  nnoremap <silent> <Space>cj :CocNext<CR>
  " Do default action for prevous item.
  nnoremap <silent> <Space>ck :CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent> <Space>cu :CocListResume<CR>
  " Show lists
  nnoremap <silent> <Space>cl :CocList lists<CR>

  command! CocToggle call vimrc#coc#toggle()
  nnoremap <silent> <Space>cy :CocToggle<CR>

  augroup coc_ccls_settings
    autocmd!
    autocmd FileType c,cpp call vimrc#coc#ccls_mappings()
  augroup END
endif
" }}}

" deoplete.nvim {{{
if vimrc#plugin#is_enabled_plugin('deoplete.nvim')
  if has("nvim")
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif

  " Currently prefer deoplete-clang over clang_complete
  " Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'], 'do': 'make install' }
  Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] }
  " Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp'] }
  Plug 'Shougo/neoinclude.vim'
  Plug 'Shougo/neco-syntax'
  Plug 'Shougo/neco-vim'
  Plug 'sebastianmarkow/deoplete-rust', { 'for': ['rust'] }
  if vimrc#plugin#check#has_jedi()
    Plug 'deoplete-plugins/deoplete-jedi'
  endif
  Plug 'deoplete-plugins/deoplete-zsh'

  " tern_for_vim will install tern
  Plug 'carlitux/deoplete-ternjs' ", { 'do': 'npm install -g tern' }

  " TODO Move this out of deoplete.nvim section
  " Dock mode display error
  " Check if nvim has float-window support
  if has("nvim") && exists('*nvim_open_win') && exists('##CompleteChanged')
    Plug 'ncm2/float-preview.nvim'
  endif

  " Disabled for now
  " Plug 'autozimu/LanguageClient-neovim', {
  "   \ 'branch': 'next',
  "   \ 'do': './install.sh'
  "   \ }

  " Use deoplete.
  let g:deoplete#enable_at_startup = 1

  " deoplete_clang
  let g:deoplete#sources#clang#libclang_path = "/usr/lib/llvm-5.0/lib/libclang.so.1"
  let g:deoplete#sources#clang#clang_header = "/usr/lib/llvm-5.0/lib/clang"

  " clang_complete
  " let g:clang_library_path = '/usr/lib/llvm-5.0/lib/libclang.so.1'
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
  " let g:LanguageClient_settingsPath = vimrc#get_vimhome()."/settings.json"

  " deoplete-ternjs
  let g:deoplete#sources#ternjs#tern_bin = vimrc#get_vimhome() . "/plugged/tern_for_vim/node_modules/tern/bin/tern"

  " float-preview.nvim
  if has("nvim")
    set completeopt-=preview

    let g:float_preview#docked = 0
  endif

  " TODO Set python & python3 for jedi

  " <Tab>: completion.
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-N>" :
        \ vimrc#check_back_space() ? "\<Tab>" :
        \ deoplete#manual_complete()

  " <S-Tab>: completion back.
  inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

  " <C-H>, <BS>: close popup and delete backword char.
  inoremap <expr><C-H> deoplete#smart_close_popup()."\<C-H>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-H>"

  inoremap <expr><C-G><C-G> deoplete#refresh()
  inoremap <silent><expr><C-L> deoplete#complete_common_string()
endif
" }}}

" completor.vim {{{
if vimrc#plugin#is_enabled_plugin('completor.vim')
  Plug 'maralla/completor.vim'

  if vimrc#plugin#check#has_linux_build_env()
    let g:completor_clang_binary = "/usr/lib/llvm-8/lib/clang"
  end
endif
" }}}

" YouCompleteMe {{{
if vimrc#plugin#is_enabled_plugin('YouCompleteMe')
  Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang_completer' }

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
endif
" }}}

" supertab {{{
if vimrc#plugin#is_enabled_plugin('supertab')
  Plug 'ervandew/supertab'
endif
" }}}

" neosnippet {{{
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

let g:neosnippet#snippets_directory = vimrc#get_vimhome().'/plugged/neosnippet-snippets/neosnippets'
let g:neosnippet#snippets_directory = vimrc#get_vimhome().'/plugged/vim-snippets/snippets'

" Plugin key-mappings.
" <C-J>: expand or jump or select completion
imap <silent><expr> <C-J>
      \ pumvisible() && !neosnippet#expandable_or_jumpable() ?
      \ "\<C-Y>" :
      \ "\<Plug>(neosnippet_expand_or_jump)"
smap <C-J> <Plug>(neosnippet_expand_or_jump)
xmap <C-J> <Plug>(neosnippet_expand_target)

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" }}}

" tmux-complete.vim {{{
if executable('tmux')
  Plug 'wellle/tmux-complete.vim'
endif
" }}}
" }}}

" File Navigation {{{
" ====================================================================
" Choose matcher {{{
if has("python3")
  " Temporarily use bug fixing branch, wait for merging to master
  Plug 'raghur/fruzzy', { 'branch': 'bug-19-crash', 'do': { -> fruzzy#install() } }

  let g:fruzzy#usenative = 1
  let g:ctrlp_match_func = { 'match': 'fruzzy#ctrlp#matcher' }
elseif has("python")
  Plug 'FelikZ/ctrlp-py-matcher'

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
" }}}

" CtrlP {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'sgur/ctrlp-extensions.vim'
Plug 'tacahiroy/ctrlp-funky'
Plug 'mattn/ctrlp-hackernews'
Plug 'fisadev/vim-ctrlp-cmdpalette'
Plug 'ivalkeen/vim-ctrlp-tjump'

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" let g:ctrlp_cmdpalette_execute = 1

nnoremap <C-P> :CtrlP<CR>
nnoremap <Space>cO :CtrlPFunky<CR>
nnoremap <Space>cK :execute 'CtrlPFunky ' . expand('<cword>')<CR>
xnoremap <Space>cK :<C-U>execute 'CtrlPFunky ' . vimrc#get_visual_selection()<CR>
nnoremap <Space>cp :CtrlPCmdPalette<CR>
nnoremap <Space>cm :CtrlPCmdline<CR>
nnoremap <Space>c] :CtrlPtjump<CR>
xnoremap <Space>c] :CtrlPtjumpVisual<CR>

command! -nargs=1 CtrlPSetTimeout call vimrc#ctrlp#set_timeout(<f-args>)

if executable('fd')
  let g:ctrlp_base_user_command = 'fd --type f --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore "" %s'
endif

call vimrc#ctrlp#update_user_command(v:true)
" }}}

" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number

augroup netrw_mapping
  autocmd!
  autocmd FileType netrw call s:netrw_mapping()
augroup END

function! s:netrw_mapping()
  nmap <buffer> <BS> <Plug>VinegarUp
endfunction
" }}}

" Vinegar {{{
Plug 'tpope/vim-vinegar'

nmap <silent> \-       <Plug>VinegarUp
nmap <silent> _        <Plug>VinegarVerticalSplitUp
nmap <silent> <Space>- <Plug>VinegarSplitUp
nmap <silent> <Space>_ <Plug>VinegarTabUp
" }}}

" tagbar {{{
Plug 'majutsushi/tagbar', { 'on': ['TagbarToggle', 'TagbarOpenAutoClose'] }

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

if vimrc#plugin#is_enabled_plugin('lightline.vim')
  let g:tagbar_status_func = 'vimrc#lightline#tagbar_status_func'
endif
" }}}

" vimfiler {{{
if vimrc#plugin#is_enabled_plugin("vimfiler")
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/neossh.vim'

  if vimrc#plugin#is_enabled_plugin('lightline.vim')
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  let g:vimfiler_as_default_explorer = 1
  nnoremap <F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit<CR>
  nnoremap <Space><F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit -find<CR>

  augroup vimfiler_mappings
    autocmd!
    autocmd FileType vimfiler call vimrc#vimfiler#mappings()
  augroup END
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin("defx")
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/defx-git'
  " Font not supported
  " Plug 'kristijanhusak/defx-icons'

  augroup netrw_mapping_for_defx
    autocmd!
    autocmd FileType netrw call vimrc#defx#netrw_mapping_for_defx()
  augroup END

  nnoremap <F4>        :Defx -split=vertical -winwidth=35 -direction=topleft -toggle<CR>
  nnoremap <Space><F4> :Defx -split=vertical -winwidth=35 -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>
  nnoremap -           :call vimrc#defx#opendir('Defx')<CR>
  nnoremap ++          :call vimrc#defx#opendir('Defx')<CR>
  nnoremap \-          :call vimrc#defx#opendir('Defx')<CR>
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
endif
" }}}

" vim-choosewin {{{
if vimrc#plugin#is_enabled_plugin("vimfiler")
  " Only used in vimfiler
  Plug 't9md/vim-choosewin'

  " seoul256 colors
  let g:choosewin_color_label_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
  let g:choosewin_color_label = { 'gui': ['#719872', ''], 'cterm': [65, 0] }
  let g:choosewin_color_other = { 'gui': ['#757575', '#BFBFBF'], 'cterm': [241, 249] }
  let g:choosewin_color_overlay_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
  let g:choosewin_color_overlay = { 'gui': ['#007173', '#DEDFBD'], 'cterm': [23, 187, 'bold'] }
  nmap ++ <Plug>(choosewin)
  nmap <Leader>= <Plug>(choosewin)
endif
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

" for unite-workflow
let g:github_user = "mars90226"

if vimrc#plugin#is_enabled_plugin('lightline.vim')
  let g:unite_force_overwrite_statusline = 0
endif

" Unite key mappings {{{
" Unite don't auto-preview file as it's slow
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite -buffer-name=files buffer bookmark file<CR>
if has("nvim")
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>/ :call vimrc#unite#grep('', 'grep', '', v:false)<CR>
nnoremap <Space>? :call vimrc#unite#grep('', 'grep', input('Option: '), v:false)<CR>
nnoremap <Space>S :Unite source<CR>
nnoremap <Space>m :Unite -start-insert file_mru<CR>
nnoremap <Space>M :Unite -buffer-name=files -default-action=lcd -start-insert directory_mru<CR>
nnoremap <Space>o :Unite outline -start-insert<CR>
nnoremap <Space>a :execute 'Unite anzu:' . input ('anzu: ')<CR>
nnoremap <Space>ua :Unite location_list<CR>
nnoremap <Space>uA :Unite apropos -start-insert<CR>
nnoremap <Space>ub :UniteWithBufferDir -buffer-name=files -prompt=%\  file<CR>
nnoremap <Space>uc :Unite -auto-preview change<CR>
nnoremap <Space>uC :UniteWithCurrentDir -buffer-name=files file<CR>
nnoremap <Space>ud :Unite directory<CR>
nnoremap <Space>uD :UniteWithBufferDir directory<CR>
nnoremap <Space>u<C-D> :execute 'Unite directory:' . input('dir: ')<CR>
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
nnoremap <Space>uj :Unite -auto-preview jump<CR>
nnoremap <Space>uk :call vimrc#unite#grep(expand('<cword>'), 'keyword', '', v:false)<CR>
nnoremap <Space>uK :call vimrc#unite#grep(expand('<cWORD>'), 'keyword', '', v:false)<CR>
nnoremap <Space>u8 :call vimrc#unite#grep(expand('<cword>'), 'keyword', '', v:true)<CR>
nnoremap <Space>u* :call vimrc#unite#grep(expand('<cWORD>'), 'keyword', '', v:true)<CR>
xnoremap <Space>uk :<C-U>call vimrc#unite#grep(vimrc#get_visual_selection(), 'keyword', '', v:false)<CR>
xnoremap <Space>u8 :<C-U>call vimrc#unite#grep(vimrc#get_visual_selection(), 'keyword', '', v:true)<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>uo :Unite output -start-insert<CR>
nnoremap <Space>uO :Unite outline -start-insert<CR>
nnoremap <Space>up :UniteWithProjectDir -buffer-name=files -prompt=&\  file<CR>
nnoremap <Space>uq :Unite quickfix<CR>
nnoremap <Space>ur :Unite -buffer-name=register register<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>ut :Unite -start-insert tab<CR>
nnoremap <Space>uT :Unite tag<CR>
nnoremap <Space>uu :UniteResume<CR>
nnoremap <Space>uU :Unite -buffer-name=resume resume<CR>
nnoremap <Space>uw :Unite window<CR>
nnoremap <Space>uy :Unite history/yank -start-insert<CR>
nnoremap <Space>uma :Unite mapping<CR>
nnoremap <Space>ume :Unite output:message<CR>
nnoremap <Space>ump :Unite output:map<CR>
nnoremap <Space>u: :Unite history/command -start-insert<CR>
nnoremap <Space>u; :Unite command -start-insert<CR>
nnoremap <Space>u/ :Unite history/search<CR>

nnoremap <Space><F1> :Unite output:map<CR>

if executable('fd')
  let g:unite_source_rec_async_command =
        \ ['fd', '--type', 'file', '--follow', '--hidden', '--exclude', '.git', '']
endif

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>g/ :call vimrc#unite#grep('', 'grep', vimrc#rg_current_type_option(), v:false)<CR>
  nnoremap <Space>g? :call vimrc#unite#grep('', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
endif
" }}}

augroup unite_mappings
  autocmd!
  autocmd FileType unite call vimrc#unite#mappings()
augroup END
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/denite-extra'
  Plug 'kmnk/denite-dirmark'

  let g:session_directory = $HOME.'/vim-sessions/'
  let g:denite_source_session_path = $HOME.'/vim-sessions/'
  let g:project_folders = ['/synosrc/packages/source']

  " Denite key mappings {{{
  " Override Unite key mapping {{{
  call vimrc#remap('<Space>up', '<Space>u<C-P>', 'n') " UniteWithProjectDir file
  call vimrc#remap('<Space>P',  '<Space>uP',     'n') " Unite file/rec
  call vimrc#remap('<Space>p',  '<Space>up',     'n') " Unite file
  call vimrc#remap('<Space>ul', '<Space>uL',     'n') " UniteWithCursorWord line
  call vimrc#remap('<Space>l',  '<Space>ul',     'n') " Unite line
  call vimrc#remap('<Space>o',  '<Space>O',      'n') " Unite outline

  nnoremap <Space>p     :Denite -auto-resume buffer dirmark file<CR>
  nnoremap <Space>P     :Denite -auto-resume file/rec<CR>
  nnoremap <Space><C-P> :DeniteProjectDir -auto-resume file<CR>
  nnoremap <Space>l     :Denite -auto-action=highlight line<CR>
  nnoremap <Space>L     :Denite -default-action=switch line:buffers<CR>
  nnoremap <Space>dl    :DeniteCursorWord -auto-action=preview -split=no line<CR>
  nnoremap <Space>o     :Denite outline<CR>
  " }}}

  " TODO Denite quickfix seems not working
  " TODO Add Denite tselect source
  " Denite don't use auto-preview file because it's slow

  nnoremap <Space>da :Denite location_list<CR>
  nnoremap <Space>db :DeniteBufferDir -auto-resume file<CR>
  nnoremap <Space>dc :Denite -auto-action=preview change<CR>
  nnoremap <Space>dd :Denite directory_rec<CR>
  nnoremap <Space>dD :Denite directory_mru<CR>
  nnoremap <Space>df :Denite filetype<CR>
  nnoremap <Space>dh :Denite help<CR>
  nnoremap <Space>dj :Denite -auto-action=preview jump<CR>
  nnoremap <Space>dJ :Denite project<CR>
  nnoremap <Space>di :call vimrc#denite#grep('!', 'grep', '', v:false)<CR>
  nnoremap <Space>dk :call vimrc#denite#grep(expand('<cword>'), 'grep', '', v:false)<CR>
  nnoremap <Space>dK :call vimrc#denite#grep(expand('<cWORD>'), 'grep', '', v:false)<CR>
  nnoremap <Space>d8 :call vimrc#denite#grep(expand('<cword>'), 'grep', '', v:true)<CR>
  nnoremap <Space>d* :call vimrc#denite#grep(expand('<cWORD>'), 'grep', '', v:true)<CR>
  xnoremap <Space>dk :<C-U>call vimrc#denite#grep(vimrc#get_visual_selection(), 'grep', '', v:false)<CR>
  xnoremap <Space>d8 :<C-U>call vimrc#denite#grep(vimrc#get_visual_selection(), 'grep', '', v:true)<CR>
  nnoremap <Space>dm :Denite file_mru<CR>
  nnoremap <Space>dM :Denite directory_mru<CR>
  nnoremap <Space>do :execute 'Denite output:' . vimrc#escape_symbol(input('output: '))<CR>
  nnoremap <Space>dO :Denite outline<CR>
  nnoremap <Space>d<C-O> :Denite unite:outline<CR>
  nnoremap <Space>dp :call vimrc#denite#project_tags('')<CR>
  nnoremap <Space>dP :call vimrc#denite#project_tags(expand('<cword>'))<CR>
  nnoremap <Space>d<C-P> :Denite -auto-resume -auto-action=preview file/rec<CR>
  nnoremap <Space>dq :Denite quickfix<CR>
  nnoremap <Space>dr :Denite register<CR>
  nnoremap <Space>ds :Denite session<CR>
  nnoremap <Space>d<Space> :Denite source<CR>
  nnoremap <Space>dt :Denite tag<CR>
  nnoremap <Space>du :Denite -resume<CR>
  nnoremap <Space>dU :Denite -resume -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
  nnoremap <Space>d<C-U> :Denite -resume -refresh -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
  nnoremap <Space>dy :Denite neoyank<CR>
  nnoremap <Space>d: :Denite command_history<CR>
  nnoremap <Space>d; :Denite command<CR>
  nnoremap <Space>d/ :call vimrc#denite#grep('', 'grep', '', v:false)<CR>
  nnoremap <Space>d? :call vimrc#denite#grep('', 'grep', input('Option: '), v:false)<CR>

  nnoremap <silent> [d :Denite -resume -immediately -cursor-pos=-1<CR>
  nnoremap <silent> ]d :Denite -resume -immediately -cursor-pos=+1<CR>
  nnoremap <silent> [D :Denite -resume -immediately -cursor-pos=-1 -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
  nnoremap <silent> ]D :Denite -resume -immediately -cursor-pos=+1 -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>

  if executable('rg')
    nnoremap <Space>dg/ :call vimrc#denite#grep('', 'grep', vimrc#rg_current_type_option(), v:false)<CR>
    nnoremap <Space>dg? :call vimrc#denite#grep('', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
  endif
  " }}}

  " Denite buffer key mappings {{{
  augroup denite_mappings
    autocmd!
    autocmd FileType denite        call vimrc#denite#mappings()
    autocmd FileType denite-filter call vimrc#denite#filter_mappings()
  augroup END
  " }}}
endif
" }}}

" ctrlsf.vim {{{
Plug 'dyng/ctrlsf.vim', { 'on': 'CtrlSF' }

nnoremap <Space><C-F> :execute 'CtrlSF ' . input('CtrlSF: ')<CR>
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
" }}}
" }}}

" skim {{{
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }

command! SkimMru call skim#run(skim#wrap({
      \ 'source':  vimrc#fzf#mru#mru_files(),
      \ 'options': '-m',
      \ 'down':    '40%' }))

nnoremap <Space>sm :SkimMru<CR>
" }}}

" vifm {{{
Plug 'vifm/vifm.vim'
" }}}

" vim-gutentags {{{
if vimrc#plugin#is_enabled_plugin('vim-gutentags')
  Plug 'ludovicchabant/vim-gutentags'

  " Don't update cscope, workload is too heavy
  let g:gutentags_modules = ['ctags']
  let g:gutentags_ctags_exclude = ['.git', 'node_modules', '.ccls-cache']
endif
" }}}

" alternate.vim {{{
Plug 'pchynoweth/a.vim'

augroup AlternateSettings
  autocmd!
  autocmd VimEnter * call <SID>alternate_settings()
augroup END
function! s:alternate_settings()
  " ReactJS
  let g:alternateExtensionsDict["javascript.jsx"] = {}
  let g:alternateExtensionsDict["javascript.jsx"]["js"] = "css,scss"
  let g:alternateExtensionsDict["css"] = {}
  let g:alternateExtensionsDict["css"]["css"] = "js"
  let g:alternateExtensionsDict["scss"] = {}
  let g:alternateExtensionsDict["scss"]["scss"] = "js"
endfunction
" }}}

" far.vim {{{
Plug 'brooth/far.vim', { 'on': ['Far', 'Farp', 'F'] }

if has("python3")
  if has("nvim")
    if executable('rg')
      let g:far#source = 'rgnvim'
    elseif executable('ag')
      let g:far#source = 'agnvim'
    elseif executable('ack')
      let g:far#source = 'acknvim'
    endif
  else
    if executable('rg')
      let g:far#source = 'rg'
    elseif executable('ag')
      let g:far#source = 'ag'
    elseif executable('ack')
      let g:far#source = 'ack'
    endif
  endif
else
  " Default behavior
  " g:far#source = 'vimgrep'
endif
" }}}

" }}}

" Text Navigation {{{
" ====================================================================
" matchit {{{
runtime macros/matchit.vim
Plug 'voithos/vim-python-matchit'
" }}}

" EasyMotion {{{
Plug 'easymotion/vim-easymotion', { 'on': [] }

call vimrc#lazy#lazy_load('easymotion')

let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ; <Plug>(easymotion-s2)

map \w <Plug>(easymotion-bd-wl)
map \f <Plug>(easymotion-bd-fl)
map \s <Plug>(easymotion-sl2)

map <Leader>f <Plug>(easymotion-bd-f)
map <Space><Space>l <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

nmap <Leader>' <Plug>(easymotion-next)
nmap <Leader>; <Plug>(easymotion-prev)
nmap <Leader>. <Plug>(easymotion-repeat)

map <Plug>(easymotion-prefix)J <Plug>(easymotion-eol-j)
map <Plug>(easymotion-prefix)K <Plug>(easymotion-eol-k)

map <Plug>(easymotion-prefix); <Plug>(easymotion-jumptoanywhere)

" overwin is slow, disabled
" if vimrc#plugin#check#get_os() !~ "synology"
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

command! AnzuToggleUpdate call s:AnzuToggleUpdate()
function! s:AnzuToggleUpdate()
  if g:anzu_enable_CursorHold_AnzuUpdateSearchStatus == 0
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 2
  else
    let g:anzu_enable_CursorHold_AnzuUpdateSearchStatus = 0
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

" For original search incase need to insert special characters like NULL
nnoremap \\/ /
nnoremap \\? ?

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" Search within visual selection
xmap <M-/> <Esc><Plug>(incsearch-forward)\%V
xmap <M-?> <Esc><Plug>(incsearch-backward)\%V

augroup incsearch_settings
  autocmd!
  autocmd BufWinLeave,WinLeave * call vimrc#incsearch#clear_nohlsearch()
augroup END

command! ClearIncsearchAutoNohlsearch call vimrc#incsearch#clear_auto_nohlsearch()
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
noremap <silent><expr> \/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
noremap <silent><expr> Z/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
" }}}

" CamelCaseMotion {{{
Plug 'bkad/CamelCaseMotion'

map <Leader>mw <Plug>CamelCaseMotion_w
map <Leader>mb <Plug>CamelCaseMotion_b
map <Leader>me <Plug>CamelCaseMotion_e
map <Leader>mge <Plug>CamelCaseMotion_ge

omap <silent> imw <Plug>CamelCaseMotion_iw
xmap <silent> imw <Plug>CamelCaseMotion_iw
omap <silent> imb <Plug>CamelCaseMotion_ib
xmap <silent> imb <Plug>CamelCaseMotion_ib
omap <silent> ime <Plug>CamelCaseMotion_ie
xmap <silent> ime <Plug>CamelCaseMotion_ie
" }}}

" vim-edgemotion {{{
Plug 'haya14busa/vim-edgemotion'

map <Space><Space>j <Plug>(edgemotion-j)
map <Space><Space>k <Plug>(edgemotion-k)
" }}}

Plug 'wellle/targets.vim'
Plug 'jeetsukumaran/vim-indentwise'
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

" Custom <CR> map to avoid enter <CR> when popup is opened
" inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>" . AutoPairsReturn()

function! s:AutoPairsToggleMultilineClose()
  if g:AutoPairsMultilineClose == 0
    let g:AutoPairsMultilineClose = 1
  else
    let g:AutoPairsMultilineClose = 0
  endif
endfunction
command! AutoPairsToggleMultilineClose call <SID>AutoPairsToggleMultilineClose()

augroup autoPairsFileTypeSpecific
  autocmd!
  autocmd Filetype xml let b:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<': '>'}
augroup END
" }}}

" eraseSubword {{{
Plug 'vim-scripts/eraseSubword'

let g:EraseSubword_insertMap = '<C-B>'
" }}}

" tcomment_vim {{{
Plug 'tomtom/tcomment_vim'
" }}}

" vim-subversive {{{
Plug 'svermeulen/vim-subversive'

nmap s <Plug>(SubversiveSubstitute)
nmap ss <Plug>(SubversiveSubstituteLine)
nmap sS <Plug>(SubversiveSubstituteToEndOfLine)

nmap <Leader>s <Plug>(SubversiveSubstituteRange)
xmap <Leader>s <Plug>(SubversiveSubstituteRange)
nmap <Leader>ss <Plug>(SubversiveSubstituteWordRange)

nmap <Leader>cr <Plug>(SubversiveSubstituteRangeConfirm)
xmap <Leader>cr <Plug>(SubversiveSubstituteRangeConfirm)
nmap <Leader>crr <Plug>(SubversiveSubstituteWordRangeConfirm)

nmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
xmap <Leader><Leader>s <Plug>(SubversiveSubvertRange)
nmap <Leader><Leader>ss <Plug>(SubversiveSubvertWordRange)

" ie = inner entire buffer
onoremap ie :exec "normal! ggVG"<CR>

" iv = current viewable text in the buffer
onoremap iv :exec "normal! HVL"<CR>

" Quick substitute from system clipboard
nmap =s "+<Plug>(SubversiveSubstitute)
nmap =ss "+<Plug>(SubversiveSubstituteLine)
nmap =sS "+<Plug>(SubversiveSubstituteToEndOfLine)
" }}}

Plug 'editorconfig/editorconfig-vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" }}}

" Text Objects {{{
" ====================================================================
Plug 'kana/vim-textobj-user'

" vim-textobj-function {{{
Plug 'kana/vim-textobj-function'

" Search in function
map <Space>sF :call vimrc#incsearch#clear_nohlsearch()<CR>vaf<M-/>

" }}}

Plug 'michaeljsmith/vim-indent-object'
Plug 'coderifous/textobj-word-column.vim'
" }}}

" Languages {{{
" ====================================================================
" emmet {{{
Plug 'mattn/emmet-vim'

let g:user_emmet_leader_key = '<C-E>'
" }}}

" cscope-macros.vim {{{
Plug 'mars90226/cscope_macros.vim'

nnoremap <F11> :call <SID>generate_cscope_files()<CR>
function! s:generate_cscope_files()
  !find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.h' -o -iname '*.hpp' > cscope.files ;
  !cscope -b -i cscope.files -f cscope.out
  cscope kill -1
  cscope add cscope.out
endfunction
" }}}

" vim-seeing-is-believing {{{
Plug 'hwartig/vim-seeing-is-believing', { 'for': 'ruby' }

augroup seeingIsBelievingSettings
  autocmd!
  autocmd FileType ruby call s:seeing_is_believing_settings()
augroup END

function! s:seeing_is_believing_settings()
  nmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)
  xmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)

  nmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  xmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  imap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)

  nmap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
  imap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
endfunction
" }}}

" syntastic {{{
if vimrc#plugin#is_enabled_plugin('syntastic')
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
  nnoremap <Space><F7> :SyntasticCheck<CR>
  command! -bar SyntasticCheckHeader call s:SyntasticCheckHeader()
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
if vimrc#plugin#is_enabled_plugin('ale')
  Plug 'w0rp/ale'

  " let g:ale_linters = {
  "       \ 'c': ['gcc', 'ccls'],
  "       \ 'cpp': ['g++', 'ccls'],
  "       \ 'javascript': ['eslint', 'jshint', 'flow', 'flow-language-server']
  "       \}
  " Disable language server in ale, prefer coc.nvim
  let g:ale_linters = {
        \ 'c': ['gcc'],
        \ 'cpp': ['g++'],
        \ 'javascript': ['eslint', 'jshint'],
        \ 'python': ['pylint'],
        \ 'sh': ['shell', 'shellcheck']
        \}
  let g:ale_fixers = {
        \ 'javascript': [ 'eslint' ],
        \ 'css': [
        \   'prettier',
        \   'stylelint'
        \ ],
        \ 'scss': [
        \   'prettier',
        \   'stylelint'
        \ ]
        \}
  " Depend on project whether to use flow locally
  " let g:ale_javascript_flow_use_global = 1
  " let g:ale_javascript_flow_ls_use_global = 1
  let g:ale_pattern_options = {
        \ 'configure': {
        \   'ale_enabled': 0
        \ }
        \}

  nmap ]a <Plug>(ale_next_wrap)
  nmap [a <Plug>(ale_previous_wrap)
  nmap ]A <Plug>(ale_first)
  nmap [A <Plug>(ale_last)
  nmap <Leader>aa <Plug>(ale_toggle_buffer)
  nmap <Leader>aA <Plug>(ale_toggle)
  nmap <Leader>ad <Plug>(ale_detail)
  nmap <Leader>af <Plug>(ale_fix)
  nmap <Leader>ag <Plug>(ale_go_to_definition)
  nmap <Leader>aG <Plug>(ale_go_to_definition_in_tab)
  nmap <Leader>ah <Plug>(ale_hover)
  nmap <Leader>ai :ALEInfo<CR>
  nmap <Leader>al <Plug>(ale_lint)
  nmap <Leader>ar <Plug>(ale_find_references)
  nmap <Leader>as :execute 'ALESymbolSearch ' . input('Symbol: ')<CR>
  nmap <Leader>aS :ALEStopAllLSPs<CR>
  nmap <Leader>at <Plug>(ale_go_to_type_definition)
  nmap <Leader>aT <Plug>(ale_go_to_type_definition_in_tab)
end
" }}}

" markdown-preview.vim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.vim')
  Plug 'iamcco/markdown-preview.vim'
endif
" }}}

" markdown-preview.nvim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.nvim')
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
endif
" }}}

" vim-markdown-composer {{{
if executable('cargo')
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  endfunction

  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

  " Manually execute :ComposerStart instead
  let g:markdown_composer_autostart = 0
endif
" }}}

" vim-go {{{
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

let g:go_decls_mode = 'fzf'

" TODO Add key mappings for vim-go commands
" }}}

" vim-polyglot {{{
Plug 'sheerun/vim-polyglot'

" Avoid conflict with vim-go, must after vim-go loaded
let g:polyglot_disabled = ['go']
" }}}

" tern_for_vim {{{
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }

augroup tern_for_vim_settings
  autocmd!
  autocmd FileType javascript call s:tern_for_vim_settings()
augroup END

function! s:tern_for_vim_settings()
  nnoremap <silent><buffer> <C-X><C-K> :TernDoc<CR>
  nnoremap <silent><buffer> <C-X><C-B> :TernDocBrowse<CR>
  nnoremap <silent><buffer> <C-X><C-T> :TernType<CR>
  " To avoid accidentally delete
  nnoremap <silent><buffer> <C-X><C-D> :TernDef<CR>
  nnoremap <silent><buffer> <C-X><C-P> :TernDefPreview<CR>
  nnoremap <silent><buffer> <C-X><C-S> :TernDefSplit<CR>
  nnoremap <silent><buffer> <C-X><C-N> :TernDefTab<CR>
  nnoremap <silent><buffer> <C-X>c :TernRefs<CR>
  nnoremap <silent><buffer> <C-X><C-R> :TernRename<CR>
endfunction
" }}}

" jedi-vim {{{
if vimrc#plugin#check#has_jedi()
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }

  let g:jedi#completions_enabled = 1

  let g:jedi#goto_command             = "<C-X><C-G>"
  let g:jedi#goto_assignments_command = "<C-X>a"
  let g:jedi#goto_definitions_command = "<C-X><C-D>"
  let g:jedi#documentation_command    = "<C-X><C-K>"
  let g:jedi#usages_command           = "<C-X>c"
  let g:jedi#completions_command      = "<C-X><C-X>"
  let g:jedi#rename_command           = "<C-X><C-R>"

  augroup jedi_vim_settings
    autocmd!
    autocmd FileType python call s:jedi_vim_settings()
  augroup END

  function! s:jedi_vim_settings()
    nnoremap <silent><buffer> <C-X><C-L> :call jedi#remove_usages()<CR>
    nnoremap <silent><buffer> <C-X><C-N> :tab split <Bar> call jedi#goto()<CR>
  endfunction
endif
" }}}

Plug 'moll/vim-node', { 'for': [] }
Plug 'tpope/vim-rails', { 'for': [] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" Plug 'amadeus/vim-jsx', { 'for': 'jsx' } " It's included in vim-polyglot
Plug 'scrooloose/vim-slumlord'
Plug 'mars90226/perldoc-vim'
Plug 'gyim/vim-boxdraw'
Plug 'fs111/pydoc.vim'
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

nnoremap <silent> <Leader>g` :call vimrc#fugitive#review_last_commit()<CR>

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd FileType fugitive call vimrc#fugitive#mappings()
  autocmd FileType git      call vimrc#fugitive#git_mappings()
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

let g:fugitive_gitlab_domains = ['https://git.synology.com']

" Borrowed and modified from vim-fugitive s:Dispatch
command! -nargs=* GitDispatch call vimrc#fugitive#git_dispatch(<q-args>)
" }}}

" vim-gitgutter {{{
Plug 'airblade/vim-gitgutter'

nmap <silent> [h <Plug>GitGutterPrevHunk
nmap <silent> ]h <Plug>GitGutterNextHunk
nnoremap cog :GitGutterToggle<CR>
nnoremap <Leader>gt :GitGutterAll<CR>

omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

command! -nargs=* GVA GV --all <args>

augroup gv_settings
  autocmd!
  autocmd FileType GV call vimrc#gv#mappings()
augroup END
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

" Add '' to open tig main view
nnoremap \tr :Tig ''<CR>
nnoremap \tt :tabnew <Bar> Tig ''<CR>
nnoremap \ts :new    <Bar> Tig ''<CR>
nnoremap \tv :vnew   <Bar> Tig ''<CR>

function! s:tig_log(opts, bang, is_current_file)
  execute 'Tig log ' . (a:bang ? '-p ' : '') . a:opts . (a:is_current_file ? ' -- ' . expand('%:p') : '')
endfunction
command! -bang -nargs=* TigLog          call s:tig_log(<q-args>, <bang>0, 0)
command! -bang -nargs=* TigLogSplit     split | call s:tig_log(<q-args>, <bang>0, 0)
command! -bang -nargs=* TigLogFile      call s:tig_log(<q-args>, <bang>0, 1)
command! -bang -nargs=* TigLogFileSplit split | call s:tig_log(<q-args>, <bang>0, 1)
" Add non-follow version as --follow will include many merge commits
nnoremap \tl :TigLogFileSplit!<CR>
nnoremap \tL :TigLogFileSplit! --follow<CR>
nnoremap \t<C-L> :execute 'TigLogSplit! $(git log --format=format:%H --follow -- ' . expand('%:p') . ')'<CR>
" }}}

" Gina {{{
Plug 'lambdalisue/gina.vim'

nnoremap <Space>gb :Gina branch<CR>
nnoremap <Space>gB :Gina blame<CR>
xnoremap <Space>gB :Gina blame<CR>
" }}}

" git-p.nvim {{{
" Disable git-p.nvim in nested neovim due to channel error
if vimrc#plugin#is_enabled_plugin('git-p.nvim')
  Plug 'iamcco/sran.nvim', { 'do': { -> sran#util#install() } }
  Plug 'iamcco/git-p.nvim'

  nmap <Leader>gp <Plug>(git-p-diff-preview)

  highlight! link GitPBlameLine GruvboxFg4
  highlight! link GitPAdd GruvboxGreenSign
  highlight! link GitPModify GruvboxAquaSign
  highlight! link GitPDelete GruvboxRedSign
endif
" }}}

Plug 'mattn/gist-vim'
" }}}

" Utility {{{
" ====================================================================
" vim-mundo {{{
if vimrc#plugin#is_enabled_plugin('vim-mundo')
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle' }

  if has("python3")
    let g:mundo_prefer_python3 = 1
  endif

  nnoremap <F9> :MundoToggle<CR>
endif
" }}}

" vim-unimpaired {{{
Plug 'tpope/vim-unimpaired', { 'on': [] }

call vimrc#lazy#lazy_load('unimpaired')

" Ignore [a, ]a, [A, ]A for ale
let g:nremap = {"[a": "", "]a": "", "[A": "", "]A": ""}

nmap \[u  <Plug>unimpaired_url_encode
nmap \[uu <Plug>unimpaired_line_url_encode
nmap \]u  <Plug>unimpaired_url_decode
nmap \]uu <Plug>unimpaired_line_url_decode

nnoremap coc :set termguicolors!<CR>
nnoremap coe :set expandtab!<CR>
nnoremap com :set modifiable!<CR>
nnoremap coo :set readonly!<CR>
nnoremap cop :set paste!<CR>
" }}}

" vim-characterize {{{
Plug 'tpope/vim-characterize'

nmap gA <Plug>(characterize)
" }}}

" vim-peekaboo {{{
Plug 'junegunn/vim-peekaboo'

let g:peekaboo_window = 'vertical botright ' . float2nr(&columns * 0.3) . 'new'
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
let g:rooter_patterns = ['Cargo.toml', '.git/']
nnoremap <Leader>r :Rooter<CR>
" }}}

" vimwiki {{{
Plug 'vimwiki/vimwiki'

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
  let g:neoterm_size = &lines / 2

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

" vim-qfreplace {{{
Plug 'thinca/vim-qfreplace'

augroup qfreplace_settings
  autocmd!
  autocmd FileType qf call s:qfreplace_settings()
augroup END

function! s:qfreplace_settings()
  nnoremap <silent><buffer> r :<C-U>Qfreplace<CR>
endfunction
" }}}

" vim-caser {{{
Plug 'arthurxavierx/vim-caser'
" }}}

" vim-highlightedyank {{{
if vimrc#plugin#is_enabled_plugin('vim-highlightedyank')
  Plug 'machakann/vim-highlightedyank'

  let g:highlightedyank_highlight_duration = 200
endif
" }}}

" goyo.vim {{{
Plug 'junegunn/goyo.vim'

nnoremap <Leader>gy :Goyo<CR>
" }}}

" limelight.vim {{{
Plug 'junegunn/limelight.vim'

nnoremap <Leader><C-L> :Limelight!!<CR>
" }}}

" vim-dispatch {{{
Plug 'tpope/vim-dispatch'

nnoremap <Leader>co :Copen<CR>
" }}}

" securemodelines {{{
" See https://www.reddit.com/r/vim/comments/bwp7q3/code_execution_vulnerability_in_vim_811365_and/
" and https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md for more details
Plug 'ciaranm/securemodelines'
" }}}

Plug 'tpope/vim-dadbod', { 'on': 'DB' }
Plug 'tyru/open-browser.vim'
Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert', 'S'] }
Plug 'will133/vim-dirdiff', { 'on': 'DirDiff' }
Plug 'AndrewRadev/linediff.vim', { 'on': 'Linediff' }
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
Plug 'tweekmonster/helpful.vim'
Plug 'tweekmonster/startuptime.vim'

" " nvim-gdb {{{
" Disabled for now as neovim's neovim_gdb.vim seems not exists
" if has("nvim")
"   Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
" endif

" " }}}

" }}}

" Plugin Settings End {{{
" vim-plug
call plug#end()
" }}}

" Post-loaded Plugin Settings {{{
" TODO Move all plugin settings to post-loaded settings

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  " Common source
  call coc#add_extension('coc-dictionary')
  call coc#add_extension('coc-tag')
  call coc#add_extension('coc-emoji')
  call coc#add_extension('coc-syntax')
  call coc#add_extension('coc-neosnippet')
  call coc#add_extension('coc-highlight')
  call coc#add_extension('coc-emmet')

  " Language server
  call coc#add_extension('coc-json')
  call coc#add_extension('coc-tsserver')
  call coc#add_extension('coc-python')
  " Not work right now
  " call coc#add_extension('coc-ccls')
  call coc#add_extension('coc-rls')

  " Misc
  call coc#add_extension('coc-prettier')
endif
" }}}

" deoplete.nvim {{{
if vimrc#plugin#is_enabled_plugin('deoplete.nvim')
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)
endif
" }}}

" Unite {{{
augroup post_loaded_unite_mappings
  autocmd!
  autocmd VimEnter * call vimrc#unite#post_loaded_mappings()
augroup END
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  " Use fd for file/rec and ripgrep for grep
  if executable('fd')
    call denite#custom#var('file/rec', 'command',
        \ ['fd', '--type', 'file', '--follow', '--hidden', '--exclude', '.git', ''])
  elseif executable('rg')
    call denite#custom#var('file/rec', 'command',
          \ ['rg', '--files', '--glob', '!.git'])
  elseif executable('ag')
    call denite#custome#var('file/rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  endif

  if executable('rg')
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--no-heading', '-S'])
  endif

  " Denite options
  call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
  call denite#custom#source('default', 'sorters', ['sorter/rank'])
  call denite#custom#source('grep', 'converters', ['converter/abbr_word'])

  call denite#custom#option('_', {
        \ 'auto_accel': v:true,
        \ 'reversed': 1,
        \ 'prompt': '❯',
        \ 'prompt_highlight': 'Function',
        \ 'highlight_mode_normal': 'Visual',
        \ 'highlight_mode_insert': 'CursorLine',
        \ 'highlight_matched_char': 'Special',
        \ 'highlight_matched_range': 'Normal',
        \ 'vertical_preview': 1,
        \ 'start_filter': 1,
        \ })
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin("defx")
  call defx#custom#option('_', {
        \ 'columns': 'git:mark:indent:icon:filename:type:size:time',
        \ 'show_ignored_files': 1,
        \ })
  call defx#custom#column('icon', {
        \ 'directory_icon': '▸',
        \ 'opened_icon': '▾',
        \ 'root_icon': ' ',
        \ })
  call defx#custom#column('mark', {
        \ 'readonly_icon': '✗',
        \ 'selected_icon': '✓',
        \ })
  call defx#custom#column('time', {'format': '%Y/%m/%d %H:%M'})
endif
" }}}

" Gina {{{
call gina#custom#mapping#nmap(
        \ '/\%(blame\|commit\|status\|branch\|ls\|grep\|changes\|tag\)',
        \ 'q', ':<C-U> q<CR>', {'noremap': 1, 'silent': 1},
        \)

call extend(g:gina#command#browse#translation_patterns, {
      \ 'git.synology.com': [
      \   [
      \     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \   ], {
      \     'root':  'https://\1/\2/\3/tree/%r1/',
      \     '_':     'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-}le',
      \     'exact': 'https://\1/\2/\3/blob/%h1/%pt%{#L|}ls%{-}le',
      \   },
      \ ],
      \})
" }}}

" Arpeggio {{{
call arpeggio#load()

" Quickly escape insert mode
Arpeggio inoremap jk <Esc>
" }}}
" }}}

" General Settings {{{
" ====================================================================
" Vim basic setting {{{
set nocompatible

" source mswin.vim
if vimrc#plugin#check#get_os() !~ "synology"
  source $VIMRUNTIME/mswin.vim
  " TODO Fix this in Linux
  behave mswin

  if has("gui")
    " Fix CTRL-F in gui will popup find window problem
    silent! unmap <C-F>
    silent! iunmap <C-F>
    silent! cunmap <C-F>
  endif

  " Unmap CTRL-A for selecting all
  silent! unmap <C-A>
  silent! iunmap <C-A>
  silent! cunmap <C-A>

  " Unmap CTRL-Z for undo
  silent! unmap <C-Z>
  silent! iunmap <C-Z>

  " Unmap CTRL-Z for redo
  silent! unmap <C-Y>
  silent! iunmap <C-Y>
endif
" }}}

set number
set hidden
set lazyredraw
set mouse=a
set modeline
set updatetime=100 " default: 4000
set cursorline
set ruler " show the cursor position all the time

set scrolloff=0

set diffopt=filler,vertical
if has("patch-8.0.1361")
  set diffopt+=hiddenoff
endif

" completion menu
set pumheight=40
if exists('&pumblend')
  set pumblend=0
endif

" ignore pattern for wildmenu
set wildmenu
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
" wildoptions=pum added in 'NVIM v0.4.0-401-g5c836d2ef'
if has("nvim-0.4.0") && s:get_nvim_patch_version() > 401
  set wildmode=full
  silent! set wildoptions+=pum
else
  set wildmode=list:longest,full
endif
set wildoptions+=tagfile

" fillchars
set fillchars=diff:⣿,fold:-,vert:│

" show hidden characters
set list
set listchars=tab:▸\ ,trail:•,extends:»,precedes:«,nbsp:␣

set laststatus=2
set showcmd

" no distraction
if has("balloon_eval")
  set noballooneval
endif
set belloff=all

" move temporary files
set backup " keep a backup file (restore to previous version)
set backupdir^=~/.vimtmp
if has("nvim")
  set undofile
else " neovim has default folders for these files
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

if !has("nvim")
  set t_Co=256
endif

" Fold
" Borrowed from https://superuser.com/questions/990296/how-to-change-the-way-that-vim-displays-collapsed-folded-lines
function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
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
" syntax
" Check if syntax is on and only switch on syntax when it's off
" due to git-p preview loses highlight after `:syntax on`
if !exists('g:syntax_on')
  syntax on
endif
" lowering the value to improve performance on long line
set synmaxcol=1500  " default: 3000, 0: unlimited

" filetype
filetype on
filetype plugin on
filetype indent on

if !exists('g:loaded_color')
  let g:loaded_color = 1

  set background=dark

  if !exists("g:gui_oni")
    colorscheme gruvbox
  endif

  highlight Pmenu ctermfg=187 ctermbg=239
  highlight PmenuSel ctermbg=95
endif

" TODO Need to test in Windows
if has('nvim') && has('termguicolors')
  set termguicolors
endif

" highlighting strings inside C comments.
let c_comment_strings = 1
" }}}

" Key Mappings {{{
" ====================================================================
" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" CTRL-L clear hlsearch
nnoremap <C-L> <C-L>:nohlsearch<CR>

" Add key mapping for suspend
nnoremap <Space><C-Z> :suspend<CR>

" Quickly switch window {{{
nnoremap <M-h> <C-W>h
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-l> <C-W>l

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
nnoremap <C-J> gT
nnoremap <C-K> gt

nnoremap QQ :call <SID>QuitTab()<CR>
nnoremap g4 :tablast<CR>
function! s:QuitTab()
  try
    tabclose
  catch /E784/ " Can't close last tab
    qall
  endtry
endfunction
" }}}

" Quickly adjust window size
nnoremap <C-W><Space>- <C-W>10-
nnoremap <C-W><Space>+ <C-W>10+
nnoremap <C-W><Space>< <C-W>10<
nnoremap <C-W><Space>> <C-W>10>
nnoremap <C-W><Space>= :call <SID>window_equal()<CR>
function! s:window_equal()
  windo setlocal nowinfixheight nowinfixwidth
  wincmd =
endfunction

" Move tab
nnoremap <Leader>t< :tabmove -1<CR>
nnoremap <Leader>t> :tabmove +1<CR>

" Create new line in insert mode
inoremap <M-o> <C-O>o
inoremap <M-S-o> <C-O>O

" Go to matched bracket in insert mode
imap <M-5> <C-O>%

" Create new line without indent & prefix
nnoremap <M-o> o <C-U>
nnoremap <M-S-o> O <C-U>

" Save
nnoremap <C-S> :update<CR>

" Quit
nnoremap <Space>q :q<CR>
nnoremap <Space>Q :qa!<CR>

" Quick execute
if vimrc#plugin#check#get_os() =~ "windows"
  " Win32
  "nnoremap <Leader>x :execute ':! "'.expand('%').'"'<CR>
  nnoremap <Leader>x :!start cmd /c "%:p"<CR>
  nnoremap <Leader>X :!start cmd /K cd /D %:p:h<CR>
  nnoremap <Leader>E :execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'<CR>
else
  " Linux
  nnoremap <Leader>x :!xdg-open "%:p"<CR>

  if has('nvim')
    nnoremap <Leader>x :terminal xdg-open "%:p"<CR>
  endif
endif

" Easier file status
nnoremap <Space><C-G> 2<C-G>

" Move working directory up
nnoremap <Leader>u :cd ..<CR>

" Move working directory to current buffer's parent folder
nnoremap <Leader>cb :cd %:h<CR>

" Quick yank cursor word
nnoremap y' ""yiw
nnoremap y" ""yiW
nnoremap y= "+yiw
nnoremap y+ "+yiW

" Quick yank/paste to/from system clipboard
nnoremap =y "+y
xnoremap =y "+y
nnoremap +p "+p
xnoremap +p "+p
nnoremap +P "+P
xnoremap +P "+P
nnoremap +[p "+[p
nnoremap +]p "+]p

" Quick yank filename
nnoremap <Leader>y5 :let @" = expand('%:t:r')<CR>
nnoremap <Leader>y% :let @" = @%<CR>
nnoremap <Leader>y4 :let @" = expand('%:p')<CR>

" Quick split
nnoremap <Leader>yt :tab split<CR>
nnoremap <Leader>ys :split<CR>
nnoremap <Leader>yv :vertical split<CR>

" Copy unnamed register to system clipboard
nnoremap <Space>sr :let @+ = @"<CR>

" Command line mapping
cnoremap <expr> <C-G><C-F> vimrc#fzf#files_in_commandline()
cnoremap <expr> <C-G><C-T> vimrc#rg_current_type_option()
" <C-]> and <C-%> is the same key
cnoremap <expr> <C-G><C-]> expand('%:t:r')
" <C-\> and <C-$> is the same key
cnoremap <expr> <C-G><C-\> expand('%:p')
" For grepping word
cnoremap <expr> <C-G><C-W> "\\b" . expand('<cword>') . "\\b"
cnoremap <expr> <C-G><C-A> "\\b" . expand('<cWORD>') . "\\b"
" Fugitive commit sha
cnoremap <expr> <C-G><C-Y> vimrc#fugitive#commit_sha()

" Ex mode for special buffer that map 'q' as ':quit'
nnoremap \q: q:
nnoremap \q/ q/
nnoremap \q? q?

" s:execute_command() for executing command with query
" TODO input completion
function! s:execute_command(command, prompt)
  let query = input(a:prompt)
  if query != ''
    execute a:command . ' ' . query
  else
    echomsg 'Cancelled!'
  endif
endfunction

" Man
" :Man is defined in $VIMRUNTIME/plugin/man.vim which is loaded after .vimrc
" TODO Move this to 'after' folder
if has('nvim')
  nnoremap <Leader><F1> :Man 
endif

" sdcv
if executable('sdcv')
  nnoremap <Leader>sd :execute '!sdcv ' . expand('<cword>')<CR>
  nnoremap <Space>sd :call <SID>execute_command('!sdcv', 'sdcv: ')<CR>
endif

" Quickfix & Locaiton List {{{
augroup quickfixSettings
  autocmd!
  autocmd FileType qf call vimrc#quickfix#mappings()
augroup END
" }}}

" Custom function {{{
" This cannot be moved to autoload, because sid will change when <sfile> change
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'),
        \ '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
let g:sid = s:SID_PREFIX()

nnoremap <F6> :call vimrc#toggle_indent()<CR>
nnoremap <F7> :call vimrc#toggle_fold()<CR>

" LastTab
command! -count -bar LastTab call vimrc#last_tab(<count>)
nnoremap <M-1> :call vimrc#last_tab(v:count)<CR>

augroup last_tab_settings
  autocmd!
  autocmd TabLeave * call vimrc#insert_last_tab(tabpagenr())
augroup END

" Zoom
nnoremap <silent> <Leader>z :call vimrc#zoom()<CR>
xnoremap <silent> <Leader>z :<C-U>call vimrc#zoom_selected(vimrc#get_visual_selection())<CR>

" Toggle parent folder tag
command! ToggleParentFolderTag call vimrc#toggle_parent_folder_tag()
nnoremap <silent> <Leader>p :ToggleParentFolderTag<CR>

" Display file size
command! -nargs=1 -complete=file FileSize call vimrc#file_size(<q-args>)

" Set tab size
command! -nargs=1 SetTabSize call vimrc#set_tab_size(<q-args>)

command! GetCursorSyntax echo vimrc#get_cursor_syntax()

" Find the cursor
command! FindCursor call vimrc#blink_cursor_location()

if executable('tmux')
  command! RefreshDisplay call vimrc#refresh_display()
endif
" }}}

" Custom command {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" Delete inactive buffers
command! -bang Bdi call vimrc#delete_inactive_buffers(0, <bang>0)
command! -bang Bwi call vimrc#delete_inactive_buffers(1, <bang>0)
nnoremap <Leader>D :Bdi<CR>
nnoremap <Leader><C-D> :Bdi!<CR>
nnoremap <Leader>Q :Bwi<CR>
nnoremap <Leader><C-Q> :Bwi!<CR>

command! TrimWhitespace call vimrc#trim_whitespace()

command! GetChar call vimrc#getchar()

command! ReloadVimrc call vimrc#reload#reload()

if vimrc#plugin#check#get_os() !~ "windows"
  command! Args echo system("ps -o command= -p " . getpid())
endif
" }}}
" }}}

" Terminal {{{
" ====================================================================
" xterm-256 in Windows {{{
if !has("nvim") && !has("gui_running") && vimrc#plugin#check#get_os() =~ "windows"
  set term=xterm
  set mouse=a
  set t_Co=256
  let &t_AB = "\e[48;5;%dm"
  let &t_AF = "\e[38;5;%dm"
  colorscheme gruvbox
  highlight Pmenu ctermfg=187 ctermbg=239
  highlight PmenuSel ctermbg=95
endif
" }}}

" Pair up with 'set winaltkeys=no' in _gvimrc
" Fix meta key in vim
" terminal meta key fix {{{
if !has("nvim") && !has("gui_running") && vimrc#plugin#check#get_os() !~ "windows"
  if vimrc#plugin#check#get_os() =~ "windows"
    " Windows Terminal keycode will change after startup
    " Maybe it's related to ConEmu
    " This fix will not work after reload .vimrc/_vimrc
    augroup WindowsTerminalKeyFix
      autocmd!
      autocmd VimEnter *
            \ set <M-a>=a |
            \ set <M-c>=c |
            \ set <M-h>=h |
            \ set <M-g>=g |
            \ set <M-j>=j |
            \ set <M-k>=k |
            \ set <M-l>=l |
            \ set <M-n>=n |
            \ set <M-o>=o |
            \ set <M-p>=p |
            \ set <M-s>=s |
            \ set <M-t>=t |
            \ set <M-/>=/ |
            \ set <M-?>=? |
            \ set <M-]>=] |
            \ set <M-`>=` |
            \ set <M-1>=1 |
            \ set <M-S-o>=O
    augroup END
  else
    set <M-a>=a |
    set <M-c>=c |
    set <M-h>=h |
    set <M-g>=g |
    set <M-j>=j |
    set <M-k>=k |
    set <M-l>=l |
    set <M-n>=n |
    set <M-o>=o |
    set <M-p>=p |
    set <M-s>=s |
    set <M-t>=t |
    set <M-/>=/ |
    set <M-?>=? |
    set <M-]>=] |
    set <M-`>=` |
    set <M-1>=1 |
    set <M-S-o>=O
  endif
endif
" }}}

" neovim terminal key mapping and settings
if has("nvim")
  " Set terminal buffer size to unlimited
  set scrollback=100000

  " For quick terminal access
  nnoremap <silent> <Leader>tr :terminal<CR>i
  nnoremap <silent> <Leader>tt :tabnew <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>ts :new    <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>tv :vnew   <Bar> :terminal<CR>i

  " Quick terminal function
  tnoremap <M-F1> <C-\><C-N>
  tnoremap <M-F2> <C-\><C-N>:tabnew<CR>:terminal<CR>i
  tnoremap <M-F3> <C-\><C-N>:Windows<CR>

  " Quickly switch window in terminal
  tnoremap <M-S-h> <C-\><C-N><C-W>h
  tnoremap <M-S-j> <C-\><C-N><C-W>j
  tnoremap <M-S-k> <C-\><C-N><C-W>k
  tnoremap <M-S-l> <C-\><C-N><C-W>l

  " Quickly switch tab in terminal
  tnoremap <M-C-J> <C-\><C-N>gT
  tnoremap <M-C-K> <C-\><C-N>gt

  " Quickly switch to last tab in terminal
  tnoremap <M-1> <C-\><C-N>:LastTab<CR>

  " Quickly paste from register
  tnoremap <expr> <M-r> '<C-\><C-N>"' . nr2char(getchar()) . 'pi'

  " Quickly suspend neovim
  tnoremap <M-C-Z> <C-\><C-N>:suspend<CR>

  " For nested neovim {{{
    " Use <M-q> as prefix

    " Quick terminal function
    tnoremap <M-q>1 <C-\><C-\><C-N>
    tnoremap <M-q>2 <C-\><C-\><C-N>:tabnew<CR>:terminal<CR>i
    tnoremap <M-q>3 <C-\><C-\><C-N>:Windows<CR>

    " Quickly switch window in terminal
    tnoremap <M-q><M-h> <C-\><C-\><C-N><C-W>h
    tnoremap <M-q><M-j> <C-\><C-\><C-N><C-W>j
    tnoremap <M-q><M-k> <C-\><C-\><C-N><C-W>k
    tnoremap <M-q><M-l> <C-\><C-\><C-N><C-W>l

    " Quickly switch tab in terminal
    tnoremap <M-q><C-J> <C-\><C-\><C-N>gT
    tnoremap <M-q><C-K> <C-\><C-\><C-N>gt

    " Quickly switch to last tab in terminal
    tnoremap <M-q><M-1> <C-\><C-\><C-N>:LastTab<CR>

    " Quickly paste from register
    tnoremap <expr> <M-q><M-r> '<C-\><C-\><C-N>"' . nr2char(getchar()) . 'pi'

    " Quickly suspend neovim
    tnoremap <M-q><C-Z> <C-\><C-\><C-N>:suspend<CR>
  " }}}

  augroup terminal_settings
    autocmd!
    autocmd TermOpen * call vimrc#terminal#settings()

    " TODO Start insert mode when cancelling :Windows in terminal mode or
    " selecting another terminal buffer
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Ignore fzf, ranger, coc
    autocmd TermClose term://*
          \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
          \   call nvim_input('<CR>')  |
          \ endif
  augroup END

  " Search keyword with Google using surfraw {{{
  if executable('sr')
    command! -nargs=1 GoogleKeyword call s:google_keyword(<q-args>)
    function! s:google_keyword(keyword)
      new
      terminal
      startinsert
      call nvim_input('sr google ' . a:keyword . "\n")
    endfunction
    nnoremap <Leader>kk :execute 'GoogleKeyword ' . expand('<cword>')<CR>
  endif
  " }}}
endif
" }}}

" Autocommands {{{
" ====================================================================
" Put these in an autocmd group, so that we can delete them easily.
augroup lastPositionSetting
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END

augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost _vimrc nested call vimrc#reload#reload() | e | normal! zzzv
  autocmd BufWritePost .vimrc nested call vimrc#reload#reload() | e | normal! zzzv
augroup END

augroup fileTypeSpecific
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " Rack
  autocmd BufNewFile,BufReadPost *.ru                 set filetype=ruby

  " gdb
  autocmd BufNewFile,BufReadPost *.gdbinit            set filetype=gdb

  " gitcommit
  autocmd FileType gitcommit setlocal spell complete+=k

  " Custom filetype
  autocmd BufNewFile,BufReadPost *maillog             set filetype=messages
  autocmd BufNewFile,BufReadPost *maillog.*.xz        set filetype=messages
  autocmd BufNewFile,BufReadPost *conf                set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local          set filetype=conf
  autocmd BufNewFile,BufReadPost *conf.local.override set filetype=conf
  autocmd BufNewFile,BufReadPost *.cf                 set filetype=conf
  autocmd BufNewFile,BufReadPost .gitignore           set filetype=conf
  autocmd BufNewFile,BufReadPost .ignore              set filetype=conf
  autocmd BufNewFile,BufReadPost */conf/template/*    set filetype=conf
  autocmd BufNewFile,BufReadPost */rspamd/*.inc       set filetype=conf
  autocmd BufNewFile,BufReadPost */upstart/*conf      set filetype=upstart
  autocmd BufNewFile,BufReadPost *.upstart            set filetype=upstart
  autocmd BufNewFile,BufReadPost Makefile.inc         set filetype=make
  autocmd BufNewFile,BufReadPost depends              set filetype=dosini
  autocmd BufNewFile,BufReadPost depends-virtual-*    set filetype=dosini
  autocmd BufNewFile,BufReadPost .tmux.conf           set filetype=tmux
  autocmd BufNewFile,BufReadPost resource             set filetype=json
  autocmd BufNewFile,BufReadPost *.bashrc             set filetype=sh

  " Custom build log syntax
  autocmd BufNewFile,BufReadPost *.build              set filetype=cerr

  " FileType settings
  autocmd FileType vim call s:filetype_vim_settings()
  autocmd FileType python call s:filetype_python_settings()
augroup END

function! s:filetype_vim_settings()
  setlocal shiftwidth=2
  setlocal tabstop=2
  setlocal softtabstop=2
  setlocal expandtab
endfunction

function! s:filetype_python_settings()
  setlocal shiftwidth=4
  setlocal tabstop=4
  setlocal softtabstop=4
  setlocal expandtab

  nnoremap <silent><buffer> K :call vimrc#coc#show_documentation()<CR>
  nnoremap <silent><buffer> gK :execute 'Pydoc ' . expand('<cword>')<CR>
endfunction
" }}}

" Fix and Workarounds {{{
" ====================================================================
" Prevent CTRL-F to abort the selection (in visual mode)
" This is caused by $VIM/_vimrc ':behave mswin' which sets 'keymodel' to
" include 'stopsel' which means that non-shifted special keys stop selection.
set keymodel=startsel

" disable Background Color Erase (BC) by clearing the `t_ut` on Synology DSM
" see https://sunaku.github.io/vim-256color-bce.html
if vimrc#plugin#check#get_os() =~ "synology" && !has("nvim")
  set t_ut=
endif

" Backspace in ConEmu will translate to 0x07F when using xterm
" https://conemu.github.io/en/VimXterm.html
" https://github.com/Maximus5/ConEmu/issues/641
if !empty($ConEmuBuild) && !has("nvim")
  let &t_kb = nr2char(127)
  let &t_kD = "^[[3~"

  " Disable Background Color Erase
  set t_ut=
endif

" Since NVIM v0.4.0-464-g5eaa45547, commit 5eaa45547975c652e594d0d6dbe34c1316873dc7
" 'secure' is set when 'modeline' is set, which will cause a lot of commands
" cannot run in autocmd when opening help page.
augroup secure_modeline_conflict_workaround
  autocmd!
  autocmd FileType help setlocal nomodeline
augroup END
" }}}

" vim: set sw=2 ts=2 sts=2 et foldlevel=0 foldmethod=marker:
