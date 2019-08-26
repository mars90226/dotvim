" Use neomru
function! vimrc#fzf#mru#filtered_neomru_files()
  return filter(readfile(g:neomru#file_mru_path)[1:],
        \ "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\\[unite\\]\\|\[Preview\\]\\|__Tagbar__\\|term://\\|gina://'")
endfunction

function! vimrc#fzf#mru#neomru_directories()
  return extend(
  \ readfile(g:neomru#directory_mru_path)[1:],
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), "fnamemodify(bufname(v:val), ':p:h')"))
endfunction

" Source
function! vimrc#fzf#mru#mru_files()
  return extend(
  \ vimrc#fzf#mru#filtered_neomru_files(),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

function! vimrc#fzf#mru#project_mru_files()
  " cannot use \V to escape the special characters in filepath as it only
  " render the string literal after it to "very nomagic"
  " FIXME Maybe doable, see s:gv_expand()
  return extend(
  \ filter(vimrc#fzf#mru#filtered_neomru_files(),
  \   "v:val =~ '^' . getcwd()"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" Sinks
function! vimrc#fzf#mru#directory_mru_files_sink(chdir, directory)
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

function! vimrc#fzf#mru#directory_mru_rg_sink(chdir, directory)
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

" Commands
function! vimrc#fzf#mru#mru()
  call fzf#run(fzf#wrap({
        \ 'source':  vimrc#fzf#mru#mru_files(),
        \ 'options': '-m -s',
        \ 'down':    '40%' }))
endfunction

function! vimrc#fzf#mru#project_mru()
  call fzf#run(fzf#wrap({
        \ 'source':  vimrc#fzf#mru#project_mru_files(),
        \ 'options': '-m -s',
        \ 'down':    '40%' }))
endfunction

" DirectoryMru
function! vimrc#fzf#mru#directory_mru(bang, ...)
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  vimrc#fzf#mru#neomru_directories(),
        \ 'options': ['-s', '--preview-window', 'right', '--preview', vimrc#fzf#preview#get_dir_command(), '--prompt', 'DirectoryMru> '],
        \ 'down':    '40%'
        \ }

  if empty(Sink)
    call fzf#vim#files('', args, a:bang)
  else
    call fzf#vim#files('', extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction

function! vimrc#fzf#mru#directory_mru_files(bang)
  call vimrc#fzf#mru#directory_mru(a:bang, function('vimrc#fzf#mru#directory_mru_files_sink', [0]))
endfunction

function! vimrc#fzf#mru#directory_mru_rg(bang)
  call vimrc#fzf#mru#directory_mru(a:bang, function('vimrc#fzf#mru#directory_mru_rg_sink', [0]))
endfunction
