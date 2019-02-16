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
" enabled plugin management {{{
let s:plugin_disabled = []

function! s:disable_plugin(plugin)
  call add(s:plugin_disabled, a:plugin)
endfunction

function! s:disable_plugins(plugins)
  let s:plugin_disabled += a:plugins
endfunction

function! s:enable_plugin(plugin)
  let l:idx = index(s:plugin_disabled, a:plugin)

  if l:idx != -1
    call remove(s:plugin_disabled, l:idx)
  end
endfunction

function! s:is_disabled_plugin(plugin)
  return index(s:plugin_disabled, a:plugin) != -1
endfunction

function! s:is_enabled_plugin(plugin)
  return index(s:plugin_disabled, a:plugin) == -1
endfunction

function! s:get_disabled_plugins()
  echo s:plugin_disabled
endfunction
command! ListDisabledPlugins call <SID>get_disabled_plugins()
" }}}

" return empty string when no python support found
function! s:python_version()
  if has("python3")
    return substitute(split(execute('py3 import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
  elseif has("python")
    return substitute(split(execute('py import sys; print(sys.version)'), ' ')[0], '^\n', '', '')
  else
    return ""
  endif
endfunction

" check if current vim/neovim has async function
function! s:has_async()
  " return v:version >= 800 || has("nvim")
  return has("nvim")
endfunction

function! s:has_linux_build_env()
  return s:os !~ "windows" && s:os !~ "synology"
endfunction

" Choose autocompletion plugin {{{
" deoplete.nvim, completor.vim, YouCompleteMe, supertab
call s:disable_plugins(['deoplete.nvim', 'completor.vim', 'YouCompleteMe', 'supertab'])
if s:has_async() && has("python3")
  " deoplete.nvim
  call s:enable_plugin('deoplete.nvim')
elseif has("python") || has("python3")
  " completor.vim
  call s:enable_plugin('completor.vim')
elseif s:has_linux_build_env()
  " YouCompleteMe
  call s:enable_plugin('YouCompleteMe')
else
  " supertab
  call s:enable_plugin('supertab')
endif
" }}}

" Choose Lint plugin
" syntastic, ale
if s:has_async()
  call s:disable_plugin('syntastic')
else
  call s:disable_plugin('ale')
end

if !has("python")
  call s:disable_plugin('github-issues.vim')
endif

if !(s:has_async() && has("python3"))
  call s:disable_plugin('denite.nvim')
end

" Choose markdown-preview plugin
if has("nvim")
  call s:disable_plugin('markdown-preview.vim')
else
  call s:disable_plugin('markdown-preview.nvim')
endif
" }}}

" Choose file explorer
" Defx requires python 3.6
if has("nvim") && s:python_version() =~ "^3.6"
  call s:disable_plugin("vimfiler")
else
  call s:disable_plugin("defx")
endif

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
" completion setting {{{
" FIXME Completion popup still appear after select completion.
" inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"
inoremap <expr> <Tab>      pumvisible() ? "\<C-n>" : "\<Tab>"

" Workaround of supertab bug
if s:is_disabled_plugin('supertab')
  inoremap <expr> <S-Tab>    pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif
" }}}

" deoplete.nvim {{{
if s:is_enabled_plugin('deoplete.nvim')
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

  inoremap <expr><C-g><C-g> deoplete#refresh()
  inoremap <silent><expr><C-l> deoplete#complete_common_string()
endif
" }}}

" completor.vim {{{
if s:is_enabled_plugin('completor.vim')
  Plug 'maralla/completor.vim'

  if s:has_linux_build_env()
    let g:completor_clang_binary = "/usr/lib/llvm-5.0/lib/clang"
  end
endif
" }}}

" YouCompleteMe {{{
if s:is_enabled_plugin('YouCompleteMe')
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

" supertab {{{
if s:is_enabled_plugin('supertab')
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

" Cause Denite error, disabled for now
Plug 'raghur/fruzzy', { 'do': { -> fruzzy#install() } }

let g:fruzzy#usenative = 1
let g:ctrlp_match_func = { 'match': 'fruzzy#ctrlp#matcher' }

if has("python")
  Plug 'FelikZ/ctrlp-py-matcher'

  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" let g:ctrlp_cmdpalette_execute = 1

nnoremap <C-p> :CtrlP<CR>
nnoremap <Space>cf :CtrlPFunky<CR>
nnoremap <Space>cF :execute 'CtrlPFunky ' . expand('<cword>')<CR>
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

nmap <silent> _ <Plug>VinegarVerticalSplitUp
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
" }}}

" vimfiler {{{
if s:is_enabled_plugin("vimfiler")
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
endif
" }}}

" Defx {{{
if s:is_enabled_plugin("defx")
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'kristijanhusak/defx-git'
  " Font not supported
  " Plug 'kristijanhusak/defx-icons'

  " " Defx as default explorer, borrowed from vimfiler {{{
  " FIXME Defx buffer opened through this method will core dump if open terminal or use fzf's :Files
  " This combines with `set hidden` will cause core dump.
  "
  " let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
  "
  " augroup defx_default_explorer
  "   autocmd BufEnter,VimEnter,BufNew,BufWinEnter,BufRead,BufCreate
  "         \ * call s:browse_check(expand('<amatch>'))
  " augroup END
  "
  " function! s:browse_check(path) abort
  "   if a:path == '' || bufnr('%') != expand('<abuf>')
  "     return
  "   endif
  "
  "   " Disable netrw.
  "   augroup FileExplorer
  "     autocmd!
  "   augroup END
  "
  "   let path = a:path
  "   " For ":edit ~".
  "   if fnamemodify(path, ':t') ==# '~'
  "     let path = '~'
  "   endif
  "
  "   if &filetype ==# 'defx' && line('$') != 1
  "     return
  "   endif
  "
  "   if isdirectory(s:expand(path))
  "     call defx#util#call_defx('Defx', path)
  "   endif
  " endfunction
  "
  " function! s:expand(path) abort
  "   return s:substitute_path_separator(
  "         \ (a:path =~# '^\~') ? fnamemodify(a:path, ':p') :
  "         \ (a:path =~# '^\$\h\w*') ? substitute(a:path,
  "         \             '^\$\h\w*', '\=eval(submatch(0))', '') :
  "         \ a:path)
  " endfunction
  "
  " function! s:substitute_path_separator(path) abort
  "   return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
  " endfunction
  " " }}}

  augroup netrw_mapping_for_defx
    autocmd!
    autocmd FileType netrw call s:netrw_mapping_for_defx()
  augroup END
  function! s:netrw_mapping_for_defx()
    " Cannot override Vinegar '-' mapping, so use '+' instead
    nmap + c:call <SID>opendir('Defx')<CR>
  endfunction

  " Borrowed from vinegar
  function! s:opendir(cmd) abort
    if expand('%') =~# '^$\|^term:[\/][\/]'
      execute a:cmd ' .'
    else
      execute a:cmd . ' ' . expand('%:h')
    endif
  endfunction

  nnoremap <F4> :Defx -split=vertical -winwidth=35 -direction=topleft -toggle<CR>
  nnoremap <Space><F4> :Defx -split=vertical -winwidth=35 -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>
  nnoremap - :call <SID>opendir('Defx')<CR>
  nnoremap + :call <SID>opendir('Defx')<CR>
  nnoremap \- :call <SID>opendir('Defx')<CR>
  nnoremap _ :call <SID>opendir('Defx -split=vertical')<CR>
  nnoremap <Space>- :call <SID>opendir('Defx -split=horizontal')<CR>
  nnoremap <Space>_ :call <SID>opendir('Defx -split=tab')<CR>
  nnoremap \. :Defx .<CR>

  " Defx custom functions {{{
  function! s:defx_get_folder(context) abort
    let path = a:context.targets[0]
    return isdirectory(path) ? path : fnamemodify(path, ':h')
  endfunction

  function! s:defx_fzf_files(context) abort
    let path = s:defx_get_folder(a:context)

    execute 'Files ' . path
  endfunction

  function! s:defx_fzf_rg_internal(context, prompt, bang) abort
    let path = s:defx_get_folder(a:context)

    let cmd = a:bang ? 'RgWithOption!' : 'RgWithOption'
    execute cmd . ' ' . path . '::' . input(a:prompt . ': ')
  endfunction
  function! s:defx_fzf_rg(context) abort
    call s:defx_fzf_rg_internal(a:context, 'Rg', v:false)
  endfunction
  function! s:defx_fzf_rg_bang(context) abort
    call s:defx_fzf_rg_internal(a:context, 'Rg!', v:true)
  endfunction

  function! s:defx_fzf_directory_ancestors_sink(line) abort
    execute 'lcd ' . a:line
    call defx#call_action('cd', getcwd())
  endfunction
  function! s:defx_fzf_directory_ancestors(context) abort
    let path = s:defx_get_folder(a:context)

    call fzf#run(fzf#wrap({
          \ 'source': s:directory_ancestors_internal(path),
          \ 'sink': function('s:defx_fzf_directory_ancestors_sink'),
          \ 'options': '+s',
          \ 'down': '40%'}))
  endfunction

  function! s:defx_execute_internal(context, split) abort
    let path = a:context.targets[0]
    let cmd = input('Command: ')

    if empty(cmd)
      return
    endif

    if cmd =~ '{}'
      " replace all '{}' to path
      let cmd = substitute(cmd, '{}', path, 'g')
    else
      let cmd = cmd . ' ' . path
    endif

    execute a:split . ' | :terminal ' . cmd
  endfunction
  function! s:defx_execute(context) abort
    call s:defx_execute_internal(a:context, '')
  endfunction
  function! s:defx_execute_tab(context) abort
    call s:defx_execute_internal(a:context, 'tabnew')
  endfunction
  function! s:defx_execute_split(context) abort
    call s:defx_execute_internal(a:context, 'new')
  endfunction
  function! s:defx_execute_vertical(context) abort
    call s:defx_execute_internal(a:context, 'vnew')
  endfunction
  " }}}

  autocmd FileType defx call s:defx_my_settings()
  function! s:defx_my_settings() abort " {{{
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
          \ defx#do_action('drop')
    nnoremap <silent><buffer><expr> c
          \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> cc
          \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> !
          \ defx#do_action('execute_command')
    nnoremap <silent><buffer><expr> m
          \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
          \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
          \ defx#do_action('open')
    nnoremap <silent><buffer><expr> C
          \ defx#do_action('toggle_columns', 'mark:filename:type:size:time')
    nnoremap <silent><buffer><expr> S
          \ defx#do_action('toggle_sort', 'Time')
    nnoremap <silent><buffer><expr> B
          \ defx#do_action('open', 'botright split')
    nnoremap <silent><buffer><expr> E
          \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
          \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> T
          \ defx#do_action('open', 'tab split')
    nnoremap <silent><buffer><expr> K
          \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
          \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
          \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> d
          \ defx#do_action('remove_trash')
    nnoremap <silent><buffer><expr> r
          \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> x
          \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> .
          \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> yy
          \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> h
          \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
          \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> \
          \ defx#do_action('cd', getcwd())
    nnoremap <silent><buffer><expr> cd
          \ defx#do_action('change_vim_cwd')
    nnoremap <silent><buffer><expr> \c
          \ defx#do_action('cd', expand(input('cd: ')))
    nnoremap <silent><buffer><expr> q
          \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> `
          \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
          \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
          \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
          \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
          \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
          \ defx#do_action('print')
    nnoremap <silent><buffer><expr> <C-t><C-r>
          \ defx#do_action('change_vim_cwd') . ":terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-t><C-t>
          \ defx#do_action('change_vim_cwd') . ":tabnew <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-t><C-s>
          \ defx#do_action('change_vim_cwd') . ":new    <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-t><C-v>
          \ defx#do_action('change_vim_cwd') . ":vnew   <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
          \ ':<C-u>wincmd w<CR>' :
          \ ':<C-u>Defx -buffer-name=temp -split=vertical<CR>'
    nnoremap <silent><buffer><expr> \f
          \ defx#do_action('call', '<SID>defx_fzf_files')
    nnoremap <silent><buffer><expr> \r
          \ defx#do_action('call', '<SID>defx_fzf_rg')
    nnoremap <silent><buffer><expr> \R
          \ defx#do_action('call', '<SID>defx_fzf_rg_bang')
    nnoremap <silent><buffer><expr> \<BS>
          \ defx#do_action('call', '<SID>defx_fzf_directory_ancestors')
    nnoremap <silent><buffer><expr> \x
          \ defx#do_action('call', '<SID>defx_execute') " Add this mapping to prevent from executing 'x' mapping
    nnoremap <silent><buffer><expr> \xr
          \ defx#do_action('call', '<SID>defx_execute')
    nnoremap <silent><buffer><expr> \xt
          \ defx#do_action('call', '<SID>defx_execute_tab')
    nnoremap <silent><buffer><expr> \xs
          \ defx#do_action('call', '<SID>defx_execute_split')
    nnoremap <silent><buffer><expr> \xv
          \ defx#do_action('call', '<SID>defx_execute_vertical')
    nnoremap <silent><buffer>       \d
          \ :Denite defx/dirmark<CR>

    " Use Unite because using Denite will change other Denite buffers
    nnoremap <silent><buffer> g?
          \ :Unite -buffer-name=defx_map_help output:map\ <buffer><CR>
  endfunction " }}}
endif
" }}}

" vim-choosewin {{{
if s:is_enabled_plugin("vimfiler")
  " Only used in vimfiler
  Plug 't9md/vim-choosewin'

  " seoul256 colors
  let g:choosewin_color_label_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
  let g:choosewin_color_label = { 'gui': ['#719872', ''], 'cterm': [65, 0] }
  let g:choosewin_color_other = { 'gui': ['#757575', '#BFBFBF'], 'cterm': [241, 249] }
  let g:choosewin_color_overlay_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
  let g:choosewin_color_overlay = { 'gui': ['#007173', '#DEDFBD'], 'cterm': [23, 187, 'bold'] }
  nmap + <Plug>(choosewin)
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

" Escape colon, backslash and space
function! s:escape_symbol(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

function! s:unite_grep(query, buffer_name_prefix, option, is_word) abort
  let escaped_query = s:escape_symbol(a:query)
  let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
  execute 'Unite -buffer-name=' . a:buffer_name_prefix . '%`bufnr("%")` -wrap grep:.:' . a:option . ':' . final_query
endfunction

" Unite key mappings {{{
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite -buffer-name=files buffer bookmark file<CR>
if has("nvim")
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>/ :Unite -buffer-name=grep%`bufnr("%")` grep:.<CR>
nnoremap <Space>? :execute 'Unite -buffer-name=grep%`bufnr("%")` grep:.:' . <SID>escape_symbol(input('Option: '))<CR>
nnoremap <Space>y :Unite history/yank<CR>
nnoremap <Space>S :Unite source<CR>
nnoremap <Space>m :Unite file_mru<CR>
nnoremap <Space>M :Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <Space>o :Unite outline -start-insert<CR>
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
nnoremap <Space>uk :call <SID>unite_grep(expand('<cword>'), 'keyword', '', v:false)<CR>
nnoremap <Space>uK :call <SID>unite_grep(expand('<cWORD>'), 'keyword', '', v:false)<CR>
nnoremap <Space>u8 :call <SID>unite_grep(expand('<cword>'), 'keyword', '', v:true)<CR>
nnoremap <Space>u* :call <SID>unite_grep(expand('<cWORD>'), 'keyword', '', v:true)<CR>
xnoremap <Space>uk :<C-u>call <SID>unite_grep(<SID>get_visual_selection(), 'keyword', '', v:false)<CR>
xnoremap <Space>u8 :<C-u>call <SID>unite_grep(<SID>get_visual_selection(), 'keyword', '', v:true)<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>uL :Unite location_list<CR>
nnoremap <Space>uo :Unite output -start-insert<CR>
nnoremap <Space>uO :Unite outline -start-insert<CR>
nnoremap <Space>up :UniteWithProjectDir -buffer-name=files -prompt=&\  buffer bookmark file<CR>
nnoremap <Space>uq :Unite quickfix<CR>
nnoremap <Space>ur :Unite -buffer-name=register register<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>ut :Unite -start-insert tab<CR>
nnoremap <Space>uT :Unite tag<CR>
nnoremap <Space>uu :UniteResume<CR>
nnoremap <Space>uU :Unite -buffer-name=resume resume<CR>
nnoremap <Space>uw :Unite window<CR>
nnoremap <Space>uma :Unite mapping<CR>
nnoremap <Space>ume :Unite output:message<CR>
nnoremap <Space>ump :Unite output:map<CR>
nnoremap <Space>u: :Unite history/command -start-insert<CR>
nnoremap <Space>u; :Unite command -start-insert<CR>
nnoremap <Space>u/ :Unite history/search<CR>

nnoremap <Space><F1> :Unite output:map<CR>

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>/ :call <SID>unite_grep('', 'grep', '', v:false)<CR>
  nnoremap <Space>? :call <SID>unite_grep('', 'grep', <SID>escape_symbol(input('Option: ')), v:false)<CR>
  nnoremap <Space>g/ :call <SID>unite_grep('', 'grep', "-g\\ '" . input('glob: ') . "'", v:false)<CR>
endif
" }}}

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer> <C-\>'     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-y>     <Plug>(unite_input_directory)
  nmap <buffer> <M-a>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <M-c>     <Plug>(unite_print_candidate)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r><C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-x><C-x>     <Plug>(unite_complete)
  " nnoremap <silent><buffer><expr> l
  "       \ unite#smart_map('l', unite#do_action('default'))

  " Restore tab switch mapping
  nnoremap <buffer> <C-j>     gT
  nnoremap <buffer> <C-k>     gt

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

  " Runs "tabopen" action by <C-t>.
  nmap <silent><buffer><expr> <C-t>     unite#do_action('tabopen')

  " Runs "persist_open" action by <C-]>.
  imap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')
  nmap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')

  " Simulate "persist_tabopen" action by <M-]>.
  nmap <silent><buffer> <M-]>           <Plug>(unite_smart_preview)<C-w>k<C-w>T

  " Runs "grep" action by <M-g>.
  imap <silent><buffer><expr> <M-g>     unite#do_action('grep')
  nmap <silent><buffer><expr> <M-g>     unite#do_action('grep')

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer> ` <Plug>(unite_toggle_mark_current_candidate)
endfunction "}}}
" }}}

" Denite {{{
if s:is_enabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim'
  Plug 'neoclide/denite-extra'
  Plug 'kmnk/denite-dirmark'

  let g:session_directory = $HOME.'/vim-sessions/'
  let g:denite_source_session_path = $HOME.'/vim-sessions/'
  let g:project_folders = ['/synosrc/packages/source']

  function! s:denite_grep(query, buffer_name_prefix, option, is_word) abort
    let escaped_query = s:escape_symbol(a:query)
    let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
    execute 'Denite -buffer-name=' . a:buffer_name_prefix . '%`bufnr("%")` -auto-resume grep:.:' . a:option . ':' . final_query
  endfunction

  " Override Unite key mapping {{{
  nnoremap <Space>p :Denite -buffer-name=files -auto-resume buffer dirmark file<CR>
  nnoremap <Space>P :Denite -buffer-name=files -auto-resume file_rec<CR>
  " }}}

  nnoremap <Space>O :Denite outline<CR>

  nnoremap <Space>da :Denite location_list<CR>
  nnoremap <Space>db :DeniteBufferDir -buffer-name=files -auto-resume buffer dirmark file<CR>
  nnoremap <Space>dc :Denite change<CR>
  nnoremap <Space>dd :Denite directory_rec<CR>
  nnoremap <Space>dD :Denite directory_mru<CR>
  nnoremap <Space>df :Denite filetype<CR>
  nnoremap <Space>dh :Denite help<CR>
  nnoremap <Space>dj :Denite jump<CR>
  nnoremap <Space>dJ :Denite project<CR>
  nnoremap <Space>di :call <SID>denite_grep('!', 'grep', '', v:false)<CR>
  nnoremap <Space>dk :call <SID>denite_grep(expand('<cword>'), 'keyword', '', v:false)<CR>
  nnoremap <Space>dK :call <SID>denite_grep(expand('<cWORD>'), 'keyword', '', v:false)<CR>
  nnoremap <Space>d8 :call <SID>denite_grep(expand('<cword>'), 'keyword', '', v:true)<CR>
  nnoremap <Space>d* :call <SID>denite_grep(expand('<cWORD>'), 'keyword', '', v:true)<CR>
  xnoremap <Space>dk :<C-u>call <SID>denite_grep(<SID>get_visual_selection(), 'keyword', '', v:false)<CR>
  xnoremap <Space>d8 :<C-u>call <SID>denite_grep(<SID>get_visual_selection(), 'keyword', '', v:true)<CR>
  nnoremap <Space>dl :Denite -auto-highlight line<CR>
  nnoremap <Space>dL :Denite line:buffers<CR>
  nnoremap <Space>dm :Denite file_mru<CR>
  nnoremap <Space>do :execute 'Denite output:' . <SID>escape_symbol(input('output: '))<CR>
  nnoremap <Space>dO :Denite outline<CR>
  nnoremap <Space>d<C-o> :Denite unite:outline<CR>
  nnoremap <Space>dp :Denite -buffer-name=files -auto-resume buffer dirmark file<CR>
  nnoremap <Space>dP :Denite -buffer-name=files -auto-resume file_rec<CR>
  nnoremap <Space>d<C-p> :DeniteProjectDir -buffer-name=files -auto-resume buffer dirmark file<CR>
  nnoremap <Space>dq :Denite quickfix<CR>
  nnoremap <Space>dr :Denite register<CR>
  nnoremap <Space>ds :Denite session<CR>
  nnoremap <Space>dt :Denite tag<CR>
  nnoremap <Space>du :Denite -resume -refresh<CR>
  nnoremap <Space>dU :Denite -resume -refresh -buffer-name=grep%`bufnr("%")`<CR>
  nnoremap <Space>d<C-u> :Denite -resume -refresh -buffer-name=keyword%`bufnr("%")`<CR>
  nnoremap <Space>dx :Denite defx/history<CR>
  nnoremap <Space>dy :Denite neoyank<CR>
  nnoremap <Space>d: :Denite command_history<CR>
  nnoremap <Space>d; :Denite command<CR>
  nnoremap <Space>d/ :call <SID>denite_grep('', 'grep', '', v:false)<CR>
  nnoremap <Space>d? :call <SID>denite_grep('', 'grep', <SID>escape_symbol(input('Option: ')), v:false)<CR>

  if executable('rg')
    nnoremap <Space>dg/ :call <SID>denite_grep('', 'grep', "-g\\ '" . input('glob: ') . "'", v:false)<CR>
  endif
endif
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
function! s:copy_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'alt-v': 'rightbelow vsplit',
  \ 'alt-x': 'Defx',
  \ 'alt-c': function('s:copy_results'),
  \ }

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

" fzf functions & commands {{{
" fzf utility functions borrowed from fzf.vim {{{

" For using g:fzf_action in custom sink function
let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}
function! s:action_for(key, ...)
  let default = a:0 ? a:1 : ''
  let Cmd = get(g:fzf_action, a:key, default)
  return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

