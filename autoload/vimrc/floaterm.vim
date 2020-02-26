" Functions
function! vimrc#floaterm#send()
  let cmd = input('Command: ', '', 'shellcmd')

  if empty(cmd)
    return
  endif

  let bufnr = floaterm#buflist#find_curr()
  if bufnr == -1
    let bufnr = floaterm#new()
  endif
  call floaterm#terminal#send(bufnr, cmd)
endfunction
