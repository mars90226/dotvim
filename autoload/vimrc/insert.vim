" Utilities
function! vimrc#insert#check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Used in command-line mode
function! vimrc#insert#trim_cmdline() abort
  let length = str2nr(input('length: ', '', 'expression'))
  return getcmdline()[0 : length - 1]
endfunction

" Used in command-line mode
function! vimrc#insert#delete_whole_word() abort
  let cmd = getcmdline()
  let pos = getcmdpos() - 1 " getcmdpos() start from 1, but string index start from 0
  let meet_non_space = v:false
  for i in range(pos-2, 0, -1)
    if cmd[i] !=# ' '
      let meet_non_space = v:true
    endif

    if cmd[i] ==# ' ' && meet_non_space
      call setcmdpos(i+2)
      return cmd[0:i] . cmd[pos : ]
    endif
  endfor
  call setcmdpos(1)
  return cmd[pos : ]
endfunction
