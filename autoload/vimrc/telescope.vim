function! vimrc#telescope#setup_project_tags_callback(origin_tags) abort
  let s:origin_tags = a:origin_tags
  augroup project_tags_callback
    autocmd!
    autocmd BufLeave *
          \ if &filetype ==# 'TelescopePrompt' |
          \   call vimrc#tags#restore_tags(s:origin_tags) |
          \ autocmd! project_tags_callback
  augroup END
endfunction

function! vimrc#telescope#project_tags() abort
  call vimrc#telescope#setup_project_tags_callback(vimrc#tags#use_project_tags())
  Telescope tags
endfunction
