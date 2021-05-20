if exists('b:loaded_todo_settings')
  finish
endif
let b:loaded_todo_settings = 1

setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal expandtab

function! s:todo_cleanup_star() abort
  let l:save = winsaveview()
  let line_number = 1
  for line in getline(1, '$')
    call setline(line_number, substitute(line, '\* ', '', 'e'))
    let line_number += 1
  endfor
  call winrestview(l:save)
endfunction

function! s:todo_set_ongoing() abort
  let l:save = winsaveview()
  let line_number = 1
  for line in getline(1, '$')
    call setline(line_number, substitute(line, '\[.\] `\[ongoing\]`', '[~]', 'e'))
    let line_number += 1
  endfor
  call winrestview(l:save)
endfunction

function! s:todo_set_done() abort
  let l:save = winsaveview()
  let line_number = 1
  for line in getline(1, '$')
    call setline(line_number, substitute(line, '\[X\]', '[x]', 'e'))
    let line_number += 1
  endfor
  call winrestview(l:save)
endfunction

function! s:todo_set_section() abort
  let l:save = winsaveview()
  let line_number = 1
  for line in getline(1, '$')
    call setline(line_number, substitute(line, '^\v\[.\] ([^:]+):', '[\1]', 'e'))
    let line_number += 1
  endfor
  call winrestview(l:save)
endfunction

function! s:todo_remove_category_header() abort
  %global/^\v`\[(finished|ongoing|todo|postpone)\]`:$/delete
endfunction

function! s:todo_format() abort
  %retab
  call s:todo_cleanup_star()
  call s:todo_set_ongoing()
  call s:todo_set_done()
  call s:todo_set_section()
  call s:todo_remove_category_header()
endfunction

command! -buffer TodoFormat call s:todo_format()
