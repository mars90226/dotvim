" Functions
function! vimrc#rust_doc#search_under_cursor(query) range
  if a:query ==# ''
    echomsg 'rust-doc: No identifier is found under the cursor'
    return
  endif

  call rust_doc#open_fuzzy(a:query)
endfunction
