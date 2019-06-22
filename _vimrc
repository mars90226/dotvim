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

" Detect operating system
if has("win32") || has("win64")
  let s:os = "windows"
else
  let s:os = system("uname -a")
endif

" Set $VIMHOME
" if s:os =~ "windows"
"   let $VIMHOME = $VIM."/vimfiles"
" else
"   let $VIMHOME = $HOME."/.vim"
" endif
" Use directory junction in Windows to link $HOME."/.vim" to $VIM."/vimfiles"
let $VIMHOME = $HOME."/.vim"

" Set Encoding
if s:os =~ "windows"
  set encoding=utf8
endif

" Set nvim version
if has("nvim")
  let s:nvim_version = systemlist("nvim --version")[0]
endif

" plugin choosing {{{
" enabled plugin management {{{
let s:plugin_disabled = []

function! s:disable_plugin(plugin)
  let l:idx = index(s:plugin_disabled, a:plugin)

  if l:idx == -1
    call add(s:plugin_disabled, a:plugin)
  endif
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
command! ListDisabledPlugins call s:get_disabled_plugins()
" }}}

" plugin config cache {{{
let s:plugin_config_cache_name = $VIMHOME . ".plugin_config_cache"
function! s:read_plugin_config_cache()
  if filereadable(s:plugin_config_cache_name)
    execute 'source ' . s:plugin_config_cache_name
  endif
endfunction
call s:read_plugin_config_cache()

let s:plugin_config_cache = []
function! s:append_plugin_config_cache(content)
  call add(s:plugin_config_cache, a:content)
endfunction

function! s:write_plugin_config_cache()
  call writefile(s:plugin_config_cache, s:plugin_config_cache_name)
endfunction

function! s:update_plugin_config_cache()
  " Update plugin config
  call s:append_plugin_config_cache("let g:has_jedi = " . s:has_jedi(1))

  call s:write_plugin_config_cache()
endfunction
command! UpdatePluginConfigCache call s:update_plugin_config_cache()

function! s:init_plugin_config_cache()
  if !filereadable(s:plugin_config_cache_name)
    call s:update_plugin_config_cache()
  endif
endfunction
call s:init_plugin_config_cache()
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
  return v:version >= 800 || has("nvim")
endfunction

function! s:has_rpc()
  return has("nvim")
endfunction

function! s:has_linux_build_env()
  return s:os !~ "windows" && s:os !~ "synology"
endfunction

function! s:has_jedi(...)
  let force = (a:0 >= 1 && type(a:1) == type(v:true)) ? a:1 : v:false

  if force || !exists("g:has_jedi")
    if has("python3")
      call system('pip3 show -qq jedi')
      return !v:shell_error
    elseif has("python")
      call system('pip show -qq jedi')
      return !v:shell_error
    else
      return 0
    endif
  else
    return g:has_jedi == 1
  endif
endfunction

" Choose statusline plugin
" airline, lightline
if $VIM_MODE == 'full'
  call s:disable_plugin('lightline.vim')
else
  call s:disable_plugin('vim-airline')
endif

" Choose autocompletion plugin {{{
" coc.nvim, deoplete.nvim, completor.vim, YouCompleteMe, supertab
call s:disable_plugins(['coc.nvim', 'deoplete.nvim', 'completor.vim', 'YouCompleteMe', 'supertab'])
if s:has_async() && s:has_rpc() && executable('node') && executable('yarn') && $VIM_MODE != 'reader'
  " coc.nvim
  call s:enable_plugin('coc.nvim')
elseif s:has_async() && s:has_rpc() && has("python3") && s:python_version() >= "3.6.1" && $VIM_MODE != 'reader'
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

" Choose file explorer
" Defx requires python 3.6.1+
if has("nvim") && s:python_version() >= "3.6.1"
  call s:disable_plugin("vimfiler")
else
  call s:disable_plugin("defx")
endif

if !has("python")
  call s:disable_plugin('github-issues.vim')
endif

if !(s:has_async() && s:has_rpc() && has("python3") && s:python_version() >= "3.6.1")
  call s:disable_plugin('denite.nvim')
end

" Choose markdown-preview plugin
if has("nvim")
  call s:disable_plugin('markdown-preview.vim')
else
  call s:disable_plugin('markdown-preview.nvim')
endif

if !exists("##TextYankPost")
  call s:disable_plugin('vim-highlightedyank')
endif

if !(has('job') || (has('nvim') && exists('*jobwait'))) || $NVIM_TERMINAL == "yes"
  call s:disable_plugin('vim-gutentags')
endif

if !s:has_linux_build_env() || $NVIM_TERMINAL == "yes" || $VIM_MODE == 'gitcommit' || $VIM_MODE == 'reader'
  call s:disable_plugin('git-p.nvim')
endif
" }}}

" Autoinstall vim-plug {{{
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
if s:is_enabled_plugin('vim-airline')
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
if s:is_enabled_plugin('lightline.vim')
  Plug 'itchyny/lightline.vim'
  Plug 'maximbaz/lightline-ale'
  Plug 'shinchu/lightline-gruvbox.vim'

  let s:lightline_width_threshold = 70

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
        \ 'fugitive': 'LightlineFugitive',
        \ 'filename': 'LightlineFilename',
        \ 'fileformat': 'LightlineFileformat',
        \ 'filetype': 'LightlineFiletype',
        \ 'fileencoding': 'LightlineFileencoding',
        \ 'mode': 'LightlineMode',
        \ }
  let g:lightline.tab_component_function = {
        \ 'filename': 'LightlineTabFilename',
        \ 'modified': 'LightlineTabModified',
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

  function! LightlineFilename()
    let fname = expand('%:t')
    let fpath = expand('%')

    if fname =~ '__Tagbar__'
      return g:lightline.fname
    elseif fname == '__Gundo__'
      return ''
    elseif &ft == 'qf'
      return w:quickfix_title
    elseif &ft == 'unite'
      return unite#get_status_string()
    elseif &ft == 'vimfiler'
      return vimfiler#get_status_string()
    elseif &ft == 'help'
      let t:current_filename = fname
      return fname
    else
      let readonly = '' != LightlineReadonly() ? LightlineReadonly() . ' ' : ''
      if fpath =~? '^fugitive'
        let filename = fnamemodify(fugitive#Real(fpath), ':.') . ' [git]'
      else
        let filename = '' != fname ? fpath : '[No Name]'
      end
      let modified = '' != LightlineModified() ? ' ' . LightlineModified() : ''

      let t:current_filename = fname
      return readonly . filename . modified
    endif
  endfunction

  function! LightlineReadonly()
    return &ft !~? 'help' && &readonly ? '' : ''
  endfunction

  function! LightlineModified()
    return &modifiable && &modified ? '+' : ''
  endfunction

  function! LightlineFugitive()
    if !exists('b:lightline_head')
      " Borrowed from s:display_git_branch from airline/extensions/branch.vim {{{
      let name = fugitive#head()
      try
        let commit = matchstr(FugitiveParse()[0], '^\x\+')

        if has_key(s:names, commit)
          let name = get(s:names, commit)."(".name.")"
        elseif !empty(commit)
          let ref = fugitive#repo().git_chomp('describe', '--all', '--exact-match', commit)
          if ref !~ "^fatal: no tag exactly matches"
            let name = substitute(ref, '\v\C^%(heads/|remotes/|tags/)=','','')."(".name.")"
          else
            let name = matchstr(commit, '.\{'.s:sha1size.'}')."(".name.")"
          endif
        endif
      catch
      endtry
      " }}}

      let b:lightline_head = name
    endif

    return &ft == 'qf' ? '' : 
          \ b:lightline_head !=# '' ? ' ' . b:lightline_head : ''
  endfunction

  function! LightlineFileformat()
    return winwidth(0) > s:lightline_width_threshold ? &fileformat : ''
  endfunction

  function! LightlineFiletype()
    return winwidth(0) > s:lightline_width_threshold ?
          \ &buftype ==# 'terminal' ? &buftype :
          \ (&filetype !=# '' ? &filetype : 'no ft') : ''
  endfunction

  function! LightlineFileencoding()
    return winwidth(0) > s:lightline_width_threshold ? (&fileencoding !=# '' ? &fileencoding : &encoding) : ''
  endfunction

  function! LightlineMode()
    let fname = expand('%:t')
    return fname =~ '__Tagbar__' ? 'Tagbar' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ &ft == 'qf' ? LightlineQuickfixMode() :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'fugitive' ? 'Fugitive' :
          \ lightline#mode()
  endfunction

  " Borrowed from vim-airline {{{
  function! LightlineQuickfixMode()
    let dict = getwininfo(win_getid())
    if len(dict) > 0 && get(dict[0], 'quickfix', 0) && !get(dict[0], 'loclist', 0)
      return 'Quickfix'
    elseif len(dict) > 0 && get(dict[0], 'quickfix', 0) && get(dict[0], 'loclist', 0)
      return 'Location'
    endif
  endfunction
  " }}}

  function! LightlineTabFilename(n) abort
    let bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
    let fname = expand('#' . bufnr . ':t')
    let ftype = getbufvar(bufnr, '&ft')
    let FilenameFilter = { fname -> '' != fname ? fname : '[No Name]' }
    return fname =~ '__Tagbar__' ? 'Tagbar' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ ftype == 'fzf' ? FilenameFilter(gettabvar(a:n, 'current_filename', fname)) :
          \ FilenameFilter(fname)
  endfunction

  function! LightlineTabModified(n) abort
    let winnr = tabpagewinnr(a:n)
    let bufnr = tabpagebuflist(a:n)[winnr - 1]
    let ftype = getbufvar(bufnr, '&ft')
    let buftype = getbufvar(bufnr, '&buftype')
    return ftype == 'fzf' ? '' :
          \ buftype == 'terminal' ? '' :
          \ gettabwinvar(a:n, winnr, '&modified') ? '+' : gettabwinvar(a:n, winnr, '&modifiable') ? '' : '-'
  endfunction
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
" inoremap <expr> <Esc>      pumvisible() ? "\<C-E>" : "\<Esc>"
inoremap <expr> <CR>       pumvisible() ? "\<C-Y>" : "\<CR>"
inoremap <expr> <Down>     pumvisible() ? "\<C-N>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-P>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"
inoremap <expr> <Tab>      pumvisible() ? "\<C-N>" : "\<Tab>"

" Workaround of supertab bug
if s:is_disabled_plugin('supertab')
  inoremap <expr> <S-Tab>    pumvisible() ? "\<C-P>" : "\<S-Tab>"
endif
" }}}

" coc.nvim {{{
if s:is_enabled_plugin('coc.nvim')
  Plug 'Shougo/neco-vim'
  Plug 'neoclide/coc-neco'
  Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() } }
  Plug 'neoclide/coc-denite'

  " <Tab>: completion.
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-N>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction "}}}

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

  " K: show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  " Remap for K
  nnoremap gK K

  function! s:show_documentation()
    if &filetype == 'vim' || &filetype == 'help'
      execute 'help ' . expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " mappings for rename current word
  nmap <Space>cr <Plug>(coc-rename)

  " mappings for format selected region
  nmap <Space>cf <Plug>(coc-format-selected)
  xmap <Space>cf <Plug>(coc-format-selected)

  augroup coc_settings
    autocmd!
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

  augroup coc_ccls_settings
    autocmd!
    autocmd FileType c,cpp call s:coc_ccls_settings()
  augroup END

  function! s:coc_ccls_settings()
    " ccls navigate commands
    nnoremap <silent><buffer> <C-X>l :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'D' })<CR>
    nnoremap <silent><buffer> <C-X>k :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'L' })<CR>
    nnoremap <silent><buffer> <C-X>j :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'R' })<CR>
    nnoremap <silent><buffer> <C-X>h :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'U' })<CR>

    " TODO Add mapping for hierarchy

    " ccls inheritance
    " bases
    nnoremap <silent><buffer> <C-X>b :call CocLocations('ccls', '$ccls/inheritance')<CR>
    " bases of up to 3 levels
    nnoremap <silent><buffer> <C-X>B :call CocLocations('ccls', '$ccls/inheritance', { 'levels': 3 })<CR>
    " derived
    nnoremap <silent><buffer> <C-X>d :call CocLocations('ccls', '$ccls/inheritance', { 'derived': v:true })<CR>
    " derived of up to 3 levels
    nnoremap <silent><buffer> <C-X>D :call CocLocations('ccls', '$ccls/inheritance', { 'derived': v:true, 'levels': 3 })<CR>

    " ccls caller
    nnoremap <silent><buffer> <C-X>c :call CocLocations('ccls', '$ccls/call')<CR>
    " ccls callee
    nnoremap <silent><buffer> <C-X>C :call CocLocations('ccls', '$ccls/call', { 'callee': v:true })<CR>

    " ccls member
    " member variables / variables in a namespace
    nnoremap <silent><buffer> <C-X>m :call CocLocations('ccls', '$ccls/member')<CR>
    " member functions / functions in a namespace
    nnoremap <silent><buffer> <C-X>f :call CocLocations('ccls', '$ccls/member', { 'kind': 3 })<CR>
    " member classes / types in a namespace
    nnoremap <silent><buffer> <C-X>s :call CocLocations('ccls', '$ccls/member', { 'kind': 2 })<CR>

    " ccls vars
    " vars field, local, parameter
    nnoremap <silent><buffer> <C-X>v :call CocLocations('ccls', '$ccls/vars')<CR>
    " vars field
    nnoremap <silent><buffer> <C-X>V :call CocLocations('ccls', '$ccls/vars', { 'kind': 1 })<CR>
  endfunction
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
  if s:has_jedi()
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
  " let g:LanguageClient_settingsPath = $VIMHOME."/settings.json"

  " deoplete-ternjs
  let g:deoplete#sources#ternjs#tern_bin = $VIMHOME . "/plugged/tern_for_vim/node_modules/tern/bin/tern"

  " float-preview.nvim
  if has("nvim")
    set completeopt-=preview

    let g:float_preview#docked = 0
  endif

  " TODO Set python & python3 for jedi

  " <Tab>: completion.
  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-N>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ deoplete#manual_complete()
  function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~ '\s'
  endfunction "}}}

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
if s:is_enabled_plugin('completor.vim')
  Plug 'maralla/completor.vim'

  if s:has_linux_build_env()
    let g:completor_clang_binary = "/usr/lib/llvm-8/lib/clang"
  end
