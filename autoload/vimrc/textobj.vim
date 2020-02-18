" Functions

let s:unicode_pattern = '[^\x00-\x7F]'
function! vimrc#textobj#inner_surround_unicode()
  let original_pos = getpos('.')[1:2]

  let start = searchpos(s:unicode_pattern, 'beW')
  call cursor(original_pos)
  let end   = searchpos(s:unicode_pattern, 'ceW')

  normal! v
  call cursor(start)
  normal! l
  normal! o
  call cursor(end)
endfunction

function! vimrc#textobj#around_surround_unicode()
  let original_pos = getpos('.')[1:2]

  let start = searchpos(s:unicode_pattern, 'beW')
  call cursor(original_pos)
  let end   = searchpos(s:unicode_pattern, 'ceW')

  normal! v
  call cursor(start)
  normal! o
  call cursor(end)
  normal! l
endfunction
