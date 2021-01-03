" Functions
function! vimrc#rust_doc#search_under_cursor(query) range abort
  if a:query ==# ''
    echomsg 'rust-doc: No identifier is found under the cursor'
    return
  endif

  call rust_doc#open_fuzzy(a:query)
endfunction

" Open rust doc
function! vimrc#rust_doc#open(url) abort
  let url = a:url

  if has('wsl')
    if url =~# '^file://'
      let original_path = substitute(url, '^file://', '', '')

      " Check if path is in mount Windows drive
      if original_path =~# '^/mnt/\w\+'
        let final_path = substitute(original_path, '\v^/mnt/(\w+)', '\1:', '')
      else
        let final_path = '//wsl$/'.vimrc#plugin#check#get_distro().original_path
      endif

      let url = 'file:///'.final_path
    endif
  endif

  call openbrowser#open(url)
endfunction

" Open rustup doc
function! vimrc#rust_doc#open_rustup_doc(...) abort
  let open_rustup_doc_command = 'rustup doc '.join(a:000)
  if has('wsl')
    " TODO Check if open_rustup_doc.sh exists
    let open_rustup_doc_command = 'env BROWSER=open_rustup_doc.sh '.open_rustup_doc_command
  endif

  call jobstart(open_rustup_doc_command, {})
endfunction

" Utilities
function! vimrc#rust_doc#get_cursor_word() abort
  setlocal iskeyword+=:
  let cursor_word = expand('<cword>')
  setlocal iskeyword-=:
  return cursor_word
endfunction
