function! fzf#vim#with_preview(opts) abort
  return copy(a:opts)
endfunction

function! fzf#vim#files(dir, opts, bang) abort
  return fzf#run(a:opts)
endfunction
