let s:fd_command = 'fd --no-ignore --hidden --follow'
let s:fd_dir_command = 'fd --type directory --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore'

" Sources
function! vimrc#fzf#dir#directory_ancestors_source(path)
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
" TODO Refine popd_callback that use counter to activate
function! vimrc#fzf#dir#directory_sink(original_cwd, path, Func, directory)
  " Avoid fzf_popd autocmd that break further fzf commands that require
  " current changed working directory.
  " See s:dopopd() in fzf/plugin/fzf.vim

  " Change working directory of original file to orignal directory
  if exists('w:fzf_pushd')
    let w:directory_sink_popd = {
          \ 'original_cwd': a:original_cwd,
          \ 'popd_counter': 2,
          \ 'bufname': w:fzf_pushd.bufname
          \ }
    unlet w:fzf_pushd

    augroup directory_sink_popd_callback
      autocmd!
      autocmd BufWinEnter,WinEnter * call vimrc#fzf#dir#directory_sink_popd_callback()
    augroup END
  endif

  " Change working directory to directory pass in
  execute 'lcd ' . simplify(a:original_cwd . '/' . a:path)
  call a:Func(a:directory)
endfunction

function! vimrc#fzf#dir#directory_files_sink(chdir, directory)
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

function! vimrc#fzf#dir#directory_rg_sink(chdir, directory)
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

function! vimrc#fzf#dir#directory_ancestors_sink(line)
  execute 'lcd ' . a:line
endfunction

" Callbacks
function! vimrc#fzf#dir#directory_sink_popd_callback()
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
    autocmd! directory_sink_popd_callback
  endif
endfunction

" Commands
function! vimrc#fzf#dir#all_files(query, bang)
  call fzf#vim#files(a:query,
        \ a:bang ? fzf#vim#with_preview({ 'source': s:fd_command }, 'up:60%')
        \        : fzf#vim#with_preview({ 'source': s:fd_command }),
        \ a:bang)
endfunction

function! vimrc#fzf#dir#directories(path, bang, ...)
  let path = simplify(getcwd() . '/' . a:path)
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  s:fd_dir_command,
        \ 'options': ['-s', '--preview-window', 'right', '--preview', vimrc#fzf#preview#get_dir_command() . ' {}'],
        \ 'down':    '40%'
        \ }

  if empty(Sink)
    call fzf#vim#files(path, args, a:bang)
  else
    call fzf#vim#files(path, extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction

function! vimrc#fzf#dir#directory_files(path, bang)
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [getcwd(), a:path, function('vimrc#fzf#dir#directory_files_sink', [1])]))
endfunction

function! vimrc#fzf#dir#directory_rg(path, bang)
  call vimrc#fzf#dir#directories(a:path, a:bang, function('vimrc#fzf#dir#directory_sink', [getcwd(), a:path, function('vimrc#fzf#dir#directory_rg_sink', [1])]))
endfunction

function! vimrc#fzf#dir#directory_ancestors()
  call fzf#run(fzf#wrap({
      \ 'source': vimrc#fzf#dir#directory_ancestors_source(expand('%')),
      \ 'sink': function('vimrc#fzf#dir#directory_ancestors_sink'),
      \ 'options': '+s',
      \ 'down': '40%'}))
endfunction
