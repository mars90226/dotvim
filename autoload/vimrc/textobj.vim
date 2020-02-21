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

function! vimrc#textobj#past_character(count, mode, forward)
  let character = nr2char(getchar())
  let mode_prefix = a:mode == 'v' ? 'gv' : ''
  let find_command = a:forward ? 'f' : 'F'
  let past_suffix = a:forward ? 'l' : 'h'
  let past_suffix = a:mode == 'n' ? past_suffix : past_suffix.past_suffix
  execute 'normal! '.mode_prefix.a:count.find_command.character.past_suffix
endfunction
