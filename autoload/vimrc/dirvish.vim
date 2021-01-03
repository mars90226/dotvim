" Mappings
function! vimrc#dirvish#mappings() abort
  nmap <silent><buffer> h <Plug>(dirvish_up)
  nmap <silent><buffer> l <CR>

  nnoremap <silent><buffer> q :call vimrc#dirvish#quit()<CR>

  " Quick change directory
  nnoremap <silent><buffer> cv :execute 'edit '.expand(input('cd: ', '', 'dir'))<CR>
  nnoremap <silent><buffer> gv :edit $VIMRUNTIME<CR>
  nnoremap <silent><buffer> gl :edit /usr/lib<CR>
  nnoremap <silent><buffer> gr :edit /<CR>
  nnoremap <silent><buffer><nowait> \\ :execute 'edit '.getcwd()<CR>

  " Files & Rg
  nnoremap <silent><buffer> \f :call fzf#vim#files(expand('%'), fzf#vim#with_preview(), 0)<CR>
  nnoremap <silent><buffer> \r :execute 'RgWithOption '.expand('%').'::'.input('Rg: ')<CR>

  " Actions
  nmap <silent><buffer> gK <Plug>(dirvish_K)
  nnoremap <silent><buffer> dd :call vimrc#utility#ask_execute('!rm -rf '.vimrc#dirvish#get_path(), 'Confirm delete?')<CR>
  nnoremap <silent><buffer> r :call vimrc#utility#execute_command('!mv '.vimrc#dirvish#get_path().' %/', "rename from '".vimrc#dirvish#get_filename()."' to: ", 1)<CR>
  nnoremap <silent><buffer> K :call vimrc#utility#execute_command('Mkdir %/', 'new directory: ', 1)<CR>
  nnoremap <silent><buffer> N :call vimrc#utility#execute_command('!touch %/', 'new file: ', 1)<CR>
endfunction

function! vimrc#dirvish#toggle() abort
  let current_winid = win_getid()
  let dirvish_sidebar_winid = vimrc#dirvish#find_sidebar()
  if dirvish_sidebar_winid != -1
    if vimrc#dirvish#is_sidebar()
      let original_winid = get(w:, 'dirvish_original_winid', 1)
    else
      let original_winid = current_winid
    endif

    if winnr('$') > 1
      call win_gotoid(dirvish_sidebar_winid)
      close
      call win_gotoid(original_winid)
    endif
  else
    let width = get(g:, 'dirvish_sidebar_width', 35)
    vsplit
    wincmd H
    Dirvish
    let w:dirvish_sidebar = v:true
    let w:dirvish_original_winid = current_winid
    execute 'vertical resize '.width
  endif
endfunction

function! vimrc#dirvish#find_sidebar() abort
  for i in range(1, winnr('$'))
    if getwinvar(i, 'dirvish_sidebar', v:false)
      return win_getid(i)
    endif
  endfor

  return -1
endfunction

function! vimrc#dirvish#is_sidebar() abort
  return get(w:, 'dirvish_sidebar', v:false)
endfunction

function! vimrc#dirvish#quit() abort
  if vimrc#dirvish#is_sidebar()
    close
  else
    execute "normal \<Plug>(dirvish_quit)"
  endif
endfunction

function! vimrc#dirvish#get_path() abort
  return getline('.')
endfunction

function! vimrc#dirvish#get_filename() abort
  return fnamemodify(vimrc#dirvish#get_path(), ':t')
endfunction
