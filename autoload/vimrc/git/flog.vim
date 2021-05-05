" Functions
function! vimrc#git#flog#sha() abort
  return vimrc#flog#sha()
endfunction

function! vimrc#git#flog#visual_shas() abort
  let firstline = line("'<")
  let lastline = line("'>")
  let start_commit = vimrc#flog#sha(lastline)
  let end_commit = vimrc#flog#sha(firstline)

  return [start_commit, end_commit]
endfunction
