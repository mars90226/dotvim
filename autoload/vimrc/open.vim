" Functions
function! vimrc#open#switch(file, fallback_command) abort
  let bufnr = bufnr(a:file)
  let winids = win_findbuf(bufnr)
  if empty(winids)
    execute 'silent '.a:fallback_command.' '.a:file
  else
    call win_gotoid(winids[0])
  endif
endfunction

function! vimrc#open#tab(file) abort
  if v:lua.require('vimrc.choose').is_enabled_plugin('defx.nvim')
    call vimrc#defx#open(a:file, 'tab')
  else
    execute 'tabedit '.a:file
  endif
endfunction