" For using colors in fzf
function! s:get_color(attr, ...)
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! s:csi(color, fg)
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] == '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

function! s:ansi(str, group, default, ...)
  let fg = s:get_color('fg', a:group)
  let bg = s:get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : s:csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.s:csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! s:".s:color_name."(str, ...)\n"
        \ "  return s:ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor
" }}}

command! -bar  -bang                  Helptags call fzf#vim#helptags(<bang>0)
command! -bang -nargs=+ -complete=dir LLocate  call fzf#vim#locate(<q-args>, <bang>0)
command! -bang -nargs=? -complete=dir Files    call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=?               GFiles   call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
command! -bar  -bang                  Windows  call fzf#vim#windows(<SID>fzf_windows_preview(), <bang>0)

function! s:fzf_windows_preview() abort
  let options = fzf#vim#with_preview()
  let preview_script = remove(options.options, -1)[0:-4]
  let get_filename_script = expand($VIMHOME . '/bin/fzf_windows_preview.sh')
  let final_script = preview_script . ' "$(' . get_filename_script . ' {})"'

  call remove(options.options, -1) " remove --preview
  call extend(options.options, ['--preview', final_script])
  return options
endfunction

" let g:rg_command = '
"     \ rg --column --line-number --no-heading --ignore-case --no-ignore --hidden --follow --color "always"
"     \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,lua,pm,vim,sh,h,hpp}"
"     \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '
" Manually specify ignore file as ripgrep 0.9.0 will not respect to .gitignore outside of git repository
let g:rg_command = 'rg --column --line-number --no-heading --smart-case --color=always --ignore-file ' . $HOME . '/.gitignore '
let g:rg_all_command = 'rg --column --line-number --no-heading --smart-case --no-ignore --hidden --follow --color=always '
command! -bang -nargs=* Rg call fzf#vim#grep(
      \ <bang>0 ? g:rg_all_command.shellescape(<q-args>)
      \         : g:rg_command.shellescape(<q-args>), 1,
      \ <bang>0 ? fzf#vim#with_preview('up:60%')
      \         : fzf#vim#with_preview('right:50%:hidden', '?'),
      \ <bang>0)

