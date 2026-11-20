let s:fd_command = 'fd --no-ignore --hidden --follow'
let s:fd_dir_command = 'fd --type directory --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore'

" Utilities
function! vimrc#fzf#dir#get_start_directory(cwd, path) abort
  return a:path =~# '^/' ? a:path : simplify(a:cwd . '/' . a:path)
endfunction

" Sources
function! vimrc#fzf#dir#directory_ancestors_source(path) abort
  let current_dir = fnamemodify(a:path, ':p:h')
  let ancestors = []

  for path_part in split(current_dir, '/')
    let last_path = empty(ancestors) ? '' : ancestors[-1]
    let current_path = last_path . '/' . path_part
    call add(ancestors, current_path)
  endfor

  return reverse(ancestors)
endfunction

" Sinks
function! s:open_selected_directory(winid, Func, directory, timer) abort
  if win_getid() == a:winid
    call a:Func(a:directory)
    if &buftype ==# 'terminal' && &filetype ==# 'fzf'
      " Re-enter terminal mode after the first picker's BufLeave stopinsert.
      call feedkeys("\<Plug>(fzf-insert)", 'i')
    endif
  endif
endfunction

function! vimrc#fzf#dir#directory_sink(winid, base, Func, selections) abort
  if empty(a:selections)
    return
  endif
  let directory = simplify(a:base . '/' . a:selections[-1])
  " Let fzf finish restoring the first picker's window and directory.
  call timer_start(0, function('s:open_selected_directory', [a:winid, a:Func, directory]))
endfunction

function! s:keep_selected_directory(winid, bufnr, directory, original_cwd, restore_cmd, timer) abort
  let directory = fnamemodify(resolve(a:directory), ':p')
  let [tabnr, winnr] = win_id2tabwin(a:winid)
  if win_getid() != a:winid && tabnr != 0
        \ && fnamemodify(resolve(getcwd(winnr, tabnr)), ':p') ==# directory
    call win_execute(a:winid, a:restore_cmd . ' ' . fnameescape(a:original_cwd))
  endif
  if &buftype ==# '' && !empty(bufname())
        \ && (win_getid() != a:winid || bufnr() != a:bufnr
        \     || stridx(resolve(expand('%:p')), directory) == 0)
        \ && isdirectory(directory)
    execute 'lcd ' . fnameescape(a:directory)
  endif
endfunction

function! vimrc#fzf#dir#after_picker_exit(winid, directory, code) abort
  if a:code == 0 && win_getid() == a:winid
    " Apply the directory in the result window after fzf handles the action.
    let restore_cmd = haslocaldir() ? 'lcd' : (haslocaldir(-1) ? 'tcd' : 'cd')
    call timer_start(0, function('s:keep_selected_directory',
          \ [a:winid, bufnr(), a:directory, getcwd(), restore_cmd]))
  endif
endfunction

function! vimrc#fzf#dir#directory_files_sink(deferred, directory) abort
  if a:deferred
    call v:lua.require('vimrc.plugins.fzf').open_files(a:directory, v:false, win_getid())
  else
    call v:lua.require('vimrc.plugins.fzf').open_files(a:directory, v:false)
    call feedkeys('i')
  endif
endfunction

function! vimrc#fzf#dir#directory_rg_sink(deferred, directory) abort
  let query = input('Rg: ')
  if a:deferred
    call vimrc#fzf#rg#grep(query, 0, {
          \ 'dir': a:directory,
          \ 'exit': function('vimrc#fzf#dir#after_picker_exit', [win_getid(), a:directory]),
          \ })
  else
    execute 'RgWithOption ' . a:directory . '::' . query
    call feedkeys('i')
  endif
endfunction

function! vimrc#fzf#dir#directory_ancestors_sink(line) abort
  execute 'lcd ' . a:line
endfunction

" Commands
function! vimrc#fzf#dir#all_files(folder, bang) abort
  let options = { 'source': s:fd_command }

  call fzf#vim#files(a:folder,
        \ vimrc#fzf#preview#with_preview(options, a:bang),
        \ a:bang)
endfunction

" CustomFiles [folder[:fd-options[:pattern]]]
function! vimrc#fzf#dir#custom_files(command, bang) abort
  let command_parts = split(a:command, ':', 1)
  let folder = get(command_parts, 0, '')
  let option = get(command_parts, 1, '')
  let pattern = join(command_parts[2:], ':')
  let cmd = s:fd_command.' '.option.' '.shellescape(pattern)
  let options = {
    \ 'source': cmd
    \ }

  call fzf#vim#files(folder,
        \ vimrc#fzf#preview#with_preview(options, a:bang),
        \ a:bang)
endfunction

function! vimrc#fzf#dir#directories(path, bang, ...) abort
  let path = vimrc#fzf#dir#get_start_directory(getcwd(), a:path)
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  s:fd_dir_command,
        \ 'options': ['-s', '--preview-window', 'right', '--preview', vimrc#fzf#preview#get_dir_command() . ' {}']}

  if empty(Sink)
    call fzf#vim#files(path, args, a:bang)
  else
    call fzf#vim#files(path, extend(args, { 'sinklist': Sink }), a:bang)
  endif
endfunction

function! vimrc#fzf#dir#directory_files(path, bang) abort
  let base = vimrc#fzf#dir#get_start_directory(getcwd(), a:path)
  let Sink = function('vimrc#fzf#dir#directory_files_sink', [1])
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [win_getid(), base, Sink]))
endfunction

function! vimrc#fzf#dir#directory_rg(path, bang) abort
  let base = vimrc#fzf#dir#get_start_directory(getcwd(), a:path)
  let Sink = function('vimrc#fzf#dir#directory_rg_sink', [1])
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [win_getid(), base, Sink]))
endfunction

function! vimrc#fzf#dir#directory_ancestors() abort
  call fzf#run(fzf#wrap('Ancestors', {
      \ 'source': vimrc#fzf#dir#directory_ancestors_source(expand('%')),
      \ 'sink': function('vimrc#fzf#dir#directory_ancestors_sink'),
      \ 'options': ['+s', '--prompt', 'Ancestors> ']}))
endfunction
