let s:ctrlp_user_command_default_timeout = 5
let s:ctrlp_user_command_timeout = s:ctrlp_user_command_default_timeout

function! vimrc#ctrlp#update_user_command(has_timeout)
  if empty(g:ctrlp_base_user_command)
    return
  endif

  let g:ctrlp_user_command = (a:has_timeout ? 'timeout '. s:ctrlp_user_command_timeout . ' ' : '') . g:ctrlp_base_user_command
endfunction

function! vimrc#ctrlp#set_timeout(timeout)
  if a:timeout == -1
    let s:ctrlp_user_command_timeout = s:ctrlp_user_command_default_timeout
  elseif a:timeout != 0
    let s:ctrlp_user_command_timeout = a:timeout
  endif

  call vimrc#ctrlp#update_user_command(a:timeout != 0)
endfunction