" Rg with option, using ':' to separate option and query
command! -bang -nargs=* RgWithOption call s:rg_with_option(<q-args>, <bang>0)
function! s:rg_with_option(command, bang)
  let command_parts = split(a:command, ':', 1)
  let folder = command_parts[0]
  let option = command_parts[1]
  let query = join(command_parts[2:], ':')
  call fzf#vim#grep(
        \ a:bang ? g:rg_all_command.option.' '.shellescape(query).' '.folder
        \         : g:rg_command.option.' '.shellescape(query).' '.folder, 1,
        \ a:bang ? fzf#vim#with_preview('up:60%')
        \         : fzf#vim#with_preview('right:50%:hidden', '?'),
        \ a:bang)
endfunction

command! Mru call fzf#run(fzf#wrap({
      \ 'source':  s:all_files(),
      \ 'options': '-m +s',
      \ 'down':    '40%' }))

" use neomru
function! s:all_files()
  return extend(
  \ filter(readfile(g:neomru#file_mru_path)[1:],
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\\[unite\\]\\|\[Preview\\]\\|__Tagbar__\\|term://'"),
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
      \ 'options': '+s',
      \ 'down':   '40%'}))

" TODO Add Jumps command preview
function! s:jump_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0], 'e')
  for result in a:lines[1:]
    let list = matchlist(result, '^\s\+\S\+\s\+\(\S\+\)\s\+\(\S\+\)\s\+\(.*\)') " jump line col file/text
    if len(list) < 4
      return
    end

    " Tell if list[3] is a file
    let lines = getbufline(list[3], list[1])
    if empty(lines)
      execute cmd
    else
      execute cmd . ' ' . list[3]
    endif
    call cursor(list[1], list[2])
  endfor
