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

function! vimrc#git#flog#all_visual_shas() abort
  return filter(map(range(line("'<"), line("'>")), 'vimrc#flog#sha(v:val)'), '!empty(v:val)')
endfunction
