" Use neomru
function! vimrc#fzf#mru#filtered_neomru_files()
  return filter(readfile(g:neomru#file_mru_path)[1:],
        \ "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/\\|\\[unite\\]\\|\[Preview\\]\\|__Tagbar__\\|term://\\|gina://'")
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