endfunction

function! s:jumps()
  return reverse(filter(split(execute("jumps", "silent!"), "\n")[1:], 'v:val != ">"'))
endfunction
command! Jump call fzf#run(fzf#wrap({
      \ 'source':  s:jumps(),
      \ 'sink*':   function('s:jump_sink'),
      \ 'options': '-m +s --expect=' . join(keys(g:fzf_action), ','),
      \ 'down':    '40%'}))

function! s:registers_sink(line)
  execute 'norm ' . a:line[0:1] . 'p'
endfunction

function! s:registers()
  return split(execute("registers", "silent!"), "\n")[1:]
endfunction
command! Registers call fzf#run(fzf#wrap({
      \ 'source': s:registers(),
      \ 'sink': function('s:registers_sink'),
      \ 'options': '+s',
      \ 'down': '40%'}))

function! s:directory_ancestors_internal(path)
  let current_dir = fnamemodify(a:path, ':p:h')
  let ancestors = []

  for path_part in split(current_dir, '/')
    let last_path = empty(ancestors) ? '' : ancestors[-1]
    let current_path = last_path . '/' . path_part
    call add(ancestors, current_path)
  endfor

  return reverse(ancestors)
endfunction

function! s:directory_ancestors_sink(line)
  execute 'lcd ' . a:line
