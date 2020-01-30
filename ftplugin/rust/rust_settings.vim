if exists('b:loaded_rust_settings')
  finish
endif
let b:loaded_rust_settings = 1

function! s:search_under_cursor(query) range
  if a:query ==# ''
    echomsg 'rust-doc: No identifier is found under the cursor'
    return
  endif

  call rust_doc#open_fuzzy(a:query)
endfunction

nnoremap <silent><buffer> gK :call <SID>search_under_cursor(expand('<cword>'))<CR>
vnoremap <silent><buffer> gK :<C-U>call <SID>search_under_cursor(vimrc#get_visual_selection())<CR>
