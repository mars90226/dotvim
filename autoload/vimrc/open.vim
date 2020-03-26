" Functions
function! vimrc#open#switch(file, fallback_command)
  let bufnr = bufnr(a:file)
  let winids = win_findbuf(bufnr)
  if empty(winids)
    execute 'silent '.a:fallback_command.' '.a:file
  else
    call win_gotoid(winids[0])
  endif
endfunction