endfunction

function! s:directory_ancestors()
  return s:directory_ancestors_internal(expand('%'))
endfunction
command! DirectoryAncestors call fzf#run(fzf#wrap({
      \ 'source': s:directory_ancestors(),
      \ 'sink': function('s:directory_ancestors_sink'),
      \ 'options': '+s',
      \ 'down': '40%'}))

" Borrowed from s:buffer_line_handler from fzf.vim
function! s:screen_line_handler(lines)
  execute split(a:lines[0], '\t')[0]
endfunction

" Borrowed from s:buffer_lines from fzf.vim
function! s:screen_lines_source(start, end, query)
  let linefmt = s:yellow(" %4d ", "LineNr")."\t%s"
  let fmtexpr = 'printf(linefmt, v:key + 1, v:val)'
  let lines = getline(1, '$')
  if empty(a:query)
    let formatted_lines = map(lines, fmtexpr)
    return formatted_lines[a:start-1 : a:end-1]
  end
  let formatted_lines = map(lines, 'v:val =~ a:query ? '.fmtexpr.' : ""')
  return filter(formatted_lines[a:start-1 : a:end-1], 'len(v:val)')
endfunction
function! s:screen_lines(...)
  let query = (a:0 && type(a:1) == type('')) ? a:1 : ''

  let save_cursor = getcurpos()
  normal H
  let start = getpos('.')[1]
  normal L
  let end = getpos('.')[1]
  call setpos('.', save_cursor)

  call fzf#run(fzf#wrap({
        \ 'source':  s:screen_lines_source(start, end, query),
        \ 'sink*':   function('s:screen_line_handler'),
        \ 'options': ['--tiebreak=index', '--prompt', 'ScreenLines> ', '--ansi', '--extended', '--nth=2..', '--layout=reverse-list', '--tabstop=1']
        \ }))
