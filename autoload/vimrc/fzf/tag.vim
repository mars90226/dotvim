" Sources
function! vimrc#fzf#tag#get_tselect(query)
  let tselect_output = split(execute("tselect " . a:query, "silent!"), "\n")[1:-2]
  let tselect_candidates = []
  let tselect_current_candidate = []
  for line in tselect_output
    if line =~ '^\s\+\d'
      if !empty(tselect_current_candidate)
        call add(tselect_candidates, join(tselect_current_candidate, "\t"))
        let tselect_current_candidate = []
      endif
    endif

    call add(tselect_current_candidate, line)
  endfor
  if !empty(tselect_current_candidate)
    call add(tselect_candidates, join(tselect_current_candidate, "\t"))
  endif

  return tselect_candidates
endfunction

" Sinks
function! vimrc#fzf#tag#tselect_sink(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  let qfl = []
  for target in a:lines[1:]
    let infos = split(target, "\t")
    " # [pri] kind tag file
    " This will capture last component
    let filename = matchlist(infos[0], '\v^%(\s+\S+)*\s+(\S+)')[1]
    let pattern = substitute(infos[-1], '^\s*\(.\{-}\)\s*$', '\1', '')
    execute cmd . ' ' . filename
    execute '/\V' . pattern
    call add(qfl, {'filename': expand('%'), 'lnum': line('.'), 'text': getline('.')})
    normal! zzzv
  endfor
  call vimrc#fzf#fill_quickfix(qfl, 'clast')
  normal! zzzv
endfunction

" Commands
function! vimrc#fzf#tag#tselect(query)
  call fzf#run(fzf#wrap({
        \ 'source': vimrc#fzf#tag#get_tselect(a:query),
        \ 'sink*':   function('vimrc#fzf#tag#tselect_sink'),
        \ 'options': '-m +s --expect=' . vimrc#fzf#expect_keys(),
        \ 'down':   '40%'}))
endfunction

" Need neovim terminal
function! vimrc#fzf#tag#project_tags(query, ...)
  let s:origin_tags = &tags
  set tags-=./tags;
  augroup project_tags_callback
    autocmd!
    autocmd TermClose term://*fzf*
          \ let &tags = s:origin_tags |
          \ autocmd! project_tags_callback
  augroup END
  call call('fzf#vim#tags', [a:query] + a:000)
endfunction

" Need neovim terminal
function! vimrc#fzf#tag#tagbar_tags()
  TagbarOpenAutoClose
  augroup tagbar_tags_callback
    autocmd!
    autocmd TermClose term://*fzf*
          \ call nvim_input('<CR>') |
          \ autocmd! tagbar_tags_callback
  augroup END
  BLines
endfunction
