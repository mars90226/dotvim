" TODO: Remove this
" Functions
function! vimrc#netrw#toggle_pin() abort
  let w:netrw_pin = get(w:, 'netrw_pin', v:false) ? v:false : v:true
endfunction

function! vimrc#netrw#check_pin() abort
  return &filetype ==# 'netrw' && get(w:, 'netrw_pin', v:false)
endfunction

" Mappings
function! vimrc#netrw#mappings() abort
  nnoremap <silent><buffer> \p :call vimrc#netrw#toggle_pin()<CR>
endfunction
