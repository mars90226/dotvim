" Utilities
" Borrowed from vinegar
function! vimrc#defx#opendir(cmd) abort
  if expand('%') =~# '^$\|^term:[\/][\/]'
    let dir = '.'
  elseif &filetype ==# 'defx'
    let dir = fnamemodify(vimrc#defx#get_current_path(), ':h')
  else
    let dir = expand('%:h')
  endif

  call vimrc#defx#opencmd(a:cmd.' '.fnameescape(dir))
endfunction

function! vimrc#defx#openpwd(cmd) abort
  call vimrc#defx#opencmd(a:cmd.' .')
endfunction

function! vimrc#defx#opencmd(cmd) abort
  let cmd = a:cmd =~# '%' ? vimrc#defx#fill_buffer_name(a:cmd) : a:cmd
  execute cmd
endfunction

function! vimrc#defx#fill_buffer_name(defx_option)
  return printf(a:defx_option, win_getid())
endfunction

" Currently not used
function! vimrc#defx#get_folder(context) abort
  let path = a:context.targets[0]
  return isdirectory(path) ? path : fnamemodify(path, ':h')
endfunction

function! vimrc#defx#get_buffer_context() abort
  return b:defx['context']
endfunction

function! vimrc#defx#get_current_path() abort
  return b:defx['paths'][0]
endfunction

function! vimrc#defx#get_target(context) abort
  return a:context.targets[0]
endfunction

let s:defx_actions = {
  \ 'open_current_shell': 'vimrc#terminal#open_current_shell',
  \ 'open_shell': 'vimrc#terminal#open_shell',
  \ }

" Borrowed from defx.nvim
function! vimrc#defx#do_map(name, ...)
  let args = copy(a:000)
  let defx_action = get(s:defx_actions, a:name)
  return printf(":\<C-U>call vimrc#defx#call_map(%s, %s)\<CR>",
        \ string(defx_action), string(args))
endfunction

function! vimrc#defx#call_map(function, args)
  call call(a:function, a:args)
endfunction

" Settings
function! vimrc#defx#settings()
  setlocal nonumber
  setlocal norelativenumber
endfunction

" Mappings
function! vimrc#defx#netrw_mapping_for_defx()
  " Cannot override Vinegar '-' mapping, so use '+' instead
  nmap <silent><buffer> + :call vimrc#defx#opendir('Defx')<CR>
endfunction

function! vimrc#defx#mappings() abort " {{{
  " Define mappings
  if bufname('%') =~# 'tab'
    nnoremap <silent><buffer><expr> <CR>
          \ defx#async_action('open')
  elseif bufname('%') =~# 'float'
    nnoremap <silent><buffer><expr> <CR>
          \ defx#is_directory() ?
          \ defx#async_action('open') :
          \ defx#async_action('multi', ['drop', 'quit'])
  else
    nnoremap <silent><buffer><expr> <CR>
          \ defx#is_directory() ?
          \ defx#async_action('open') :
          \ defx#async_action('drop')
  endif
  nnoremap <silent><buffer><nowait><expr> +
        \ defx#do_action('open', 'choose')
  nnoremap <silent><buffer><expr> c
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> cc
        \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> !
        \ defx#do_action('execute_command')
  nnoremap <silent><buffer><nowait><expr> m
        \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
        \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
        \ defx#async_action('open')
  nnoremap <silent><buffer><expr> C
        \ defx#do_action('toggle_columns', 'mark:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
        \ defx#do_action('toggle_sort', 'Time')
  nnoremap <silent><buffer><expr> A
        \ defx#do_action('open', 'split')
  nnoremap <silent><buffer><expr> B
        \ defx#do_action('open', 'botright split')
  nnoremap <silent><buffer><expr> E
        \ defx#do_action('open', 'vsplit')
  nnoremap <silent><buffer><expr> ge
        \ defx#do_action('open', 'botright vsplit')
  nnoremap <silent><buffer><expr> P
        \ defx#do_action('open', 'pedit')
  nnoremap <silent><buffer><expr> T
        \ defx#do_action('open', 'tab split')
  nnoremap <silent><buffer><expr> o
        \ defx#async_action('open_tree', 'toggle')
  nnoremap <silent><buffer><expr> O
        \ defx#async_action('open_tree', 'recursive')
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
  nnoremap <silent><buffer><expr> -
        \ defx#async_action('cd', ['..'])
  nnoremap <silent><buffer><expr> h
        \ defx#async_action('cd', ['..'])
  nnoremap <silent><buffer><expr> <BS>
        \ defx#async_action('cd', ['..'])
  nnoremap <silent><buffer><expr> <C-H>
        \ defx#async_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
        \ defx#async_action('cd')
  nnoremap <silent><buffer><expr> gr
        \ defx#do_action('cd', '/')
  nnoremap <silent><buffer><expr> gl
        \ defx#do_action('cd', '/usr/lib/')
  nnoremap <silent><buffer><expr> gv
        \ defx#do_action('cd', $VIMRUNTIME)
  nnoremap <silent><buffer><expr> gp
        \ defx#do_action('cd', vimrc#git#root())
  nnoremap <silent><buffer><nowait><expr> \\
        \ defx#do_action('cd', getcwd())
  nnoremap <silent><buffer><expr> cd
        \ defx#do_action('change_vim_cwd') . defx#do_action('call', 'vimrc#defx#update_git_dir')
  nnoremap <silent><buffer><expr> cb
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd')
  nnoremap <silent><buffer><expr> cv
        \ defx#do_action('cd', expand(input('cd: ', '', 'dir')))
  nnoremap <silent><buffer><expr> <Leader>r
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . defx#do_action('call', 'vimrc#defx#git_root')
  nnoremap <silent><buffer><expr> gK
        \ defx#do_action('call', 'vimrc#defx#show_detail')
  if bufname('%') =~# 'tab'
    nnoremap <silent><buffer><expr> q
          \ defx#do_action('quit') . ":quit<CR>"
  else
    nnoremap <silent><buffer><expr> q
          \ defx#do_action('quit')
  endif
  nnoremap <silent><buffer><nowait><expr> `
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
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'edit')
  nnoremap <silent><buffer><expr> <C-T><C-T>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'tabnew')
  nnoremap <silent><buffer><expr> <C-T><C-S>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'new')
  nnoremap <silent><buffer><expr> <C-T><C-V>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'vnew')
  nnoremap <silent><buffer><expr> <C-T><C-B>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'rightbelow vnew')
  nnoremap <silent><buffer><expr> <C-T><C-F>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_current_shell', 'float')
  nnoremap <silent><buffer><expr> <C-T><C-D>
        \ defx#do_action('call', 'vimrc#defx#change_vim_buffer_cwd') . vimrc#defx#do_map('open_shell', 'tabnew', input('Folder: ', '', 'dir'))
  nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
        \ ':<C-U>wincmd w<CR>' :
        \ ':<C-U>Defx -buffer-name=temp -split=vertical<CR>'
  nnoremap <silent><buffer><expr> \f
        \ defx#do_action('call', 'vimrc#defx#fzf_files')
  nnoremap <silent><buffer><expr> \<C-F>
        \ defx#do_action('call', 'vimrc#defx#fzf_files_target')
  nnoremap <silent><buffer><expr> \r
        \ defx#do_action('call', 'vimrc#defx#fzf_rg')
  nnoremap <silent><buffer><expr> \R
        \ defx#do_action('call', 'vimrc#defx#fzf_rg_bang')
  nnoremap <silent><buffer><expr> \<C-R>
        \ defx#do_action('call', 'vimrc#defx#fzf_rg_target')
  nnoremap <silent><buffer><expr> \<M-r>
        \ defx#do_action('call', 'vimrc#defx#fzf_rg_bang_target')
  nnoremap <silent><buffer><expr> \a
        \ defx#do_action('call', 'vimrc#defx#fzf_rga')
  nnoremap <silent><buffer><expr> \A
        \ defx#do_action('call', 'vimrc#defx#fzf_rga_bang')
  nnoremap <silent><buffer><expr> \<C-A>
        \ defx#do_action('call', 'vimrc#defx#fzf_rga_target')
  nnoremap <silent><buffer><expr> \<M-a>
        \ defx#do_action('call', 'vimrc#defx#fzf_rga_bang_target')
  nnoremap <silent><buffer><expr> \<BS>
        \ defx#do_action('call', 'vimrc#defx#fzf_directory_ancestors')
  nnoremap <silent><buffer><expr> \<C-H>
        \ defx#do_action('call', 'vimrc#defx#fzf_directory_ancestors')
  nnoremap <silent><buffer><expr> <Space>x
        \ defx#do_action('call', 'vimrc#defx#execute_file_float')
  " Add this mapping to prevent from executing 'x' mapping
  nnoremap <silent><buffer><expr> \x
        \ defx#do_action('call', 'vimrc#defx#execute_file')
  nnoremap <silent><buffer><expr> \xx
        \ defx#do_action('call', 'vimrc#defx#execute_file')
  nnoremap <silent><buffer><expr> \xr
        \ defx#do_action('call', 'vimrc#defx#execute_file')
  nnoremap <silent><buffer><expr> \xf
        \ defx#do_action('call', 'vimrc#defx#execute_file_float')
  nnoremap <silent><buffer><expr> \xt
        \ defx#do_action('call', 'vimrc#defx#execute_file_tab')
  nnoremap <silent><buffer><expr> \xs
        \ defx#do_action('call', 'vimrc#defx#execute_file_split')
  nnoremap <silent><buffer><expr> \xv
        \ defx#do_action('call', 'vimrc#defx#execute_file_vertical')
  nnoremap <silent><buffer><expr> \dx
        \ defx#do_action('call', 'vimrc#defx#execute_dir_float')
  nnoremap <silent><buffer><expr> \dr
        \ defx#do_action('call', 'vimrc#defx#execute_dir')
  nnoremap <silent><buffer><expr> \df
        \ defx#do_action('call', 'vimrc#defx#execute_dir_float')
  nnoremap <silent><buffer><expr> \dt
        \ defx#do_action('call', 'vimrc#defx#execute_dir_tab')
  nnoremap <silent><buffer><expr> \ds
        \ defx#do_action('call', 'vimrc#defx#execute_dir_split')
  nnoremap <silent><buffer><expr> \dv
        \ defx#do_action('call', 'vimrc#defx#execute_dir_vertical')
  nnoremap <silent><buffer>       \dd
        \ :Denite defx/dirmark<CR>
  nnoremap <silent><buffer>       \h
        \ :Denite -unique defx/history<CR>
  nnoremap <silent><buffer><expr> \P
        \ defx#do_action('call', 'vimrc#defx#paste_from_system_clipboard')
  nnoremap <silent><buffer><expr> \<C-P>
        \ defx#do_action('call', 'vimrc#defx#paste_from_system_clipboard_target')

  " Use Unite because using Denite will change other Denite buffers
  nnoremap <silent><buffer> g?
        \ :Unite -buffer-name=defx_map_help output:map\ <buffer><CR>

  cnoremap <buffer><expr> <C-X>d
        \ vimrc#defx#get_current_path_in_commandline()
  cnoremap <buffer><expr> <C-X>f
        \ defx#do_action('call', 'vimrc#defx#get_target_in_commandline')
endfunction " }}}

" Functions
let s:defx_action = {
      \ 'edit': ['edit', ''],
      \ 'tab': ['tab split', '-split=tab '.get(g:, 'defx_tab_options', '')],
      \ 'split': ['split', '-split=horizontal'],
      \ 'vsplit': ['vsplit', '-split=vertical'],
      \ 'rvsplit': ['rightbelow vsplit', '-split=vertical -direction=botright'],
      \ 'float': ['VimrcFloatNew edit', '-split=floating '.get(g:, 'defx_float_options', '')],
      \ }

" TODO May need to escape a:line
function! vimrc#defx#open(target, action)
  let [action, defx_option] = get(s:defx_action, a:action, '')

  if isdirectory(a:target)
    if &filetype ==# 'defx' && action ==# 'edit'
      " Use absolute path
      let target = fnamemodify(a:target, ':p')
      call defx#call_action('cd', target)
    else
      execute 'Defx ' . defx_option . ' ' . a:target
    endif
  else
    execute action . ' ' . a:target
  endif
endfunction

" TODO Rename to indicate sink?
function! vimrc#defx#open_dir(target, action)
  let [action, defx_option] = get(s:defx_action, a:action, '')

  if &filetype ==# 'defx' && action ==# 'edit'
    call defx#call_action('search', a:target)
  else
    execute 'Defx ' . defx_option . ' -search=' . a:target
  endif
endfunction

" Commands
" TODO Move to fzf autoload
" Files {{{
function! vimrc#defx#_fzf_files(path) abort
  call vimrc#fzf#defx#use_defx_fzf_action({ -> fzf#vim#files(a:path, fzf#vim#with_preview(), 0)})
endfunction

function! vimrc#defx#fzf_files(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#_fzf_files(path)
endfunction

function! vimrc#defx#fzf_files_target(context) abort
  let path = vimrc#defx#get_target(a:context)

  call vimrc#defx#_fzf_files(path)
endfunction
" }}}

" TODO Move to fzf autoload
" Rg {{{
function! vimrc#defx#fzf_rg_internal(path, prompt, bang) abort
  let cmd = a:bang ? 'RgWithOption!' : 'RgWithOption'
  execute cmd . ' ' . a:path . '::' . input(a:prompt . ': ')
endfunction

function! vimrc#defx#fzf_rg(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#fzf_rg_internal(path, 'Rg', v:false)
endfunction

function! vimrc#defx#fzf_rg_target(context) abort
  let path = vimrc#defx#get_target(a:context)

  call vimrc#defx#fzf_rg_internal(path, 'Rg', v:false)
endfunction

function! vimrc#defx#fzf_rg_bang(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#fzf_rg_internal(path, 'Rg!', v:true)
endfunction

function! vimrc#defx#fzf_rg_bang_target(context) abort
  let path = vimrc#defx#get_target(a:context)

  call vimrc#defx#fzf_rg_internal(path, 'Rg!', v:false)
endfunction
" }}}

" TODO Move to fzf autoload
" Rga {{{
function! vimrc#defx#fzf_rga_internal(path, prompt, bang) abort
  let cmd = a:bang ? 'Rga!' : 'Rga'
  execute cmd . ' ' . a:path . '::' . input(a:prompt . ': ')
endfunction

function! vimrc#defx#fzf_rga(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#fzf_rga_internal(path, 'Rga', v:false)
endfunction

function! vimrc#defx#fzf_rga_targaet(context) abort
  let path = vimrc#defx#get_targaet(a:context)

  call vimrc#defx#fzf_rga_internal(path, 'Rga', v:false)
endfunction

function! vimrc#defx#fzf_rga_bang(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#fzf_rga_internal(path, 'Rga!', v:true)
endfunction

function! vimrc#defx#fzf_rga_bang_targaet(context) abort
  let path = vimrc#defx#get_targaet(a:context)

  call vimrc#defx#fzf_rga_internal(path, 'Rga!', v:false)
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
function! vimrc#defx#execute_internal(path, split, ...) abort
  let cmd = a:0 >= 1 && type(a:1) == type('') ? a:1 : input('Command: ', '', 'shellcmd')

  if empty(cmd)
    return
  endif

  call vimrc#tui#run(a:split, vimrc#defx#_get_commmand(cmd, a:path), 1)
endfunction

function! vimrc#defx#_get_commmand(cmd, path) abort
  if a:cmd =~# '{}'
    " replace all '{}' to path
    return substitute(a:cmd, '{}', a:path, 'g')
  else
    return a:cmd . ' ' . a:path
  endif
endfunction

function! vimrc#defx#execute_file_internal(context, split) abort
  let target = vimrc#defx#get_target(a:context)
  call vimrc#defx#execute_internal(target, a:split)
endfunction

function! vimrc#defx#execute_file(context) abort
  call vimrc#defx#execute_file_internal(a:context, 'edit')
endfunction

function! vimrc#defx#execute_file_float(context) abort
  call vimrc#defx#execute_file_internal(a:context, 'float')
endfunction

function! vimrc#defx#execute_file_tab(context) abort
  call vimrc#defx#execute_file_internal(a:context, 'tabnew')
endfunction

function! vimrc#defx#execute_file_split(context) abort
  call vimrc#defx#execute_file_internal(a:context, 'new')
endfunction

function! vimrc#defx#execute_file_vertical(context) abort
  call vimrc#defx#execute_file_internal(a:context, 'vnew')
endfunction

function! vimrc#defx#execute_dir_internal(context, split) abort
  let path = vimrc#defx#get_current_path()
  call vimrc#defx#execute_internal(path, a:split)
endfunction

function! vimrc#defx#execute_dir(context) abort
  call vimrc#defx#execute_dir_internal(a:context, 'edit')
endfunction

function! vimrc#defx#execute_dir_float(context) abort
  call vimrc#defx#execute_dir_internal(a:context, 'float')
endfunction

function! vimrc#defx#execute_dir_tab(context) abort
  call vimrc#defx#execute_dir_internal(a:context, 'tabnew')
endfunction

function! vimrc#defx#execute_dir_split(context) abort
  call vimrc#defx#execute_dir_internal(a:context, 'new')
endfunction

function! vimrc#defx#execute_dir_vertical(context) abort
  call vimrc#defx#execute_dir_internal(a:context, 'vnew')
endfunction
" }}}

" Current working directory & git directory
function! vimrc#defx#change_vim_buffer_cwd(context) abort
  let path = vimrc#defx#get_current_path()
  call vimrc#defx#_change_vim_buffer_cwd(path)
endfunction

function! vimrc#defx#_change_vim_buffer_cwd(path) abort
  execute 'lcd '.fnameescape(a:path)
  call vimrc#defx#_update_git_dir(a:path)
endfunction

function! vimrc#defx#update_git_dir(context) abort
  let path = vimrc#defx#get_current_path()
  call vimrc#defx#_update_git_dir(path)
endfunction

function! vimrc#defx#_update_git_dir(path) abort
  let b:git_dir = FugitiveExtractGitDir(expand(a:path))
endfunction

function! vimrc#defx#git_root(context) abort
  call vimrc#defx#_change_vim_buffer_cwd(vimrc#git#root())
endfunction

" Defx detect folder
function! vimrc#defx#detect_folder(path)
  if a:path !=# '' && isdirectory(a:path)
    " Check for netrw pin
    if !vimrc#netrw#check_pin()
      execute 'silent! Defx '.a:path
    endif
  endif
endfunction

" Paste from system clipboard
function! vimrc#defx#_paste_from_system_clipboard(path) abort
  execute '!'.vimrc#defx#_get_commmand('cp -r '.fnameescape(@+), a:path)
endfunction

function! vimrc#defx#paste_from_system_clipboard(context) abort
  let path = vimrc#defx#get_current_path()

  call vimrc#defx#_paste_from_system_clipboard(path)
endfunction

function! vimrc#defx#paste_from_system_clipboard_target(context) abort
  let path = vimrc#defx#get_target(a:context)

  call vimrc#defx#_paste_from_system_clipboard(path)
endfunction

" Depends on exa
function! vimrc#defx#show_detail(context) abort
  let target = vimrc#defx#get_target(a:context)
  let cmd = 'exa -l {}'
  call vimrc#defx#execute_internal(target, 'float', cmd)
endfunction

" Command line function
function! vimrc#defx#get_current_path_in_commandline() abort
  return vimrc#defx#get_current_path()
endfunction

function! vimrc#defx#get_target_in_commandline(context) abort
  let target = vimrc#defx#get_target(a:context)

  " This function is executed by Defx python script
  " So we cannot simply return target to caller.
  " Instead we assume the typehead is in command line and feed the keys.
  call feedkeys(target)
endfunction
