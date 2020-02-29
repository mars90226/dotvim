" Functions
function! vimrc#zoom#zoom()
  if winnr('$') > 1
    tab split
    call vimrc#set_scratch()
  elseif len(filter(map(range(tabpagenr('$')), 'tabpagebuflist(v:val + 1)'),
                  \ 'index(v:val, '.bufnr('').') >= 0')) > 1
    tabclose
    tabprevious
  endif
endfunction

function! vimrc#zoom#selected(selected)
  let filetype = &filetype
  tabnew
  call append(line('$'), split(a:selected, "\n"))
  1delete
  call vimrc#set_scratch()
  let &filetype = filetype
endfunction

function! vimrc#zoom#float()
  if vimrc#float#is_float(win_getid())
    VimrcFloatToggle
  else
    execute 'VimrcFloatNew edit '.expand('%')
  endif
endfunction

function! vimrc#zoom#float_selected(selected)
  let filetype = &filetype

  VimrcFloatNew
  call append(line('$'), split(a:selected, "\n"))
  1delete

  let &filetype = filetype
endfunction

function! vimrc#zoom#into_float()
  if vimrc#float#is_float(win_getid())
    VimrcFloatToggle
  else
    let bufnr = bufnr('%')
    close
    execute 'VimrcFloatNew buffer '.bufnr
  endif
endfunction
