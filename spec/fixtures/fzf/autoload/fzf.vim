function! fzf#wrap(name, opts, ...) abort
  return copy(a:opts)
endfunction

function! fzf#shellescape(value) abort
  return shellescape(a:value)
endfunction

function! s:complete(opts, timer) abort
  call a:opts.exit(g:fzf_test_code)
  if g:fzf_test_code == 0
    if has_key(a:opts, 'sink*')
      call a:opts['sink*']([get(g:, 'fzf_test_accept_key', ''), g:fzf_test_selection])
    else
      call a:opts.sink(g:fzf_test_selection)
    endif
  endif
endfunction

function! fzf#run(opts) abort
  let g:fzf_test_options = get(a:opts, 'options', [])
  call timer_start(10, function('s:complete', [a:opts]))
  return []
endfunction
