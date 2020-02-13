" Utilities
" Borrowed from vinegar
function! vimrc#defx#opendir(cmd) abort
  if expand('%') =~# '^$\|^term:[\/][\/]'
    execute a:cmd ' .'
  else
    execute a:cmd . ' ' . expand('%:h')
  endif
endfunction

" Currently not used
function! vimrc#defx#get_folder(context) abort
  let path = a:context.targets[0]
  return isdirectory(path) ? path : fnamemodify(path, ':h')
endfunction

function! vimrc#defx#get_current_path() abort
  return b:defx['paths'][0]
endfunction

" Mappings
function! vimrc#defx#netrw_mapping_for_defx()
  " Cannot override Vinegar '-' mapping, so use '+' instead
  nmap <silent><buffer> + :call vimrc#defx#opendir('Defx')<CR>
endfunction

function! vimrc#defx#mappings() abort " {{{
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
        \ defx#do_action('change_vim_cwd') . ":tabnew          <Bar> :terminal<CR>i"
  nnoremap <silent><buffer><expr> <C-T><C-S>
        \ defx#do_action('change_vim_cwd') . ":new             <Bar> :terminal<CR>i"
  nnoremap <silent><buffer><expr> <C-T><C-V>
        \ defx#do_action('change_vim_cwd') . ":vnew            <Bar> :terminal<CR>i"
  nnoremap <silent><buffer><expr> <C-T><C-B>
        \ defx#do_action('change_vim_cwd') . ":rightbelow vnew <Bar> :terminal<CR>i"
  nnoremap <silent><buffer><expr> <C-T><C-D>
        \ defx#do_action('change_vim_cwd') . ":call vimrc#terminal#tabnew(input('Folder: ', '', 'dir'))<CR>"
  nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
        \ ':<C-U>wincmd w<CR>' :
        \ ':<C-U>Defx -buffer-name=temp -split=vertical<CR>'
  nnoremap <silent><buffer><expr> \f
        \ defx#do_action('call', 'vimrc#defx#fzf_files')
  nnoremap <silent><buffer><expr> \r
        \ defx#do_action('call', 'vimrc#defx#fzf_rg')
  nnoremap <silent><buffer><expr> \R
        \ defx#do_action('call', 'vimrc#defx#fzf_rg_bang')
  nnoremap <silent><buffer><expr> \<BS>
        \ defx#do_action('call', 'vimrc#defx#fzf_directory_ancestors')
  nnoremap <silent><buffer><expr> <Space>x
        \ defx#do_action('call', 'vimrc#defx#execute_split')
  nnoremap <silent><buffer><expr> \x
        \ defx#do_action('call', 'vimrc#defx#execute') " Add this mapping to prevent from executing 'x' mapping
  nnoremap <silent><buffer><expr> \xx
        \ defx#do_action('call', 'vimrc#defx#execute')
  nnoremap <silent><buffer><expr> \xr
        \ defx#do_action('call', 'vimrc#defx#execute')
  nnoremap <silent><buffer><expr> \xt
        \ defx#do_action('call', 'vimrc#defx#execute_tab')
  nnoremap <silent><buffer><expr> \xs
        \ defx#do_action('call', 'vimrc#defx#execute_split')
  nnoremap <silent><buffer><expr> \xv
        \ defx#do_action('call', 'vimrc#defx#execute_vertical')
  nnoremap <silent><buffer>       \d
        \ :Denite defx/dirmark<CR>
  nnoremap <silent><buffer>       \h
        \ :Denite defx/history<CR>

  " Use Unite because using Denite will change other Denite buffers
  nnoremap <silent><buffer> g?
        \ :Unite -buffer-name=defx_map_help output:map\ <buffer><CR>
endfunction " }}}

" Functions
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
function! vimrc#defx#open(target, action)
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

function! vimrc#defx#open_dir(target, action)
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

" Commands
" TODO Move to fzf autoload
function! vimrc#defx#fzf_files(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#fzf#defx#use_defx_fzf_action({ -> fzf#vim#files(path, fzf#vim#with_preview(), 0)})
endfunction

" TODO Move to fzf autoload
" Rg {{{
function! vimrc#defx#fzf_rg_internal(context, prompt, bang) abort
  let path = vimrc#defx#get_current_path()

  let cmd = a:bang ? 'RgWithOption!' : 'RgWithOption'
  execute cmd . ' ' . path . '::' . input(a:prompt . ': ')
endfunction

function! vimrc#defx#fzf_rg(context) abort
  call vimrc#defx#fzf_rg_internal(a:context, 'Rg', v:false)
endfunction

function! vimrc#defx#fzf_rg_bang(context) abort
  call vimrc#defx#fzf_rg_internal(a:context, 'Rg!', v:true)
endfunction
" }}}

" TODO Move to fzf autoload
" DirectoryAncestors {{{
function! vimrc#defx#fzf_directory_ancestors_sink(line) abort
  execute 'lcd ' . a:line
  call defx#call_action('cd', getcwd())
endfunction

function! vimrc#defx#fzf_directory_ancestors(context) abort
  let path = vimrc#defx#get_current_path()

  call fzf#run(fzf#wrap('Ancestors', {
        \ 'source': vimrc#fzf#dir#directory_ancestors_source(path),
        \ 'sink': function('vimrc#defx#fzf_directory_ancestors_sink'),
        \ 'options': ['+s', '--prompt', 'Ancestors> ']}))
endfunction
" }}}

" Execute {{{
function! vimrc#defx#execute_internal(context, split) abort
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

  execute a:split . ' term://' . cmd
endfunction

function! vimrc#defx#execute(context) abort
  call vimrc#defx#execute_internal(a:context, 'edit')
endfunction

function! vimrc#defx#execute_tab(context) abort
  call vimrc#defx#execute_internal(a:context, 'tabnew')
endfunction

function! vimrc#defx#execute_split(context) abort
  call vimrc#defx#execute_internal(a:context, 'new')
endfunction

function! vimrc#defx#execute_vertical(context) abort
  call vimrc#defx#execute_internal(a:context, 'vnew')
endfunction
" }}}

" Defx detect folder
function! vimrc#defx#detect_folder(path)
  if a:path != '' && isdirectory(a:path)
    execute 'silent! Defx '.a:path
  endif
endfunction
