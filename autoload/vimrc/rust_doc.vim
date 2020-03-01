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

  if has('wsl')
    if url =~# '^file://'
      let original_path = substitute(url, '^file://', '', '')
      let url = 'file://///wsl$/'.vimrc#plugin#check#get_distro().original_path
    endif
  endif

  call openbrowser#open(url)
endfunction

" Open rustup doc
function! vimrc#rust_doc#open_rustup_doc(topic)
  let open_rustup_doc_command = 'rustup doc '.a:topic
  if has('wsl')
    " TODO Check if open_rustup_doc.sh exists
    let open_rustup_doc_command = 'env BROWSER=open_rustup_doc.sh '.open_rustup_doc_command
  endif

  call jobstart(open_rustup_doc_command, {})
endfunction

" Utilities
function! vimrc#rust_doc#get_cursor_word()
  setlocal iskeyword+=:
  let cursor_word = expand('<cword>')
  setlocal iskeyword-=:
  return cursor_word
endfunction
