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
  let winid = win_getid()
  if vimrc#float#is_float(winid)
    quit
  else
    let bufnr = bufnr('%')
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(bufnr, width, height)
  endif
endfunction

function! vimrc#zoom#float_selected(selected)
  let filetype = &filetype

  let [width, height] = vimrc#float#get_default_size()
  call vimrc#float#open(-1, width, height)

  call append(line('$'), split(a:selected, "\n"))
  1delete

  let &filetype = filetype
endfunction
