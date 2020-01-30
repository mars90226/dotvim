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
  if vimrc#plugin#check#get_wsl_environment() == "yes"
    let original_path = substitute(a:url, "^file://", '', '')
    let wsl_path = 'file://///wsl$/'.vimrc#plugin#check#get_distro().original_path

    call openbrowser#open(wsl_path)
  else
    call openbrowser#open(a:url)
  endif
endfunction