endfunction
command! -nargs=? ScreenLines :call <SID>screen_lines(<q-args>)

" Cscope functions {{{
" Borrow from: https://gist.github.com/amitab/cd051f1ea23c588109c6cfcb7d1d5776
function! s:cscope_sink(lines) 
  if len(a:lines) < 2
    return
  end
  let cmd = s:action_for(a:lines[0], 'e')
  for result in a:lines[1:]
    let [filename, line_number] = split(split(result)[0], ":")
    execute cmd . ' +' . line_number . ' ' . filename
  endfor
endfunction

function! Cscope(option, query)
  let expect_keys = join(keys(g:fzf_action), ',')
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'sink*': function('s:cscope_sink'),
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104',
  \             '--expect=' . expect_keys],
  \ 'down': '40%'
  \ }
  call fzf#run(opts)
endfunction

function! CscopeQuery(option)
  call inputsave()
  if a:option == '0'
    let query = input('C Symbol: ')
  elseif a:option == '1'
    let query = input('Definition: ')
  elseif a:option == '2'
    let query = input('Functions called by: ')
  elseif a:option == '3'
    let query = input('Functions calling: ')
  elseif a:option == '4'
    let query = input('Text: ')
  elseif a:option == '6'
    let query = input('Egrep: ')
  elseif a:option == '7'
    let query = input('File: ')
  elseif a:option == '8'
    let query = input('Files #including: ')
  elseif a:option == '9'
    let query = input('Assignments to: ')
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    call Cscope(a:option, query)
  else
    echom "Cancelled Search!"
  endif
endfunction
" }}}

if has("nvim")
  function! s:fzf_statusline()
    highlight fzf1 ctermfg=242 ctermbg=236
    highlight fzf2 ctermfg=143
    highlight fzf3 ctermfg=15 ctermbg=239
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fzf%#fzf3#
  endfunction
  autocmd! User FzfStatusLine call <SID>fzf_statusline()

  function! s:project_tags(query)
    let s:origin_tags = &tags
    set tags-=./tags;
    augroup project_tags_callback
      autocmd!
      autocmd TermClose term://*fzf*
            \ let &tags = s:origin_tags |
            \ autocmd! project_tags_callback
    augroup END
    execute 'Tags ' . a:query
  endfunction
  command! -nargs=* ProjectTags call <SID>project_tags(<q-args>)

  function! s:tagbar_tags()
    TagbarOpenAutoClose
    augroup tagbar_tags_callback
      autocmd!
      autocmd TermClose term://*fzf*
            \ call nvim_input('<CR>') |
            \ autocmd! tagbar_tags_callback
    augroup END
    BLines
  endfunction
  command! TagbarTags call <SID>tagbar_tags()
endif
" }}}

