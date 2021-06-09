" Utilities
function! vimrc#fzf#coc#setup_query_callback(query) abort
  let s:origin_coc_fzf_opts = copy(g:coc_fzf_opts)
  let g:coc_fzf_opts += ['--query', a:query]
  augroup coc_fzf_query_callback
    autocmd!
    autocmd TermClose term://*fzf*
          \ let g:coc_fzf_opts = s:origin_coc_fzf_opts |
          \ autocmd! coc_fzf_query_callback
  augroup END
endfunction

" Functions
function! vimrc#fzf#coc#call_with_query(cmd, query) abort
  call vimrc#fzf#coc#setup_query_callback(a:query)
  execute a:cmd
endfunction
