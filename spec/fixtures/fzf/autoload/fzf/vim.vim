function! fzf#vim#with_preview(...) abort
  return copy(get(a:000, 0, {}))
endfunction

function! fzf#vim#files(dir, opts, bang) abort
  if exists('g:fzf_test_file_calls')
    call add(g:fzf_test_file_calls, [a:dir, a:opts, a:bang])
    return
  endif
  return fzf#run(a:opts)
endfunction

function! fzf#vim#commits(args, spec, bang) range abort
  let g:fzf_test_commits = [0, a:firstline, a:lastline, a:args, a:spec, a:bang, copy(g:fzf_action), get(b:, 'fzf_winview', v:null)]
  unlet! b:fzf_winview
endfunction

function! fzf#vim#buffer_commits(args, spec, bang) range abort
  let g:fzf_test_commits = [1, a:firstline, a:lastline, a:args, a:spec, a:bang, copy(g:fzf_action), get(b:, 'fzf_winview', v:null)]
  unlet! b:fzf_winview
  if get(g:, 'fzf_test_commits_fail', 0)
    throw 'commit picker launch failed'
  endif
endfunction
