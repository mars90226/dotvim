" Functions
function! vimrc#toggle#indent() abort
  if &expandtab
    setlocal noexpandtab
    setlocal tabstop=4
    setlocal softtabstop=4
    setlocal shiftwidth=4
  else
    setlocal expandtab
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal shiftwidth=2
  endif
endfunction

" Toggle fold between manual and syntax
function! vimrc#toggle#fold_method() abort
  if &foldmethod ==# 'manual'
    if v:lua.require('vimrc.choose').is_enabled_plugin('nvim-treesitter')
      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
    else
      setlocal foldmethod=syntax
      setlocal foldexpr&
    endif
  else
    setlocal foldmethod=manual
    setlocal foldexpr&
  endif
endfunction

function! vimrc#toggle#parent_folder_tag() abort
  let s:parent_folder_tag_pattern = './tags;'
  if index(split(&tags, ','), s:parent_folder_tag_pattern) != -1
    execute 'set tags-=' . s:parent_folder_tag_pattern
  else
    execute 'set tags+=' . s:parent_folder_tag_pattern
  endif
endfunction
