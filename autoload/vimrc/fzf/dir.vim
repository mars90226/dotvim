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
function! vimrc#fzf#dir#directory_sink(original_cwd, path, Func, directory) abort
  " Avoid fzf_popd autocmd that break further fzf commands that require
  " current changed working directory.
  " See s:dopopd() in fzf/plugin/fzf.vim
  "
  " Flow:
  "   fzf command -> fzf pushd -> fzf callback -> fzf popd
  "
  " Pushing second fzf function to DirChanged callback to ignore first fzf
  " command popd.

  " Change working directory of original file to orignal directory
  if exists('w:fzf_pushd')
    let w:directory_sink_popd = {
          \ 'original_cwd': a:original_cwd,
          \ 'bufname': w:fzf_pushd.bufname
          \ }
  endif

  " Execute second fzf function in callback
  let w:directory_sink_directory = simplify(vimrc#fzf#dir#get_start_directory(a:original_cwd, a:path).'/'.a:directory)
  let w:DirectorySinkFunc = a:Func

  augroup directory_sink_chdir_callback
    autocmd!
    autocmd DirChanged * call vimrc#fzf#dir#directory_sink_chdir_callback(w:DirectorySinkFunc, w:directory_sink_directory)
  augroup END
endfunction

function! vimrc#fzf#dir#directory_files_sink(chdir, directory) abort
  if a:chdir
    execute 'lcd ' . a:directory
    Files
  else
    execute 'Files ' . a:directory
  endif

  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

function! vimrc#fzf#dir#directory_rg_sink(chdir, directory) abort
  if a:chdir
    execute 'lcd ' . a:directory
    execute 'RgWithOption ::' . input('Rg: ')
  else
    execute 'RgWithOption ' . a:directory . '::' . input('Rg: ')
  endif

  " To enter terminal mode, this is a workaround that autocommand exit the
  " terminal mode when previous fzf session end.
  call feedkeys('i')
endfunction

function! vimrc#fzf#dir#directory_ancestors_sink(line) abort
  execute 'lcd ' . a:line
endfunction

" Callbacks
function! vimrc#fzf#dir#directory_sink_chdir_callback(Func, directory) abort
  " Set callback in fzf sink to switch original buffer to original cwd.
  " Avoid invoke popd_callback callback too early.

  autocmd! directory_sink_chdir_callback

  augroup directory_sink_second_sink_callback
    autocmd!
    autocmd User VimrcFzfSink call vimrc#fzf#dir#directory_sink_second_sink_callback()
  augroup END

  call a:Func(a:directory)
endfunction

function! vimrc#fzf#dir#directory_sink_second_sink_callback() abort
  " Invoke popd_callback in WinEnter callback

  autocmd! directory_sink_second_sink_callback

  augroup directory_sink_popd_callback
    autocmd!
    autocmd WinEnter * call vimrc#fzf#dir#directory_sink_popd_callback()
  augroup END
endfunction

" FIXME This may have race condition that cannot find w:directory_sink_popd
" Error messages:
" || Error detected while processing function
" || 778[30]
" || <SNR>127_callback[21]
" || Vim(let):E5555: API call: Vim(let):E121: Undefined variable: w:directory_sink_popd
function! vimrc#fzf#dir#directory_sink_popd_callback() abort
  if !exists('w:directory_sink_popd')
    return
  endif

  " Check if current buffer is the original buffer
  let original_bufname = w:directory_sink_popd.original_cwd . '/' . w:directory_sink_popd.bufname
  if fnamemodify(original_bufname, ':p') !=# fnamemodify(bufname(''), ':p')
    unlet w:directory_sink_popd
    autocmd! directory_sink_popd_callback
    return
  endif

  execute 'lcd ' . w:directory_sink_popd.original_cwd
  unlet w:directory_sink_popd
  autocmd! directory_sink_popd_callback
endfunction

" Commands
function! vimrc#fzf#dir#all_files(folder, bang) abort
  let options = { 'source': s:fd_command }

  call fzf#vim#files(a:folder,
        \ vimrc#fzf#preview#with_preview(options, a:bang),
        \ a:bang)
endfunction

" Custom files, using ':' to seperate folder and option and pattern
" TODO Review arguments
function! vimrc#fzf#dir#custom_files(command, bang) abort
  let command_parts = split(a:command, ':', 1)
  let folder = command_parts[0]
  let option = command_parts[1]
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
    call fzf#vim#files(path, extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction

function! vimrc#fzf#dir#directory_files(path, bang) abort
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [getcwd(), a:path, function('vimrc#fzf#dir#directory_files_sink', [1])]))
endfunction

function! vimrc#fzf#dir#directory_rg(path, bang) abort
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [getcwd(), a:path, function('vimrc#fzf#dir#directory_rg_sink', [1])]))
endfunction

function! vimrc#fzf#dir#directory_ancestors() abort
  call fzf#run(fzf#wrap('Ancestors', {
      \ 'source': vimrc#fzf#dir#directory_ancestors_source(expand('%')),
      \ 'sink': function('vimrc#fzf#dir#directory_ancestors_sink'),
      \ 'options': ['+s', '--prompt', 'Ancestors> ']}))
endfunction
