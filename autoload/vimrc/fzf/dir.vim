let s:fd_command = 'fd --no-ignore --hidden --follow'

function! vimrc#fzf#dir#all_files(query, bang)
  call fzf#vim#files(a:query,
        \ a:bang ? fzf#vim#with_preview({ 'source': s:fd_command }, 'up:60%')
        \        : fzf#vim#with_preview({ 'source': s:fd_command }),
        \ a:bang)
endfunction
