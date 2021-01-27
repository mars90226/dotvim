" Sink
function! vimrc#fzf#last_tab#last_tabs_sink(line) abort
  let list = matchlist(a:line, '^ *\([0-9]\+\) *\([0-9]\+\)')
  execute list[1].'tabnext'
endfunction

" Source
function! vimrc#fzf#last_tab#last_tabs_source() abort
  let jumps_source = []
  let last_tabs = vimrc#last_tab#get()

  for tabnr in last_tabs
    let winnr = tabpagewinnr(tabnr)
    let bufnr = tabpagebuflist(tabnr)[winnr - 1]
    let fname = expand('#' . bufnr)

    call add(jumps_source, printf('%3d %3d   %s', tabnr, winnr, fname))
  endfor

  return jumps_source
endfunction

function! vimrc#fzf#last_tab#last_tabs() abort
  let options = extend(vimrc#fzf#preview#windows()['options'],
        \ ['+s', '--header-lines=1', '--prompt', 'LastTab> '])

  call fzf#run(fzf#wrap('LastTab', {
    \ 'source': extend(['Tab Win   Name'], vimrc#fzf#last_tab#last_tabs_source()),
    \ 'sink': function('vimrc#fzf#last_tab#last_tabs_sink'),
    \ 'options': options}))
endfunction
