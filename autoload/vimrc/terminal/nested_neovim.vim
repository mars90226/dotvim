let s:nested_neovim_key_mappings = {}

" Use <M-q> as prefix
" TODO Add key mapping for inserting <M-q>
function! vimrc#terminal#nested_neovim#start(prefix, start_count) abort
  let prefix_count = a:start_count
  let c = vimrc#getchar_string('Nested neovim, press any key: ')
  while c ==# a:prefix
    let prefix_count += 1
    let c = vimrc#getchar_string('Nested neovim, press any key: ')
  endwhile

  if !has_key(s:nested_neovim_key_mappings, c)
    redraw | echo ''
    " FIXME This may cause terminal to take another character before go back
    " to normal
    return ''
  endif
  let target_key = s:nested_neovim_key_mappings[c]

  let result = ''
  for i in range(1, float2nr(pow(2, prefix_count)))
    let result .= "\<C-\>"
  endfor
  let result .= "\<C-N>".target_key

  redraw | echo ''
  return result
endfunction

" TODO Add prefix for different type of nested neovim key mappings
function! vimrc#terminal#nested_neovim#register(key, target) abort
  let s:nested_neovim_key_mappings[a:key] = a:target
endfunction