" fzf key mappings {{{
nnoremap <Space>fa :execute 'Ag ' . input('Ag: ')<CR>
nnoremap <Space>fb :Buffers<CR>
nnoremap <Space>fB :Files %:h<CR>
nnoremap <Space>fc :BCommits<CR>
nnoremap <Space>fC :Commits<CR>
" TODO change to directory mru
nnoremap <Space>fd :execute "Tags '" . expand('<cword>')<CR>
nnoremap <Space>ff :Files<CR>
nnoremap <Space>fg :GFiles<CR>
nnoremap <Space>fG :execute 'GGrep ' . input('Git grep: ')<CR>
nnoremap <Space>fh :Helptags<CR>
nnoremap <Space>fi :History<CR>
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
nnoremap <Space>f4 :execute 'RgWithOption .:' . input('Option: ') . ':' . input('Rg: ')<CR>
nnoremap <Space>f$ :execute 'RgWithOption! .:' . input('Option: ') . ':' . input('Rg!: ')<CR>
nnoremap <Space>fs :GFiles?<CR>
nnoremap <Space>ft :BTags<CR>
nnoremap <Space>fT :Tags<CR>
nnoremap <Space>fu :DirectoryAncestors<CR>
nnoremap <Space>fw :Windows<CR>
nnoremap <Space>fy :Filetypes<CR>
nnoremap <Space>f' :Registers<CR>
nnoremap <Space>f` :Marks<CR>
nnoremap <Space>f: :History:<CR>
xnoremap <Space>f: :<C-u>History:<CR>
nnoremap <Space>f; :Commands<CR>
xnoremap <Space>f; :<C-u>Commands<CR>
nnoremap <Space>f/ :History/<CR>
nnoremap <Space>f] :execute "BTags '" . expand('<cword>')<CR>
nnoremap <Space>f} :execute "Tags '" . expand('<cword>')<CR>
nnoremap <Space>f<C-]> :execute 'Tselect ' . expand('<cword>')<CR>

nnoremap <Space>sl :ScreenLines<CR>
nnoremap <Space>sL :execute 'ScreenLines ' . expand('<cword>')<CR>
nnoremap <Space>ss :History:<CR>mks vim sessions 

" fzf & cscope key mappings {{{
nnoremap <silent> <Leader>cs :call Cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call Cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call Cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call Cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call Cscope('4', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call Cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call Cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call Cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ca :call Cscope('9', expand('<cword>'))<CR>

nnoremap <silent> <Leader><Leader>cs :call CscopeQuery('0')<CR>
nnoremap <silent> <Leader><Leader>cg :call CscopeQuery('1')<CR>
nnoremap <silent> <Leader><Leader>cd :call CscopeQuery('2')<CR>
nnoremap <silent> <Leader><Leader>cc :call CscopeQuery('3')<CR>
nnoremap <silent> <Leader><Leader>ct :call CscopeQuery('4')<CR>
nnoremap <silent> <Leader><Leader>ce :call CscopeQuery('6')<CR>
nnoremap <silent> <Leader><Leader>cf :call CscopeQuery('7')<CR>
nnoremap <silent> <Leader><Leader>ci :call CscopeQuery('8')<CR>
nnoremap <silent> <Leader><Leader>ca :call CscopeQuery('9')<CR>
" }}}

if has("nvim")
  nnoremap <Space>fp :ProjectTags<CR>
  nnoremap <Space>fP :execute "ProjectTags '" . expand('<cword>')<CR>
  nnoremap <Space><F8> :TagbarTags<CR>
endif
" }}}
" }}}

" skim {{{
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
" }}}

" vifm {{{
Plug 'vifm/vifm.vim'
" }}}

" vim-gutentags {{{
if has('job') || (has('nvim') && exists('*jobwait'))
  Plug 'ludovicchabant/vim-gutentags'
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

Plug 'brooth/far.vim', { 'on': ['Far', 'Farp', 'F'] }
" }}}

" Text Navigation {{{
" ====================================================================
" matchit {{{
runtime macros/matchit.vim
Plug 'voithos/vim-python-matchit'
" }}}

" EasyMotion {{{
Plug 'easymotion/vim-easymotion'

let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ; <Plug>(easymotion-s2)

map \w <Plug>(easymotion-bd-wl)
map \f <Plug>(easymotion-bd-fl)
map \s <Plug>(easymotion-sl2)

map <Leader>f <Plug>(easymotion-bd-f)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)L <Plug>(easymotion-bd-jk)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)

nmap <Leader>' <Plug>(easymotion-next)
nmap <Leader>; <Plug>(easymotion-prev)
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

command! AnzuToggleUpdate call <SID>AnzuToggleUpdate()
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
noremap <silent><expr> Z/ incsearch#go(<SID>config_easyfuzzymotion())
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

" Custom <CR> map to avoid enter <CR> when popup is opened
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>" . AutoPairsReturn()

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

let g:EraseSubword_insertMap = '<C-b>'
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
map <Space>sf vaf<M-/>

" }}}

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
if s:is_enabled_plugin('syntastic')
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
if s:is_enabled_plugin('ale')
  Plug 'w0rp/ale'

  let g:ale_linters = {
        \ 'c': ['gcc'],
        \ 'cpp': ['g++'],
        \ 'javascript': ['eslint', 'jshint']
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
  nmap <Leader>ar <Plug>(ale_reset_buffer)
  nmap <Leader>aR <Plug>(ale_reset)
  nmap <Leader>aS :ALEStopAllLSPs<CR>
end
" }}}

" markdown-preview.vim {{{
if s:is_enabled_plugin('markdown-preview.vim')
  Plug 'iamcco/markdown-preview.vim'
endif
" }}}

" markdown-preview.nvim {{{
if s:is_enabled_plugin('markdown-preview.nvim')
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

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" vim-polyglot {{{
Plug 'sheerun/vim-polyglot'

" Avoid conflict with vim-go, must after vim-go loaded
let g:polyglot_disabled = ['go']
" }}}

Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'moll/vim-node', { 'for': [] }
Plug 'tpope/vim-rails', { 'for': [] }
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/vim-slumlord'
Plug 'mars90226/perldoc-vim'
Plug 'gyim/vim-boxdraw'
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

command! -nargs=* GVA GV --all <args>

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

" Add '' to open tig main view
nnoremap \tr :Tig ''<CR>
nnoremap \tt :tabnew <Bar> Tig ''<CR>
nnoremap \ts :new    <Bar> Tig ''<CR>
nnoremap \tv :vnew   <Bar> Tig ''<CR>
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

" Ignore [a, ]a, [A, ]A for ale
let g:nremap = {"[a": "", "]a": "", "[A": "", "]A": ""}

nnoremap coe :set expandtab!<CR>
nnoremap com :set modifiable!<CR>
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

autocmd! FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
" }}}

" vim-caser {{{
Plug 'arthurxavierx/vim-caser'
" }}}

" vim-highlightedyank {{{
Plug 'machakann/vim-highlightedyank'

let g:highlightedyank_highlight_duration = 500
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
" }}}

" Plugin Settings End {{{
" vim-plug
call plug#end()
" }}}

" Post-loaded Plugin Settings {{{
" deoplete.nvim {{{
if s:is_enabled_plugin('deoplete.nvim')
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)
endif
" }}}

" Denite {{{
if s:is_enabled_plugin('denite.nvim')
  " Change mappings
  " Insert mode {{{
  call denite#custom#map(
        \ 'insert',
        \ '<A-f>',
        \ '<denite:toggle_matchers:matcher_fruzzy>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-g>',
        \ '<denite:toggle_matchers:matcher_substring>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-`>',
        \ '<denite:toggle_matchers:matcher_regexp>',
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
        \ '<A-o>',
        \ '<denite:do_action:open>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<A-d>',
        \ '<denite:do_action:cd>',
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
  " }}}

  " Normal mode {{{
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
        \ '<C-t>',
        \ '<denite:do_action:tabopen>',
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
  " }}}

  if executable('rg')
    call denite#custom#var('file_rec', 'command',
          \ ['rg', '--files', '--glob', '!.git'])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'final_opts', [])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'default_opts',
          \ ['--vimgrep', '--no-heading', '-S'])
  elseif executable('ag')
    call denite#custome#var('file_rec', 'command',
          \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  endif

  call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
