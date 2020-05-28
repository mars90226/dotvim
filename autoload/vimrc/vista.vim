" Mappings
function! vimrc#vista#mappings()
  nnoremap <silent><buffer> <F7> :close<CR>
endfunction

function! vimrc#vista#finder_with_query(command, query)
  execute a:command
  call feedkeys(a:query)
endfunction