endif
" }}}

" YouCompleteMe {{{
if s:is_enabled_plugin('YouCompleteMe')
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
  Plug 'raghur/fruzzy', { 'do': { -> fruzzy#install() } }

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
xnoremap <Space>cK :<C-U>execute 'CtrlPFunky ' . <SID>get_visual_selection()<CR>
nnoremap <Space>cp :CtrlPCmdPalette<CR>
nnoremap <Space>cm :CtrlPCmdline<CR>
nnoremap <Space>c] :CtrlPtjump<CR>
xnoremap <Space>c] :CtrlPtjumpVisual<CR>

if executable('fd')
  let g:ctrlp_user_command = 'fd --type f --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore "" %s'
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

if s:is_enabled_plugin('lightline.vim')
  let g:tagbar_status_func = 'TagbarStatusFunc'

  function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction
endif
" }}}

" vimfiler {{{
if s:is_enabled_plugin("vimfiler")
  Plug 'Shougo/vimfiler.vim'
  Plug 'Shougo/neossh.vim'

  if s:is_enabled_plugin('lightline.vim')
    let g:vimfiler_force_overwrite_statusline = 0
  endif

  let g:vimfiler_as_default_explorer = 1
  nnoremap <F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit<CR>
  nnoremap <Space><F4> :VimFilerExplorer -split -simple -parent -winwidth=35 -toggle -no-quit -find<CR>
  autocmd FileType vimfiler call s:vimfiler_my_settings()
  function! s:vimfiler_my_settings()
    " Runs "tabopen" action by <C-T>.
    nmap <silent><buffer><expr> <C-T>     vimfiler#do_action('tabopen')

    " Runs "choose" action by <C-C>.
    nmap <silent><buffer><expr> <C-C>     vimfiler#do_action('choose')

    " Toggle no_quit with <C-N>
    nmap <silent><buffer>       <C-N>     :let b:vimfiler.context.quit = !b:vimfiler.context.quit<CR>

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
    nmap <silent><buffer> + c:call <SID>opendir('Defx')<CR>
  endfunction

  " Borrowed from vinegar
  function! s:opendir(cmd) abort
    if expand('%') =~# '^$\|^term:[\/][\/]'
      execute a:cmd ' .'
    else
      execute a:cmd . ' ' . expand('%:h')
    endif
  endfunction

  nnoremap <F4>        :Defx -split=vertical -winwidth=35 -direction=topleft -toggle<CR>
  nnoremap <Space><F4> :Defx -split=vertical -winwidth=35 -direction=topleft -toggle `expand('%:p:h')` -search=`expand('%:p')`<CR>
  nnoremap -           :call <SID>opendir('Defx')<CR>
  nnoremap ++          :call <SID>opendir('Defx')<CR>
  nnoremap \-          :call <SID>opendir('Defx')<CR>
  nnoremap _           :call <SID>opendir('Defx -split=vertical')<CR>
  nnoremap <Space>-    :call <SID>opendir('Defx -split=horizontal')<CR>
  nnoremap <Space>_    :call <SID>opendir('Defx -split=tab -buffer-name=tab')<CR>
  nnoremap \.          :Defx .<CR>
  nnoremap <Space>=    :Defx -split=vertical .<CR>
  nnoremap <Space>+    :Defx -split=tab -buffer-name=tab .<CR>

  " Defx custom functions {{{
  " Currently not used
  function! s:defx_get_folder(context) abort
    let path = a:context.targets[0]
    return isdirectory(path) ? path : fnamemodify(path, ':h')
  endfunction

  function! s:defx_get_current_path() abort
    return b:defx['paths'][0]
  endfunction

  function! s:defx_fzf_files(context) abort
    " let path = s:defx_get_folder(a:context)
    let path = s:defx_get_current_path()

    call s:use_defx_fzf_action({ -> fzf#vim#files(path, fzf#vim#with_preview(), 0)})
  endfunction

  let s:defx_action = {
        \ 'tab split': '-split=tab',
        \ 'split': '-split=horizontal',
        \ 'vsplit': '-split=vertical',
        \ 'rightbelow vsplit': '-split=vertical -direction=botright',
        \ }
  let s:defx_additional_argument = {
        \ 'tab split': '-buffer-name=tab',
        \ }

  " TODO May need to escape a:line
  function! s:defx_open(target, action)
    if isdirectory(a:target)
      if &filetype == 'defx' && a:action == 'edit'
        " Use absolute path
        let target = fnamemodify(a:target, ':p')
        call defx#call_action('cd', target)
      else
        execute 'Defx ' . get(s:defx_action, a:action, '') . ' ' . get(s:defx_additional_argument, a:action , '') . ' ' . a:target
      endif
    else
      execute a:action . ' ' . a:target
    endif
  endfunction
  command! -nargs=1 -complete=file DefxOpenSink            call s:defx_open(<q-args>, 'edit')
  command! -nargs=1 -complete=file DefxSplitOpenSink       call s:defx_open(<q-args>, 'split')
  command! -nargs=1 -complete=file DefxVSplitOpenSink      call s:defx_open(<q-args>, 'vsplit')
  command! -nargs=1 -complete=file DefxTabOpenSink         call s:defx_open(<q-args>, 'tab split')
  command! -nargs=1 -complete=file DefxRightVSplitOpenSink call s:defx_open(<q-args>, 'rightbelow vsplit')

  function! s:defx_open_dir(target, action)
    if isdirectory(a:target)
      let dir = a:target
    else
      let dir = fnamemodify(a:target, ':h')
    endif

    if &filetype == 'defx' && a:action == 'edit'
      " Use absolute path
      let dir = fnamemodify(dir, ':p')
      call defx#call_action('cd', dir)
    else
      execute 'Defx ' . get(s:defx_action, a:action, '') . ' ' . get(s:defx_additional_argument, a:action , '') . ' ' . dir
    endif
  endfunction
  command! -nargs=1 -complete=file DefxOpenDirSink            call s:defx_open_dir(<q-args>, 'edit')
  command! -nargs=1 -complete=file DefxSplitOpenDirSink       call s:defx_open_dir(<q-args>, 'split')
  command! -nargs=1 -complete=file DefxVSplitOpenDirSink      call s:defx_open_dir(<q-args>, 'vsplit')
  command! -nargs=1 -complete=file DefxTabOpenDirSink         call s:defx_open_dir(<q-args>, 'tab split')
  command! -nargs=1 -complete=file DefxRightVSplitOpenDirSink call s:defx_open_dir(<q-args>, 'rightbelow vsplit')

  function! s:defx_fzf_rg_internal(context, prompt, bang) abort
    " let path = s:defx_get_folder(a:context)
    let path = s:defx_get_current_path()

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
    " let path = s:defx_get_folder(a:context)
    let path = s:defx_get_current_path()

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
    if bufname('%') =~ 'tab'
      nnoremap <silent><buffer><expr> <CR>
            \ defx#async_action('open')
    else
      nnoremap <silent><buffer><expr> <CR>
            \ defx#is_directory() ?
            \ defx#async_action('open') :
            \ defx#async_action('drop')
    endif
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
          \ defx#async_action('open')
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
    nnoremap <silent><buffer><expr> o
          \ defx#async_action('open_or_close_tree')
    nnoremap <silent><buffer><expr> O
          \ defx#async_action('open_tree_recursive')
    nnoremap <silent><buffer><expr> K
          \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
          \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> M
          \ defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><nowait><expr> d
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
          \ defx#async_action('cd', ['..'])
    nnoremap <silent><buffer><expr> <BS>
          \ defx#async_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
          \ defx#async_action('cd')
    nnoremap <silent><buffer><expr> gr
          \ defx#do_action('cd', '/')
    nnoremap <silent><buffer><expr> gl
          \ defx#do_action('cd', '/usr/lib/')
    nnoremap <silent><buffer><expr> gv
          \ defx#do_action('cd', $VIMRUNTIME)
    nnoremap <silent><buffer><expr> \
          \ defx#do_action('cd', getcwd())
    nnoremap <silent><buffer><expr> \\
          \ defx#do_action('cd', getcwd())
    nnoremap <silent><buffer><expr> cd
          \ defx#do_action('change_vim_cwd')
    nnoremap <silent><buffer><expr> \c
          \ defx#do_action('cd', expand(input('cd: ')))
    if bufname('%') =~ 'tab'
      nnoremap <silent><buffer><expr> q
            \ defx#do_action('quit') . ":quit<CR>"
    else
      nnoremap <silent><buffer><expr> q
            \ defx#do_action('quit')
    endif
    nnoremap <silent><buffer><expr> `
          \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
          \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
          \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
          \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-L>
          \ defx#do_action('redraw')
    xnoremap <silent><buffer><expr> <CR>
          \ defx#do_action('toggle_select_visual')
    nnoremap <silent><buffer><expr> <C-G>
          \ defx#do_action('print')
    nnoremap <silent><buffer><expr> <C-T><C-R>
          \ defx#do_action('change_vim_cwd') . ":terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-T><C-T>
          \ defx#do_action('change_vim_cwd') . ":tabnew <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-T><C-S>
          \ defx#do_action('change_vim_cwd') . ":new    <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <C-T><C-V>
          \ defx#do_action('change_vim_cwd') . ":vnew   <Bar> :terminal<CR>i"
    nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
          \ ':<C-U>wincmd w<CR>' :
          \ ':<C-U>Defx -buffer-name=temp -split=vertical<CR>'
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
    nnoremap <silent><buffer><expr> \xx
          \ defx#do_action('call', '<SID>defx_execute')
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

if s:is_enabled_plugin('lightline.vim')
  let g:unite_force_overwrite_statusline = 0
endif

" Unite custom function {{{
" Escape colon, backslash and space
function! s:escape_symbol(expr)
  let l:expr = a:expr
  let l:expr = substitute(l:expr, '\\', '\\\\', 'g')
  let l:expr = substitute(l:expr, ':', '\\:', 'g')
  let l:expr = substitute(l:expr, ' ', '\\ ', 'g')

  return l:expr
endfunction

" TODO Not 100% accurate pattern, increase accuracy
let g:type_pattern_options = {
      \ 'c-family':   ['\v\.%(c|cpp|h|hpp)$',                 '-tc -tcpp'],
      \ 'config':     ['\v\.%(cfg|conf|config|ini)$',         '-tconfig'],
      \ 'css':        ['\v\.%(css|scss)$',                    '-tcss'],
      \ 'csv':        ['\.csv$',                              '-tcsv'],
      \ 'go':         ['\.go$',                               '-tgo'],
      \ 'html':       ['\.html$',                             '-thtml'],
      \ 'javascript': ['\v\.%(js|jsx)$',                      '-tjs'],
      \ 'json':       ['\.json$',                             '-tjson'],
      \ 'log':        ['\.log$',                              '-tlog'],
      \ 'lua':        ['\.lua$',                              '-tlua'],
      \ 'perl':       ['\v\.%(pl|pm|t)$',                      '-tperl'],
      \ 'python':     ['\.py$',                               '-tpy'],
      \ 'ruby':       ['\v%(\.rb|Gemfile|Rakefile)$',         '-truby'],
      \ 'rust':       ['\.rs$',                               '-trust'],
      \ 'shell':      ['\v\.%(bash|bashrc|sh|bash_aliases)$', "-g '{*.sh,.bashrc,.bash_*}'"],
      \ 'sql':        ['\.sql$',                              '-tsql'],
      \ 'txt':        ['\.txt$',                              '-ttxt'],
      \ 'typescript': ['\.ts$',                               "-g '*.ts'"],
      \ 'vim':        ['\v%(\.vim|\.vimrc|_vimrc)$',          "-g '{*.vim,_vimrc}'"],
      \ 'yaml':       ['\v\.%(yaml|yml)$',                    '-tyaml'],
      \ 'wiki':       ['\.wiki$',                             '-twiki'],
      \ }

" TODO Use ripgrep type list
" TODO Change to global function?
" TODO Detect non-file buffer
function! s:rg_current_type_option() abort
  let filename = expand('%:t')

  for [type, value] in items(g:type_pattern_options)
    let pattern = value[0]
    let option = value[1]
    if filename =~ pattern
      return option
    endif
  endfor

  return ''
endfunction

function! s:unite_grep(query, buffer_name_prefix, option, is_word) abort
  let escaped_query = s:escape_symbol(a:query)
  let escaped_option = s:escape_symbol(a:option)
  let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
  let buffer_name = a:buffer_name_prefix . '%' . bufnr('%')

  execute 'Unite -buffer-name=' . buffer_name . ' -wrap grep:.:' . escaped_option . ':' . final_query
endfunction
" }}}

" Unite key mappings {{{
" Unite don't auto-preview file as it's slow
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite -buffer-name=files buffer bookmark file<CR>
if has("nvim")
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>/ :call <SID>unite_grep('', 'grep', '', v:false)<CR>
nnoremap <Space>? :call <SID>unite_grep('', 'grep', input('Option: '), v:false)<CR>
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
nnoremap <Space>uk :call <SID>unite_grep(expand('<cword>'), 'keyword', '', v:false)<CR>
nnoremap <Space>uK :call <SID>unite_grep(expand('<cWORD>'), 'keyword', '', v:false)<CR>
nnoremap <Space>u8 :call <SID>unite_grep(expand('<cword>'), 'keyword', '', v:true)<CR>
nnoremap <Space>u* :call <SID>unite_grep(expand('<cWORD>'), 'keyword', '', v:true)<CR>
xnoremap <Space>uk :<C-U>call <SID>unite_grep(<SID>get_visual_selection(), 'keyword', '', v:false)<CR>
xnoremap <Space>u8 :<C-U>call <SID>unite_grep(<SID>get_visual_selection(), 'keyword', '', v:true)<CR>
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

  nnoremap <Space>g/ :call <SID>unite_grep('', 'grep', <SID>rg_current_type_option(), v:false)<CR>
  nnoremap <Space>g? :call <SID>unite_grep('', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
endif
" }}}

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
  " Overwrite settings.

  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-W>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <C-W>     <Plug>(unite_delete_backward_path)
  imap <buffer> <C-\>'     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x     <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-Z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-Z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-Y>     <Plug>(unite_input_directory)
  nmap <buffer> <C-Y>     <Plug>(unite_input_directory)
  nmap <buffer> <M-a>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <M-c>     <Plug>(unite_print_candidate)
  nmap <buffer> <C-R>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-R><C-R>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-X><C-X>     <Plug>(unite_complete)
  " nnoremap <silent><buffer><expr> l
  "       \ unite#smart_map('l', unite#do_action('default'))

  " Restore tab switch mapping
  nnoremap <buffer> <C-J>     gT
  nnoremap <buffer> <C-K>     gt

  " Move cursor in insert mode
  imap <buffer> <C-J>     <Plug>(unite_select_next_line)
  imap <buffer> <C-K>     <Plug>(unite_select_previous_line)

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

  " Runs "split" action by <C-S>.
  imap <silent><buffer><expr> <C-S>     unite#do_action('split')
  nmap <silent><buffer><expr> <C-S>     unite#do_action('split')

  " Runs "vsplit" action by <C-V>.
  imap <silent><buffer><expr> <C-V>     unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-V>     unite#do_action('vsplit')

  " Runs "tabopen" action by <C-T>.
  nmap <silent><buffer><expr> <C-T>     unite#do_action('tabopen')

  " Runs "persist_open" action by <C-]>.
  imap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')
  nmap <silent><buffer><expr> <C-]>     unite#do_action('persist_open')

  " Simulate "persist_tabopen" action by <M-]>.
  imap <silent><buffer><expr> <M-]>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzv<C-W>k"
  nmap <silent><buffer><expr> <M-]>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzv<C-W>k"

  " Simulate "persist_tabopen_switch" action by <M-[>.
  imap <silent><buffer><expr> <M-[>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzvgt"
  nmap <silent><buffer><expr> <M-[>     unite#do_action('persist_open') . "\<C-W>j:tab split<CR>gT<C-O>zzzvgt"

  " Runs "grep" action by <M-g>.
  imap <silent><buffer><expr> <M-g>     unite#do_action('grep')
  nmap <silent><buffer><expr> <M-g>     unite#do_action('grep')

  " Unmap <Space>, use ` instead
  silent! nunmap <buffer> <Space>
  nmap <silent><buffer> ` <Plug>(unite_toggle_mark_current_candidate)
  silent! xunmap <buffer> <Space>
  xmap <silent><buffer> ` <Plug>(unite_toggle_mark_selected_candidates)
endfunction "}}}
" }}}

" Denite {{{
if s:is_enabled_plugin('denite.nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neoclide/denite-extra'
  Plug 'kmnk/denite-dirmark'

  let g:session_directory = $HOME.'/vim-sessions/'
  let g:denite_source_session_path = $HOME.'/vim-sessions/'
  let g:project_folders = ['/synosrc/packages/source']

  " Denite only has 1 active buffer per tab
  " buffer-name should be tab-based
  function! s:denite_get_buffer_name(prefix) abort
    return a:prefix . '%' . tabpagenr()
  endfunction

  function! s:denite_grep(query, buffer_name_prefix, option, is_word) abort
    let escaped_query = s:escape_symbol(a:query)
    let escaped_option = s:escape_symbol(a:option)
    let final_query = a:is_word ? '\\b' . escaped_query . '\\b' : escaped_query
    let buffer_name = s:denite_get_buffer_name(a:buffer_name_prefix)

    execute 'Denite -buffer-name=' . buffer_name . ' -auto-resume grep:.:' . escaped_option . ':' . final_query
  endfunction

  function! s:denite_project_tags(query)
    let t:origin_tags = &tags
    set tags-=./tags;
    augroup denite_project_tags_callback
      autocmd!
      autocmd BufWinLeave \[denite\]
            \ if exists('t:origin_tags') |
            \   let &tags = t:origin_tags |
            \   autocmd! denite_project_tags_callback |
            \ endif
    augroup END
    execute 'Denite tag -input=' . a:query
  endfunction

  " Denite key mappings {{{
  " Override Unite key mapping {{{
  function! s:remap(old_key, new_key, mode)
    let mapping = maparg(a:old_key, a:mode)

    if !empty(mapping)
      execute a:mode . 'unmap ' . a:old_key
      execute a:mode . 'noremap ' . a:new_key . ' ' . mapping
    endif
  endfunction
  call s:remap('<Space>up', '<Space>u<C-P>', 'n') " UniteWithProjectDir file
  call s:remap('<Space>P',  '<Space>uP',     'n') " Unite file/rec
  call s:remap('<Space>p',  '<Space>up',     'n') " Unite file
  call s:remap('<Space>ul', '<Space>uL',     'n') " UniteWithCursorWord line
  call s:remap('<Space>l',  '<Space>ul',     'n') " Unite line
  call s:remap('<Space>o',  '<Space>O',      'n') " Unite outline

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
  nnoremap <Space>di :call <SID>denite_grep('!', 'grep', '', v:false)<CR>
  nnoremap <Space>dk :call <SID>denite_grep(expand('<cword>'), 'grep', '', v:false)<CR>
  nnoremap <Space>dK :call <SID>denite_grep(expand('<cWORD>'), 'grep', '', v:false)<CR>
  nnoremap <Space>d8 :call <SID>denite_grep(expand('<cword>'), 'grep', '', v:true)<CR>
  nnoremap <Space>d* :call <SID>denite_grep(expand('<cWORD>'), 'grep', '', v:true)<CR>
  xnoremap <Space>dk :<C-U>call <SID>denite_grep(<SID>get_visual_selection(), 'grep', '', v:false)<CR>
  xnoremap <Space>d8 :<C-U>call <SID>denite_grep(<SID>get_visual_selection(), 'grep', '', v:true)<CR>
  nnoremap <Space>dm :Denite file_mru<CR>
  nnoremap <Space>dM :Denite directory_mru<CR>
  nnoremap <Space>do :execute 'Denite output:' . <SID>escape_symbol(input('output: '))<CR>
  nnoremap <Space>dO :Denite outline<CR>
  nnoremap <Space>d<C-O> :Denite unite:outline<CR>
  nnoremap <Space>dp :call <SID>denite_project_tags('')<CR>
  nnoremap <Space>dP :call <SID>denite_project_tags(expand('<cword>'))<CR>
  nnoremap <Space>dq :Denite quickfix<CR>
  nnoremap <Space>dr :Denite register<CR>
  nnoremap <Space>ds :Denite session<CR>
  nnoremap <Space>d<Space> :Denite source<CR>
  nnoremap <Space>dt :Denite tag<CR>
  nnoremap <Space>du :Denite -resume<CR>
  nnoremap <Space>dU :Denite -resume -buffer-name=`call(g:sid.'denite_get_buffer_name', ['grep'])`<CR>
  nnoremap <Space>d<C-U> :Denite -resume -refresh -buffer-name=`call(g:sid.'denite_get_buffer_name', ['grep'])`<CR>
  nnoremap <Space>dx :Denite defx/history<CR>
  nnoremap <Space>dy :Denite neoyank<CR>
  nnoremap <Space>d: :Denite command_history<CR>
  nnoremap <Space>d; :Denite command<CR>
  nnoremap <Space>d/ :call <SID>denite_grep('', 'grep', '', v:false)<CR>
  nnoremap <Space>d? :call <SID>denite_grep('', 'grep', input('Option: '), v:false)<CR>

  nnoremap <silent> [d :Denite -resume -immediately -cursor-pos=-1<CR>
  nnoremap <silent> ]d :Denite -resume -immediately -cursor-pos=+1<CR>
  nnoremap <silent> [D :Denite -resume -immediately -cursor-pos=-1 -buffer-name=`call(g:sid.'denite_get_buffer_name', ['grep'])`<CR>
  nnoremap <silent> ]D :Denite -resume -immediately -cursor-pos=+1 -buffer-name=`call(g:sid.'denite_get_buffer_name', ['grep'])`<CR>

  if executable('rg')
    nnoremap <Space>dg/ :call <SID>denite_grep('', 'grep', <SID>rg_current_type_option(), v:false)<CR>
    nnoremap <Space>dg? :call <SID>denite_grep('', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
  endif
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
  let @" = joined_lines
endfunction
function! s:open_terminal(lines)
  let path = a:lines[0]
  let folder = isdirectory(path) ? path : fnamemodify(path, ':p:h')
  tabe
  execute 'lcd ' . folder
  terminal
  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

let g:misc_fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'alt-c':  function('s:copy_results'),
      \ 'alt-e':  'cd',
      \ }
if has('nvim')
  let g:misc_fzf_action['alt-t'] = function('s:open_terminal')
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
" fzf utility functions borrowed from fzf.vim {{{
function! s:warn(message)
  echohl WarningMsg | echom a:message | echohl None
endfunction

" For using g:fzf_action in custom sink function
" Don't return function, as function in g:fzf_action will only accept a:lines
" or a:line, which is probably not what the caller want.
let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}
function! s:action_for(key, ...)
  let default = a:0 ? a:1 : ''
  let Cmd = get(g:fzf_action, a:key, default)
  return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

" For filling quickfix in custom sink function
function! s:fill_quickfix(list, ...)
  if len(a:list) > 1
    call setqflist(a:list)
    copen
    wincmd p
    if a:0
      execute a:1
    endif
  endif
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

function! s:wrap(name, opts, bang)
  " fzf#wrap does not append --expect if sink or sink* is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == s:TYPE.list ? join(opts.options) : opts.options
  endif
  if options !~ '--expect' && has_key(opts, 'sink*')
    let Sink = remove(opts, 'sink*')
    let wrapped = fzf#wrap(a:name, opts, a:bang)
    let wrapped['sink*'] = Sink
  else
    let wrapped = fzf#wrap(a:name, opts, a:bang)
  endif
  return wrapped
endfunction
" }}}

command! -bar  -bang                  Helptags call fzf#vim#helptags(<bang>0)
command! -bang -nargs=? -complete=dir Files    call s:fzf_files(<q-args>, <bang>0)
command! -bang -nargs=?               GFiles   call s:fzf_gitfiles(<q-args>, <bang>0)
command! -bang -nargs=*               History  call s:history(<q-args>, <bang>0)
command! -bar  -bang                  Windows  call fzf#vim#windows(s:fzf_windows_preview(), <bang>0)
command! -bar  -nargs=* -bang         BLines   call fzf#vim#buffer_lines(<q-args>, s:fzf_buffer_lines_preview(), <bang>0)

" borrowed from fzf.vim {{{
function! s:history(arg, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  if a:arg[0] == ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] == '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(fzf#vim#with_preview(), bang)
  endif
endfunction
" }}}

function! s:fzf_files(path, bang)
  call fzf#vim#files(a:path, fzf#vim#with_preview(), a:bang)
endfunction

function! s:fzf_gitfiles(args, bang) abort
  if a:args != '?'
    return call('fzf#vim#gitfiles', [a:args, fzf#vim#with_preview(), a:bang])
  else
    return call('fzf#vim#gitfiles', [a:args, a:bang])
  endif
endfunction

function! s:fzf_windows_preview() abort
  let options = fzf#vim#with_preview()
  let preview_script = remove(options.options, -1)[0:-4]
  let get_filename_script = expand($VIMHOME . '/bin/fzf_windows_preview.sh')
  let final_script = preview_script . ' "$(' . get_filename_script . ' {})"'

  call remove(options.options, -1) " remove --preview
  call extend(options.options, ['--preview', final_script])
  return options
endfunction

function! s:fzf_buffer_lines_preview() abort
  let file = expand('%')
  let preview_top = 1
  let preview_command = systemlist($VIMHOME . '/bin/generate_fzf_preview_with_bat.sh ' . file . ' ' . preview_top)[0]

  return { 'options': ['--preview-window', 'right:50%:hidden', '--preview', preview_command] }
endfunction

" Currently not used
function! s:fzf_files_sink(lines)
  echom string(a:lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0], 'edit')
  for target in a:lines[1:]
    if type(cmd) == type(function('call'))
      cmd(target)
    else
      execute cmd . ' ' . target
    endif
  endfor
endfunction

let g:fzf_preview_command = 'cat {}'
if executable('bat')
  let g:fzf_preview_command = 'bat --style=numbers --color=always {}'
endif
let g:fzf_dir_preview_command = 'ls -la --color=always {}'
if executable('exa')
  let g:fzf_dir_preview_command = 'exa -lag --color=always {}'
endif

" let g:rg_command = '
"     \ rg --column --line-number --no-heading --ignore-case --no-ignore --hidden --follow --color "always"
"     \ -g "*.{js,json,php,md,styl,pug,jade,html,config,py,cpp,c,go,hs,rb,conf,fa,lst,lua,pm,vim,sh,h,hpp}"
"     \ -g "!{.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist}/*" '
" Manually specify ignore file as ripgrep 0.9.0 will not respect to .gitignore outside of git repository
let g:rg_base_command = 'rg --column --line-number --no-heading --smart-case --color=always --follow --with-filename '
let g:rg_command = g:rg_base_command . '--ignore-file ' . $HOME . '/.gitignore ' " TODO Use '.ignore'?
let g:rg_all_command = g:rg_base_command . '--no-ignore --hidden '
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
        \        : g:rg_command.option.' '.shellescape(query).' '.folder, 1,
        \ a:bang ? fzf#vim#with_preview('up:60%')
        \        : fzf#vim#with_preview('right:50%:hidden', '?'),
        \ a:bang)
endfunction

let g:fd_command = 'fd --no-ignore --hidden --follow'
command! -bang -nargs=? -complete=dir AllFiles call fzf#vim#files(<q-args>,
      \ <bang>0 ? extend({ 'source': g:fd_command }, fzf#vim#with_preview('up:60%'))
      \         : extend({ 'source': g:fd_command }, fzf#vim#with_preview()),
      \ <bang>0)

let g:git_diff_tree_command = 'git diff-tree --no-commit-id --name-only -r '
command! -bang -nargs=* -complete=dir GitDiffFiles call s:git_diff_tree(<bang>0, <f-args>)
" s:git_diff_tree([bang], [commit], [folder])
function! s:git_diff_tree(...)
  if a:0 > 3
    return s:warn('Invalid argument number')
  endif

  let bang   = a:0 >= 1 ? a:1 : 0
  let commit = a:0 >= 2 ? a:2 : 'HEAD'
  let folder = a:0 == 3 ? a:3 : ''

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return s:warn('not in git repo')
  endif

  call fzf#vim#files(
        \ folder,
        \ extend({
        \   'source': g:git_diff_tree_command . commit
        \ }, fzf#vim#with_preview()),
        \ bang)
endfunction

let g:rg_git_diff_tree_command = 'git -C %s diff-tree -z --no-commit-id --name-only -r %s | xargs -0 ' . g:rg_base_command . ' -- %s'
command! -bang -nargs=* -complete=dir RgGitDiffFiles call s:rg_git_diff_tree(<bang>0, <f-args>)
" s:rg_git_diff_tree([bang], [pattern], [commit], [folder])
function! s:rg_git_diff_tree(...)
  if a:0 > 4
    return s:warn('Invalid argument number')
  endif

  let bang    = a:0 >= 1 ? a:1 : 0
  let pattern = a:0 >= 2 ? a:2 : '.'
  let commit  = a:0 >= 3 ? a:3 : 'HEAD'
  let folder  = a:0 == 4 ? a:4 : '.'

  let git_dir = FugitiveExtractGitDir(expand(folder))
  if empty(git_dir)
    return s:warn('not in git repo')
  endif

  let command = printf(g:rg_git_diff_tree_command, folder, commit, shellescape(pattern))

  call fzf#vim#grep(
        \ command, 1,
        \ bang ? fzf#vim#with_preview('up:60%')
        \      : fzf#vim#with_preview('right:50%:hidden', '?'),
        \ bang)
endfunction

" use neomru
function! s:filtered_neomru_files()
  return filter(readfile(g:neomru#file_mru_path)[1:],
        \ "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\\[unite\\]\\|\[Preview\\]\\|__Tagbar__\\|term://\\|gina://'")
endfunction
command! Mru call fzf#run(fzf#wrap({
      \ 'source':  s:mru_files(),
      \ 'options': '-m -s',
      \ 'down':    '40%' }))
function! s:mru_files()
  return extend(
  \ s:filtered_neomru_files(),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

command! ProjectMru call fzf#run(fzf#wrap({
      \ 'source':  s:project_mru_files(),
      \ 'options': '-m -s',
      \ 'down':    '40%' }))
" use neomru
function! s:project_mru_files()
  " cannot use \V to escape the special characters in filepath as it only
  " render the string literal after it to "very nomagic"
  return extend(
  \ filter(s:filtered_neomru_files(),
  \   "v:val =~ '^' . getcwd()"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

command! -bang DirectoryMru call s:directory_mru(<bang>0)
function! s:directory_mru(bang, ...)
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  s:mru_directories(),
        \ 'options': ['-s', '--preview-window', 'right', '--preview', g:fzf_dir_preview_command],
        \ 'down':    '40%'
        \ }

  if empty(Sink)
    call fzf#vim#files('', args, a:bang)
  else
    call fzf#vim#files('', extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction
" use neomru
function! s:mru_directories()
  return extend(
  \ readfile(g:neomru#directory_mru_path)[1:],
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), "fnamemodify(bufname(v:val), ':p:h')"))
endfunction

command! -bang DirectoryMruFiles call s:directory_mru_files(<bang>0)
function! s:directory_mru_files(bang)
  call s:directory_mru(a:bang, function('s:directory_mru_files_sink'))
endfunction
function! s:directory_mru_files_sink(line)
  execute 'Files ' . a:line
  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

command! -bang DirectoryMruRg call s:directory_mru_rg(<bang>0)
function! s:directory_mru_rg(bang)
  call s:directory_mru(a:bang, function('s:directory_mru_rg_sink'))
endfunction
function! s:directory_mru_rg_sink(line)
  execute 'RgWithOption ' . a:line . '::' . input('Rg: ')
  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

let g:fd_dir_command = 'fd --type directory --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore'
command! -bang -nargs=? Directories call s:directories(<q-args>, <bang>0)
function! s:directories(path, bang, ...)
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  g:fd_dir_command,
        \ 'options': ['-s', '--preview-window', 'right', '--preview', g:fzf_dir_preview_command],
        \ 'down':    '40%'
        \ }

  if empty(Sink)
    call fzf#vim#files(a:path, args, a:bang)
  else
    call fzf#vim#files(a:path, extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction
" TODO Refine popd_callback that use counter to activate
function! s:directory_sink(original_cwd, path, Func, line)
  " Avoid fzf_popd autocmd that break further fzf commands that require
  " current changed working directory.
  " See s:dopopd() in fzf/plugin/fzf.vim

  if exists('w:fzf_pushd')
    let w:directory_sink_popd = {
          \ 'original_cwd': a:original_cwd,
          \ 'popd_counter': 2,
          \ 'bufname': w:fzf_pushd.bufname
          \ }
    unlet w:fzf_pushd

    augroup popd_callback
      autocmd!
      autocmd BufWinEnter,WinEnter * call s:popd_callback()
    augroup END
  endif
  execute 'lcd ' . simplify(a:original_cwd . '/' . a:path)
  call a:Func(a:line)
endfunction
function! s:popd_callback()
  if !exists('w:directory_sink_popd')
    return
  endif

  " Check if current buffer is the original buffer
  let orignal_bufname = w:directory_sink_popd.original_cwd . '/' . w:directory_sink_popd.bufname
  if fnamemodify(orignal_bufname, ':p') !=# fnamemodify(bufname(''), ':p')
    return
  endif

  let w:directory_sink_popd.popd_counter -= 1
  if w:directory_sink_popd.popd_counter == 0
    execute 'lcd ' . w:directory_sink_popd.original_cwd
    unlet w:directory_sink_popd
    autocmd! popd_callback
  endif
endfunction

command! -bang -nargs=? DirectoryFiles call s:directory_files(<q-args>, <bang>0)
function! s:directory_files(path, bang)
  call s:directories(a:path, a:bang, function('s:directory_sink', [getcwd(), a:path, function('s:directory_mru_files_sink')]))
endfunction

command! -bang -nargs=? DirectoryRg call s:directory_rg(<q-args>, <bang>0)
function! s:directory_rg(path, bang)
  call s:directories(a:path, a:bang, function('s:directory_sink', [getcwd(), a:path, function('s:directory_mru_rg_sink')]))
endfunction

" Intend to be mapped in command
function! s:files_in_commandline()
  " Use tmux to avoid opening terminal in neovim
  let g:fzf_prefer_tmux = 1
  call fzf#vim#files(
        \ '',
        \ extend({
        \   'sink': function('s:files_in_commandline_sink'),
        \ }, fzf#vim#with_preview()),
        \ 0)
  let g:fzf_prefer_tmux = 0
  return s:files_in_commandline_result
endfunction
function! s:files_in_commandline_sink(line)
  let s:files_in_commandline_result = a:line
endfunction

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

function! s:tselect_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0], 'edit')
  let qfl = []
  for target in a:lines[1:]
    let infos = split(target, "\t")
    " # [pri] kind tag file
    " This will capture last component
    let filename = matchlist(infos[0], '\v^%(\s+\S+)*\s+(\S+)')[1]
    let pattern = substitute(infos[-1], '^\s*\(.\{-}\)\s*$', '\1', '')
    execute cmd . ' ' . filename
    execute '/\V' . pattern
    call add(qfl, {'filename': expand('%'), 'lnum': line('.'), 'text': getline('.')})
    normal! zzzv
  endfor
  call s:fill_quickfix(qfl, 'clast')
  normal! zzzv
endfunction

function! s:get_tselect(query)
  let tselect_output = split(execute("tselect " . a:query, "silent!"), "\n")[1:-2]
  let tselect_candidates = []
  let tselect_current_candidate = []
  for line in tselect_output
    if line =~ '^\s\+\d'
      if !empty(tselect_current_candidate)
        call add(tselect_candidates, join(tselect_current_candidate, "\t"))
        let tselect_current_candidate = []
      endif
    endif

    call add(tselect_current_candidate, line)
  endfor
  if !empty(tselect_current_candidate)
    call add(tselect_candidates, join(tselect_current_candidate, "\t"))
  endif

  return tselect_candidates
endfunction
command! -nargs=1 Tselect call fzf#run(fzf#wrap({
      \ 'source': s:get_tselect(<q-args>),
      \ 'sink*':   function('s:tselect_sink'),
      \ 'options': '-m +s --expect=' . join(keys(g:fzf_action), ','),
      \ 'down':   '40%'}))

" TODO Add Jumps command preview
" TODO Use <C-O> & <C-I> to actually jump back and forth
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
function! s:range_lines_handler(center, lines)
  echom string(a:lines)
  if len(a:lines) < 2
    return
  endif
  let qfl = []
  for line in a:lines[1:]
    let chunks = split(line, "\t", 1)
    let ln = chunks[0]
    let ltxt = join(chunks[1:], "\t")
    call add(qfl, {'filename': expand('%'), 'lnum': str2nr(ln), 'text': ltxt})
  endfor
  call s:fill_quickfix(qfl, 'cfirst')
  normal! m'
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif

  execute split(a:lines[1], '\t')[0]

  if a:center
    normal! zzzv
  endif
endfunction

" Borrowed from s:buffer_lines from fzf.vim
function! s:range_lines_source(start, end, query)
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
function! s:range_lines(prompt, center, start, end, query)
  let options = ['--tiebreak=index', '--multi', '--prompt', a:prompt . '> ', '--ansi', '--extended', '--nth=2..', '--layout=reverse-list', '--tabstop=1']
  let file = expand('%')
  let preview_command = systemlist($VIMHOME . '/bin/generate_fzf_preview_with_bat.sh ' . file . ' ' . a:start)[0]
  let final_options = extend(options, ['--preview-window', 'right:50%:hidden', '--preview', preview_command])
  let Sink = function('s:range_lines_handler', [a:center])

  call fzf#run(s:wrap('', {
        \ 'source':  s:range_lines_source(a:start, a:end, a:query),
        \ 'sink*':   Sink,
        \ 'options': final_options,
        \ }, 0))
endfunction
command! -nargs=? -range SelectLines call s:range_lines('SelectLines', 1, <line1>, <line2>, <q-args>)
function! s:screen_lines(...)
  let query = (a:0 && type(a:1) == type('')) ? a:1 : ''

  let save_cursor = getcurpos()
  normal H
  let start = getpos('.')[1]
  normal L
  let end = getpos('.')[1]
  call setpos('.', save_cursor)

  call s:range_lines('ScreenLines', 0, start, end, query)
endfunction
command! -nargs=? ScreenLines call s:screen_lines(<q-args>)

function! s:files_with_query(query)
  Files
  call feedkeys(a:query)
endfunction
command! -nargs=1 FilesWithQuery call s:files_with_query(<q-args>)

" TODO Add sign text and highlight
function! s:current_placed_signs_source()
  let linefmt = s:yellow(" %4d ", "LineNr")."\t%s"
  let fmtexpr = 'printf(linefmt, v:val[0], v:val[1])'
  let current_placed_signs = split(execute("sign place buffer=" . bufnr('%'), "silent!"), "\n")[2:]
  let line_numbers = map(current_placed_signs, "str2nr(matchstr(v:val, '\\d\\+', 9))")
  let uniq_line_numbers = uniq(line_numbers) " Remove duplicate line numbers as both GitGutter and GitP will place sign on same lines
  let lines = map(uniq_line_numbers, "[v:val, getline(v:val)]")
  let formatted_lines = map(lines, fmtexpr)
  return formatted_lines
endfunction
function! s:current_placed_signs()
  call fzf#run(fzf#wrap({
        \ 'source':  s:current_placed_signs_source(),
        \ 'sink*':   function('s:range_lines_center_handler'),
        \ 'options': ['--tiebreak=index', '--prompt', 'Signs> ', '--ansi', '--extended', '--nth=2..', '--layout=reverse-list', '--tabstop=1'],
        \ }))
endfunction
command! CurrentPlacedSigns call s:current_placed_signs()

function! s:functions_sink(line)
  let function_name = matchstr(a:line, '\s\zs\S[^(]*\ze(')
  let @" = function_name
endfunction
function! s:functions_source()
  return split(execute("function", "silent!"), "\n")
endfunction
function! s:functions()
  call fzf#run(fzf#wrap({
      \ 'source':  s:functions_source(),
      \ 'sink':    function('s:functions_sink'),
      \ 'down':    '40%'}))
endfunction
command! Functions call s:functions()

" Cscope functions {{{
" Borrowed from: https://gist.github.com/amitab/cd051f1ea23c588109c6cfcb7d1d5776
function! s:cscope_sink(lines)
  if len(a:lines) < 2
    return
  end
  let cmd = s:action_for(a:lines[0], 'edit')
  let qfl = []
  for result in a:lines[1:]
    let text = join(split(result)[1:])
    let [filename, line_number] = split(split(result)[0], ":")
    call add(qfl, {'filename': filename, 'lnum': line_number, 'text': text})
  endfor
  call s:fill_quickfix(qfl)
  for qf in qfl
    execute cmd . ' +' . qf.lnum . ' ' . qf.filename
    normal! zzzv
  endfor
endfunction

function! s:cscope(option, query)
  let expect_keys = join(keys(g:fzf_action), ',')
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s:\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  let opts = {
  \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
  \ 'sink*': function('s:cscope_sink'),
  \ 'options': extend(['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104',
  \             '--expect=' . expect_keys], fzf#vim#with_preview('right:50%:hidden', '?').options),
  \ 'down': '40%'
  \ }
  call fzf#run(opts)
endfunction

function! s:cscope_query(option)
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
    call s:cscope(a:option, query)
  else
    echom "Cancelled Search!"
  endif
endfunction
" }}}

if has("nvim")
  function! s:fzf_statusline()
    highlight fzf1 ctermfg=242 ctermbg=236 guifg=#7c6f64 guibg=#32302f
    highlight fzf2 ctermfg=143 guifg=#b8bb26
    highlight fzf3 ctermfg=15 ctermbg=239 guifg=#ebdbb2 guibg=#504945
    setlocal statusline=%#fzf1#\ >\ %#fzf2#fzf%#fzf3#
  endfunction
  autocmd! User FzfStatusLine call <SID>fzf_statusline()

  function! s:project_tags(query, ...)
    let s:origin_tags = &tags
    set tags-=./tags;
    augroup project_tags_callback
      autocmd!
      autocmd TermClose term://*fzf*
            \ let &tags = s:origin_tags |
            \ autocmd! project_tags_callback
    augroup END
    call call('fzf#vim#tags', [a:query] + a:000)
  endfunction
  command! -bang -nargs=* ProjectTags call s:project_tags(<q-args>, <bang>0)
  " Too bad fzf cannot toggle case sensitive interactively
  command! -bang -nargs=* BTagsCaseSentitive       call fzf#vim#buffer_tags(<q-args>, { 'options': ['+i'] }, <bang>0)
  command! -bang -nargs=* TagsCaseSentitive        call fzf#vim#tags(<q-args>,        { 'options': ['+i'] }, <bang>0)
  command! -bang -nargs=* ProjectTagsCaseSentitive call s:project_tags(<q-args>,      { 'options': ['+i'] }, <bang>0)

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
  command! TagbarTags call s:tagbar_tags()
endif

if s:is_enabled_plugin('defx')
  let g:defx_fzf_action = extend({
        \ 'enter':      'DefxOpenSink',
        \ 'ctrl-t':     'DefxTabOpenSink',
        \ 'ctrl-s':     'DefxSplitOpenSink',
        \ 'ctrl-x':     'DefxSplitOpenSink',
        \ 'ctrl-v':     'DefxVSplitOpenSink',
        \ 'alt-v':      'DefxRightVSplitOpenSink',
        \ 'alt-x':      'DefxOpenDirSink',
        \ 'ctrl-alt-x': 'DefxSplitOpenDirSink',
        \ }, g:misc_fzf_action)

  " TODO s:common_sink() in fzf/plugin/fzf.vim will always use 'edit' if it
  " think the current file is empty file. It's hard to workaround the check
  " and still does not interfere other things like buffer list.
  function! s:use_defx_fzf_action(function)
    let g:fzf_action = g:defx_fzf_action
    augroup use_defx_fzf_action_callback
      autocmd!
      autocmd TermClose term://*fzf*
            \ let g:fzf_action = g:default_fzf_action |
            \ autocmd! use_defx_fzf_action_callback
    augroup END
    call a:function()
  endfunction
  command! -bang -nargs=? -complete=dir Files    call s:use_defx_fzf_action({ -> s:fzf_files(<q-args>, <bang>0) })
  command! -bang -nargs=?               GFiles   call s:use_defx_fzf_action({ -> s:fzf_gitfiles(<q-args>, <bang>0) })

  command! -bang          DirectoryMru      call s:use_defx_fzf_action({ -> s:directory_mru(<bang>0) })
  command! -bang -nargs=? Directories       call s:use_defx_fzf_action({ -> s:directories(<q-args>, <bang>0) })
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
nnoremap <Space>fG :execute 'GGrep ' . input('Git grep: ')<CR>
nnoremap <Space>fh :Helptags<CR>
nnoremap <Space>fi :History<CR>
nnoremap <Space>fj :Jump<CR>
nnoremap <Space>fk :execute 'Rg ' . expand('<cword>')<CR>
nnoremap <Space>fK :execute 'Rg ' . expand('<cWORD>')<CR>
nnoremap <Space>f8 :execute 'Rg \b' . expand('<cword>') . '\b'<CR>
nnoremap <Space>f* :execute 'Rg \b' . expand('<cWORD>') . '\b'<CR>
xnoremap <Space>fk :<C-U>execute 'Rg ' . <SID>get_visual_selection()<CR>
xnoremap <Space>f8 :<C-U>execute 'Rg \b' . <SID>get_visual_selection() . '\b'<CR>
nnoremap <Space>fl :BLines<CR>
nnoremap <Space>fL :Lines<CR>
nnoremap <Space>f<C-L> :execute 'BLines ' . expand('<cword>')<CR>
nnoremap <Space>fm :Mru<CR>
nnoremap <Space>fM :DirectoryMru<CR>
nnoremap <Space>f<C-M> :ProjectMru<CR>
nnoremap <Space>fn :execute 'FilesWithQuery ' . expand('<cword>')<CR>
nnoremap <Space>fN :execute 'FilesWithQuery ' . expand('<cWORD>')<CR>
nnoremap <Space>f% :execute 'FilesWithQuery ' . expand('%:t:r')<CR>
xnoremap <Space>fn :<C-U>execute 'FilesWithQuery ' . <SID>get_visual_selection()<CR>
nnoremap <Space>fo :execute 'Locate ' . input('Locate: ')<CR>
nnoremap <Space>fr :execute 'Rg ' . input('Rg: ')<CR>
nnoremap <Space>fR :execute 'Rg! ' . input('Rg!: ')<CR>
nnoremap <Space>f4 :execute 'RgWithOption .:' . input('Option: ') . ':' . input('Rg: ')<CR>
nnoremap <Space>f$ :execute 'RgWithOption! .:' . input('Option: ') . ':' . input('Rg!: ')<CR>
nnoremap <Space>f? :execute 'RgWithOption .:' . <SID>rg_current_type_option() . ':' . input('Rg: ')<CR>
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
xnoremap <Space>f] :<C-U>execute "BTags '" . <SID>get_visual_selection()<CR>
nnoremap <Space>f} :execute "Tags '" . expand('<cword>')<CR>
xnoremap <Space>f} :<C-U>execute "Tags '" . <SID>get_visual_selection()<CR>
nnoremap <Space>f<C-]> :execute 'Tselect ' . expand('<cword>')<CR>
xnoremap <Space>f<C-]> :<C-U>execute 'Tselect ' . <SID>get_visual_selection()<CR>

" DirectoryMru
nnoremap <Space><C-D><C-D> :DirectoryMru<CR>
nnoremap <Space><C-D><C-F> :DirectoryMruFiles<CR>
nnoremap <Space><C-D><C-R> :DirectoryMruRg<CR>

nmap     <Space>sf vaf:SelectLines<CR>
xnoremap <Space>sf :SelectLines<CR>
nnoremap <Space>sl :ScreenLines<CR>
nnoremap <Space>sL :execute 'ScreenLines ' . expand('<cword>')<CR>
xnoremap <Space>sL :<C-U>execute 'ScreenLines ' . <SID>get_visual_selection()<CR>
nnoremap <Space>ss :History:<CR>mks vim sessions

" fzf & cscope key mappings {{{
nnoremap <silent> <Leader>cs :call <SID>cscope('0', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cg :call <SID>cscope('1', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cd :call <SID>cscope('2', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cc :call <SID>cscope('3', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ct :call <SID>cscope('4', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ce :call <SID>cscope('6', expand('<cword>'))<CR>
nnoremap <silent> <Leader>cf :call <SID>cscope('7', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ci :call <SID>cscope('8', expand('<cword>'))<CR>
nnoremap <silent> <Leader>ca :call <SID>cscope('9', expand('<cword>'))<CR>

xnoremap <silent> <Leader>cs :<C-U>call <SID>cscope('0', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>cg :<C-U>call <SID>cscope('1', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>cd :<C-U>call <SID>cscope('2', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>cc :<C-U>call <SID>cscope('3', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>ct :<C-U>call <SID>cscope('4', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>ce :<C-U>call <SID>cscope('6', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>cf :<C-U>call <SID>cscope('7', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>ci :<C-U>call <SID>cscope('8', <SID>get_visual_selection())<CR>
xnoremap <silent> <Leader>ca :<C-U>call <SID>cscope('9', <SID>get_visual_selection())<CR>

nnoremap <silent> <Leader><Leader>cs :call <SID>cscope_query('0')<CR>
nnoremap <silent> <Leader><Leader>cg :call <SID>cscope_query('1')<CR>
nnoremap <silent> <Leader><Leader>cd :call <SID>cscope_query('2')<CR>
nnoremap <silent> <Leader><Leader>cc :call <SID>cscope_query('3')<CR>
nnoremap <silent> <Leader><Leader>ct :call <SID>cscope_query('4')<CR>
nnoremap <silent> <Leader><Leader>ce :call <SID>cscope_query('6')<CR>
nnoremap <silent> <Leader><Leader>cf :call <SID>cscope_query('7')<CR>
nnoremap <silent> <Leader><Leader>ci :call <SID>cscope_query('8')<CR>
nnoremap <silent> <Leader><Leader>ca :call <SID>cscope_query('9')<CR>
" }}}

if has("nvim")
  nnoremap <Space>fp :ProjectTags<CR>
  nnoremap <Space>sp :ProjectTagsCaseSentitive<CR>
  nnoremap <Space>fP :execute "ProjectTags '" . expand('<cword>')<CR>
  xnoremap <Space>fP :<C-U>execute "ProjectTags '" . <SID>get_visual_selection()<CR>
  nnoremap <Space><F8> :TagbarTags<CR>
endif
" }}}
" }}}

" skim {{{
Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }

command! SkimMru call skim#run(skim#wrap({
      \ 'source':  s:mru_files(),
      \ 'options': '-m',
      \ 'down':    '40%' }))

nnoremap <Space>sm :SkimMru<CR>
" }}}

" vifm {{{
Plug 'vifm/vifm.vim'
" }}}

" vim-gutentags {{{
if s:is_enabled_plugin('vim-gutentags')
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
  autocmd BufWinLeave,WinLeave * call s:clear_incsearch_nohlsearch()
augroup END

function! s:clear_incsearch_nohlsearch()
  nohlsearch

  " clear incsearch-nohlsearch
  silent! autocmd! incsearch-auto-nohlsearch
endfunction
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
map <Space>sF :call <SID>clear_incsearch_nohlsearch()<CR>vaf<M-/>

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
if s:is_enabled_plugin('ale')
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
        \ 'python': ['pylint']
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
if s:has_jedi()
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

function! s:review_last_commit()
  if exists('b:git_dir')
    Gtabedit HEAD^{}
    nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction
nnoremap <silent> <Leader>g` :call <SID>review_last_commit()<CR>

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd FileType fugitive call s:fugitive_settings()
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

function! s:fugitive_settings()
  nnoremap <buffer> <silent> Su :GitDispatch stash -u<CR>
  nnoremap <buffer> <silent> Sp :GitDispatch stash pop<CR>
  nnoremap <buffer> <silent> gp :Gpush<CR>
  nnoremap <buffer> <silent> gl :Gpull<CR>
  nnoremap <buffer> <silent> gL :Gpull --rebase<CR>
endfunction

let g:fugitive_gitlab_domains = ['https://git.synology.com']

command! -nargs=? GitDiffCommit call s:git_diff_commit(<f-args>)
function! s:git_diff_commit(commit)
  if exists('b:git_dir')
    let files = systemlist('git diff --name-only ' . a:commit . '^!')
    let current_tabnr = tabpagenr()
    for file in files
      execute 'tabedit ' . file
    endfor
    let last_tabnr = tabpagenr()
    let range = current_tabnr + 1 . ',' . last_tabnr

    execute range . 'tabdo Gedit ' . a:commit . '^:%'
    execute range . 'tabdo Gdiff ' . a:commit
  else
    echo 'No git a git repository:' expand('%:p')
  endif
endfunction

" Borrowed from vim-fugitive {{{
let s:common_efm = ''
      \ . '%+Egit:%.%#,'
      \ . '%+Eusage:%.%#,'
      \ . '%+Eerror:%.%#,'
      \ . '%+Efatal:%.%#,'
      \ . '%-G%.%#%\e[K%.%#,'
      \ . '%-G%.%#%\r%.%\+'
" }}}

" Borrowed and modified from vim-fugitive s:Dispatch
command! -nargs=* GitDispatch call s:git_dispatch(<q-args>)
function! s:git_dispatch(command)
  let [mp, efm, cc] = [&l:mp, &l:efm, get(b:, 'current_compiler', '')]
  try
    let b:current_compiler = 'git'
    let &l:errorformat = s:common_efm
    let &l:makeprg = 'git ' . a:command
    Make!
  finally
    let [&l:mp, &l:efm, b:current_compiler] = [mp, efm, cc]
    if empty(cc) | unlet! b:current_compiler | endif
  endtry
endfunction
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

function! s:gv_expand()
  let line = getline('.')
  GV --name-status
  call search('\V'.line, 'c')
  normal! zz
endfunction

augroup gv_settings
  autocmd!
  autocmd FileType GV call s:gv_settings()
augroup END

function! s:gv_settings()
  nnoremap <silent><buffer> + :call <SID>gv_expand()<CR>
  nnoremap <silent><buffer> <Leader>gd :call <SID>git_diff_commit(gv#sha())<CR>
endfunction
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

" Add '' to open tig main view
nnoremap \tr :Tig ''<CR>
nnoremap \tt :tabnew <Bar> Tig ''<CR>
nnoremap \ts :new    <Bar> Tig ''<CR>
nnoremap \tv :vnew   <Bar> Tig ''<CR>
nnoremap \tl :execute 'new <Bar> Tig log -p ' . expand('%:p')<CR>
" }}}

" Gina {{{
Plug 'lambdalisue/gina.vim'

nnoremap <Space>gb :Gina blame<CR>
xnoremap <Space>gb :Gina blame<CR>
nnoremap <Space>gB :Gina branch<CR>
" }}}

" git-p.nvim {{{
" Disable git-p.nvim in nested neovim due to channel error
if s:is_enabled_plugin('git-p.nvim')
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
  autocmd! FileType qf call s:qfreplace_settings()
augroup END

function! s:qfreplace_settings()
  nnoremap <silent><buffer> r :<C-U>Qfreplace<CR>
endfunction
" }}}

" vim-caser {{{
Plug 'arthurxavierx/vim-caser'
" }}}

" vim-highlightedyank {{{
if s:is_enabled_plugin('vim-highlightedyank')
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
" coc.nvim {{{
if s:is_enabled_plugin('coc.nvim')
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
if s:is_enabled_plugin('deoplete.nvim')
  " Use smartcase.
  call deoplete#custom#option('smart_case', v:true)
endif
" }}}

" Unite {{{
" Avoid remapped by unimpaired
" TODO Move all plugin settings to post-loaded settings
augroup post_loaded_unite_mappings
  autocmd!
  autocmd VimEnter * call s:post_loaded_unite_mappings()
augroup END

function! s:post_loaded_unite_mappings()
  silent! unmap [u
  silent! unmap [uu
  silent! unmap ]u
  silent! unmap ]uu

  nnoremap <silent><nowait> ]u :<C-U>execute v:count1 . 'UniteNext'<CR>
  nnoremap <silent><nowait> [u :<C-U>execute v:count1 . 'UnitePrevious'<CR>
  nnoremap <silent> [U :UniteFirst<CR>
  nnoremap <silent> ]U :UniteLast<CR>
endfunction
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
        \ })
endif
" }}}

" Defx {{{
if s:is_enabled_plugin("defx")
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
if s:os !~ "synology"
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
if has("nvim") && s:nvim_version >= 'NVIM v0.4.0-401-g5c836d2ef'
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
if s:os =~ "windows"
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
cnoremap <expr> <C-G><C-F> <SID>files_in_commandline()
cnoremap <expr> <C-G><C-T> <SID>rg_current_type_option()
" <C-]> and <C-%> is the same key
cnoremap <expr> <C-G><C-]> expand('%:t:r')
" <C-\> and <C-$> is the same key
cnoremap <expr> <C-G><C-\> expand('%:p')
" For grepping word
cnoremap <expr> <C-G><C-W> "\\b" . expand('<cword>') . "\\b"
cnoremap <expr> <C-G><C-A> "\\b" . expand('<cWORD>') . "\\b"

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
  autocmd FileType qf call s:quickfix_settings()
augroup END

function! s:quickfix_settings()
  nnoremap <silent><buffer> q :close<CR>
  nnoremap <silent><buffer> <C-T> :set switchbuf+=newtab<CR><CR>:set switchbuf-=newtab<CR>
  nnoremap <silent><buffer> <C-S> :set switchbuf+=split<CR><CR>:set switchbuf-=split<CR>
  nnoremap <silent><buffer> <C-V> :set switchbuf+=vsplit<CR><CR>:set switchbuf-=vsplit<CR>
endfunction
" }}}

" Custom function {{{
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'),
        \ '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
let g:sid = s:SID_PREFIX()

nnoremap <F6> :call <SID>toggle_indent_between_tab_and_space()<CR>
function! s:toggle_indent_between_tab_and_space()
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

nnoremap <F7> :call <SID>toggle_fold_between_manual_and_syntax()<CR>
function! s:toggle_fold_between_manual_and_syntax()
  if &foldmethod == 'manual'
    setlocal foldmethod=syntax
  else
    setlocal foldmethod=manual
  endif
endfunction

" last tabs
if !exists("g:last_tabs")
  let g:last_tabs = [1]
endif

function! s:last_tab(count)
  if a:count >= 0 && a:count < len(g:last_tabs)
    let tabnr = g:last_tabs[a:count]
  else
    let tabnr = g:last_tabs[-1]
  endif
  execute 'tabnext ' . tabnr
endfunction
function! s:insert_last_tab(tabnr)
  let g:last_tabs = filter(g:last_tabs, 'v:val != ' . a:tabnr)
  call insert(g:last_tabs, a:tabnr, 0)
  let count_tabcount = tabpagenr('$') - 1
  if count_tabcount > len(g:last_tabs)
    let g:last_tabs = g:last_tabs[0 : count_tabcount]
  endif
endfunction
command! -count -bar LastTab call s:last_tab(<count>)
nnoremap <M-1> :LastTab<CR>

augroup last_tab_settings
  autocmd!
  autocmd TabLeave * call s:insert_last_tab(tabpagenr())
augroup END

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
function! s:zoom_selected(selected)
  let filetype = &filetype
  tabnew
  call append(line('$'), split(a:selected, "\n"))
  1delete
  let &filetype = filetype
endfunction
nnoremap <silent> <Leader>z :call <SID>zoom()<CR>
xnoremap <silent> <Leader>z :<C-U>call <SID>zoom_selected(<SID>get_visual_selection())<CR>

" toggle parent folder tag
function! s:toggle_parent_folder_tag()
  let s:parent_folder_tag_pattern = "./tags;"
  if index(split(&tags, ','), s:parent_folder_tag_pattern) != -1
    execute 'set tags-=' . s:parent_folder_tag_pattern
  else
    execute 'set tags+=' . s:parent_folder_tag_pattern
  endif
endfunction
command! ToggleParentFolderTag call s:toggle_parent_folder_tag()
nnoremap <silent> <Leader>p :ToggleParentFolderTag<CR>

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
command! -nargs=1 FileSize call s:file_size(<q-args>)

function! s:set_tab_size(size)
  let &tabstop     = a:size
  let &shiftwidth  = a:size
  let &softtabstop = a:size
endfunction
command! -nargs=1 SetTabSize call s:set_tab_size(<q-args>)
" }}}

" Custom command {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

function! s:delete_inactive_buffers(wipeout, bang)
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let visible_buffers = {}
    for t in range(tabpagenr('$'))
      for b in tabpagebuflist(t + 1)
        let visible_buffers[b] = 1
      endfor
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let wipeout_count = 0
    if a:wipeout
      let cmd = 'bwipeout'
    else
      let cmd = 'bdelete'
    endif
    for b in range(1, bufnr('$'))
        if buflisted(b) && !getbufvar(b,"&mod") && !has_key(visible_buffers, b)
        "bufno listed AND isn't modified AND isn't in the list of buffers open in windows and tabs
            if a:bang
              silent exec cmd . '!' b
            else
              silent exec cmd b
            endif
            let wipeout_count = wipeout_count + 1
        endif
    endfor

    if a:wipeout
      echomsg wipeout_count . ' buffer(s) wiped out'
    else
      echomsg wipeout_count . ' buffer(s) deleted'
    endif
endfunction
command! -bang Bdi call s:delete_inactive_buffers(0, <bang>0)
command! -bang Bwi call s:delete_inactive_buffers(1, <bang>0)
nnoremap <Leader>D :Bdi<CR>
nnoremap <Leader><C-D> :Bdi!<CR>
nnoremap <Leader>Q :Bwi<CR>
nnoremap <Leader><C-Q> :Bwi!<CR>

function! s:trim_whitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call s:trim_whitespace()
"autocmd BufWritePre * call TrimWhitespace()

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

command! ReloadVimrc source $MYVIMRC

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
if !has("nvim") && !has("gui_running") && s:os !~ "windows"
  if s:os =~ "windows"
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
    autocmd TermOpen * call s:terminal_settings()

    " TODO Start insert mode when cancelling :Windows in terminal mode or
    " selecting another terminal buffer
    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Igore fzf, ranger, coc
    autocmd TermClose term://*
          \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
          \   call nvim_input('<CR>')  |
          \ endif
  augroup END

  function! s:terminal_settings()
    setlocal bufhidden=hide
    setlocal nolist
    setlocal nowrap
    setlocal nofoldenable
    setlocal foldcolumn=0
    setlocal colorcolumn=
    setlocal nonumber
    setlocal norelativenumber
  endfunction

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
  autocmd BufWritePost _vimrc nested source $MYVIMRC | e | normal! zzzv
  autocmd BufWritePost .vimrc nested source $MYVIMRC | e | normal! zzzv
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

  nnoremap <silent><buffer> K :call <SID>show_documentation()<CR>
  nnoremap gK :execute 'Pydoc ' . expand('<cword>')<CR>
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
if s:os =~ "synology" && !has("nvim")
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