endif
" }}}

" Defx {{{
if s:is_enabled_plugin("defx")
  call defx#custom#column('mark', {
        \ 'directory_icon': '▸',
        \ 'readonly_icon': '✗',
        \ 'selected_icon': '✓',
        \ })
  call defx#custom#option('_', {
        \ 'columns': 'git:mark:filename:type'
        \ })
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
  " TODO Fix this in Linux
  behave mswin

  if s:os !~ "windows"
    " Unmap CTRL-a for selecting all
    silent! unmap <C-a>
    silent! iunmap <C-a>
    silent! cunmap <C-a>
  endif

  if has("gui")
    " Fix CTRL-f in gui will popup find window problem
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
set cursorline

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

" syntax
" Check if syntax is on and only switch on syntax when it's off
" due to fugitive Gblame bug that lose highlight after `syntax on`
if !exists('g:syntax_on')
  syntax on
endif

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
  highlight Pmenu ctermfg=187 ctermbg=239
  highlight PmenuSel ctermbg=95
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

" Move tab
nnoremap <Leader>t< :tabmove -1<CR>
nnoremap <Leader>t> :tabmove +1<CR>

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

" Quick yank cursor word
nnoremap y" ""yiw
nnoremap y+ "+yiw

" Copy unnamed register to system clipboard
nnoremap <Space>sr :let @+ = @"<CR>

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

" get_visual_selection
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

" display file size
function! s:file_size(path)
  let path = expand(a:path)
  if isdirectory(path)
    echomsg path . " is directory!"
    return
  endif

  let file_size = getfsize(path)
  let gb = file_size / (1024 * 1024 * 1024)
  let mb = file_size / (1024 * 1024) % 1024
  let kb = file_size / (1024) % 1024
  let byte = file_size % 1024

  echomsg path . " size is "
        \ . (gb > 0 ? gb . "GB, " : "")
        \ . (mb > 0 ? mb . "MB, " : "")
        \ . (kb > 0 ? kb . "KB, " : "")
        \ . byte . "byte"
endfunction
command! -nargs=1 FileSize call <SID>file_size(<q-args>)

" }}}

" Custom command {{{
function! DeleteInactiveBufs(bang)
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
            if a:bang
              silent exec 'bwipeout!' i
            else
              silent exec 'bwipeout' i
            endif
            let nWipeouts = nWipeouts + 1

        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! -bang Bdi :call DeleteInactiveBufs(<bang>0)
nnoremap <Leader>D :Bdi<CR>
nnoremap <Leader><C-d> :Bdi!<CR>

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

command! ReloadVimrc source $HOME/.vimrc

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
  highlight Pmenu ctermfg=187 ctermbg=239
  highlight PmenuSel ctermbg=95
endif
" }}}

" Pair up with 'set winaltkeys=no' in _gvimrc
" Fix meta key in vim
" terminal meta key fix {{{
if !has("nvim") && !has("gui_running") && s:os !~ "windows"
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
" }}}

" neovim terminal key mapping and settings
if has("nvim")
  " Set terminal buffer size to unlimited
  set scrollback=-1

  " For quick terminal access
  nnoremap <silent> <Leader>tr :terminal<CR>i
  nnoremap <silent> <Leader>tt :tabnew <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>ts :new    <Bar> :terminal<CR>i
  nnoremap <silent> <Leader>tv :vnew   <Bar> :terminal<CR>i

  tnoremap <M-F1> <C-\><C-n>
  tnoremap <M-F2> <C-\><C-n>:tabnew<CR>:terminal<CR>i
  tnoremap <M-F3> <C-\><C-n>:Windows<CR>

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

  " Quickly suspend neovim
  tnoremap <M-C-z> <C-\><C-n>:suspend<CR>

  " Search keyword with Google using surfraw
  if executable('sr')
    command! -nargs=1 GoogleKeyword call <SID>google_keyword(<q-args>)
    function! s:google_keyword(keyword)
      new
      terminal
      startinsert
      call nvim_input('sr google ' . a:keyword . "\n")
    endfunction
    nnoremap <Leader>k :execute 'GoogleKeyword ' . expand('<cword>')<CR>
  endif
endif
" }}}

" Autocommands {{{
" ====================================================================
augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost _vimrc nested source $MYVIMRC | e | normal! zzzv
  autocmd BufWritePost .vimrc nested source $MYVIMRC | e | normal! zzzv
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
