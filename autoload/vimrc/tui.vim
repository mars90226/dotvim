" Functions

" Use surfraw
function! vimrc#tui#google_keyword(keyword)
  let escaped_keyword = vimrc#escape_symbol(a:keyword)

  if vimrc#plugin#is_enabled_plugin('vim-floaterm')
    execute 'FloatermNew sr google '.escaped_keyword.'; exit'
  else
    call vimrc#terminal#open_current_folder('new', 'sr google '.escaped_keyword)
  endif
endfunction

function! vimrc#tui#run(split, command)
  let floaterm_wrappers = ["fff", "fzf", "ranger"]
  let split = a:split == "float" && vimrc#plugin#is_disabled_plugin('vim-floaterm') ? "new" : a:split

  if split == "float"
    if index(floaterm_wrappers, a:command) != -1
      execute 'FloatermNew '.a:command
    else
      call floaterm#terminal#open(-1, a:command)
    endif
  else
    call vimrc#terminal#open_current_folder(split, a:command)
  endif
endfunction
