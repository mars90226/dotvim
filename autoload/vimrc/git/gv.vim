" Functions
function! vimrc#git#gv#sha() abort
  return gv#sha()
endfunction

function! vimrc#git#gv#visual_shas() abort
  " Borrowed from gv.vim
  let shas = filter(map(getline("'<", "'>"), 'gv#sha(v:val)'), '!empty(v:val)')
  let start_commit = shas[-1]
  let end_commit = shas[0]

  return [start_commit, end_commit]
endfunction
