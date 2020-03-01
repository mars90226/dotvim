if !exists('s:last_tabs')
  let s:last_tabs = [1]
endif

function! vimrc#last_tab#get()
  return s:last_tabs
endfunction

function! vimrc#last_tab#jump(count)
  if a:count >= 0 && a:count < len(s:last_tabs)
    let tabnr = s:last_tabs[a:count]
  else
    let tabnr = s:last_tabs[-1]
  endif
  let last_tab_nr = tabpagenr('$')
  if tabnr > last_tab_nr
    echoerr 'Tab number ' . tabnr . ' is not exist!'
  else
    execute 'tabnext ' . tabnr
  endif
endfunction

function! vimrc#last_tab#insert(tabnr)
  " Insert last tab
  let s:last_tabs = filter(s:last_tabs, 'v:val != ' . a:tabnr)
  call insert(s:last_tabs, a:tabnr, 0)

  " Truncate last_tabs when containing more than all tabs
  let count_tabcount = tabpagenr('$') - 1
  if count_tabcount > len(s:last_tabs)
    let s:last_tabs = s:last_tabs[0 : count_tabcount]
  endif
endfunction

function! vimrc#last_tab#clear_invalid()
  " Clear invalid last tab
  let new_last_tabs = []
  for last_tab in s:last_tabs
    if last_tab <= tabpagenr('$')
      call add(new_last_tabs, last_tab)
    endif
  endfor
  let s:last_tabs = new_last_tabs
endfunction
