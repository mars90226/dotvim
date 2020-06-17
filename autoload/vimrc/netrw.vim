" Functions
function! vimrc#netrw#toggle_pin()
  let w:netrw_pin = get(b:, 'netrw_pin', v:false) ? v:false : v:true
endfunction

function! vimrc#netrw#check_pin()
  return &filetype ==# 'netrw' && get(w:, 'netrw_pin', v:false)
endfunction

" Mappings
function! vimrc#netrw#mappings()
  nnoremap <silent><buffer> \p :call vimrc#netrw#toggle_pin()<CR>
endfunction
