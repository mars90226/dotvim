" Functions
function! vimrc#rust_doc#search_under_cursor(query) range
  if a:query ==# ''
    echomsg 'rust-doc: No identifier is found under the cursor'
    return
  endif

  call rust_doc#open_fuzzy(a:query)
endfunction

" Open rust doc
function! vimrc#rust_doc#open(url)
  let url = a:url

  if vimrc#plugin#check#get_wsl_environment() == "yes"
    if url =~ "^file://"
      let original_path = substitute(url, "^file://", '', '')
      let url = 'file://///wsl$/'.vimrc#plugin#check#get_distro().original_path
    endif
  endif

  call openbrowser#open(url)
endfunction
