" Use neomru
function! vimrc#fzf#mru#filtered_neomru_files() abort
  return filter(readfile(g:neomru#file_mru_path)[1:],
        \ "v:val !~# 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\[Preview\\]\\|term://\\'")
endfunction

function! vimrc#fzf#mru#neomru_directories() abort
  return extend(
  \ readfile(g:neomru#directory_mru_path)[1:],
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), "fnamemodify(bufname(v:val), ':p:h')"))
endfunction

" Source
function! vimrc#fzf#mru#mru_files() abort
  return extend(
  \ vimrc#fzf#mru#filtered_neomru_files(),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

function! vimrc#fzf#mru#project_mru_files() abort
  " cannot use \V to escape the special characters in filepath as it only
  " render the string literal after it to "very nomagic"
  " FIXME Maybe doable, see s:gv_expand()
  return extend(
  \ filter(vimrc#fzf#mru#filtered_neomru_files(),
  \   "v:val =~ '^' . getcwd()"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" Commands
function! vimrc#fzf#mru#mru() abort
  call fzf#run(fzf#wrap('Mru', {
        \ 'source':  vimrc#fzf#mru#mru_files(),
        \ 'options': ['-m', '-s', '--prompt', 'Mru> ', '--preview', vimrc#fzf#preview#get_command() . ' {}']}))
endfunction

function! vimrc#fzf#mru#project_mru() abort
  call fzf#run(fzf#wrap('ProjectMru', {
        \ 'source':  vimrc#fzf#mru#project_mru_files(),
        \ 'options': ['-m', '-s', '--prompt', 'ProjectMru> ', '--preview', vimrc#fzf#preview#get_command() . ' {}']}))
endfunction

" DirectoryMru
function! vimrc#fzf#mru#directory_mru(bang, ...) abort
  let Sink = a:0 && type(a:1) == type(function('call')) ? a:1 : ''
  let args = {
        \ 'source':  vimrc#fzf#mru#neomru_directories(),
        \ 'options': ['-s', '--preview-window', 'right', '--preview', vimrc#fzf#preview#get_dir_command() . ' {}', '--prompt', 'DirectoryMru> ']}

  if empty(Sink)
    call fzf#vim#files('', args, a:bang)
  else
    call fzf#vim#files('', extend(args, { 'sink': Sink }), a:bang)
  endif
endfunction

function! vimrc#fzf#mru#directory_mru_files(bang) abort
  call vimrc#fzf#mru#directory_mru(a:bang, function('vimrc#fzf#dir#directory_files_sink', [0]))
endfunction

function! vimrc#fzf#mru#directory_mru_rg(bang) abort
  call vimrc#fzf#mru#directory_mru(a:bang, function('vimrc#fzf#dir#directory_rg_sink', [0]))
endfunction

function! vimrc#fzf#mru#mru_in_commandline() abort
  let results = []
  call fzf#vim#files(
        \ '',
        \ fzf#vim#with_preview(extend({
        \   'source':  vimrc#fzf#mru#mru_files(),
        \   'sink': function('vimrc#fzf#files_in_commandline_sink', [results]),
        \   'options': ['-s', '--prompt', 'Mru> ']}, g:fzf_tmux_layout)),
        \ 0)
  return get(results, 0, '')
endfunction

function! vimrc#fzf#mru#directory_mru_in_commandline() abort
  let results = []
  call fzf#vim#files(
        \ '',
        \ extend({
        \   'source':  vimrc#fzf#mru#neomru_directories(),
        \   'sink': function('vimrc#fzf#files_in_commandline_sink', [results]),
        \   'options': ['-s', '--preview-window', 'right', '--preview', vimrc#fzf#preview#get_dir_command() . ' {}', '--prompt', 'DirectoryMru> ']}, g:fzf_tmux_layout),
        \ 0)
  return get(results, 0, '')
endfunction
