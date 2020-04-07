" Functions
" FIXME: Will open shell after floaterm update?
function! vimrc#floaterm#send(cmd)
  if empty(a:cmd)
    return
  endif

  let cmds = [a:cmd]

  let bufnr = floaterm#buflist#find_curr()
  if bufnr == -1
    let bufnr = floaterm#new()
  endif
  call floaterm#terminal#send(bufnr, cmds)
endfunction
