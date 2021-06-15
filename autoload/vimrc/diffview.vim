" Mappings
function! vimrc#diffview#mappings()
  call vimrc#git#include_git_mappings('diffview_files', v:false, v:true)

  nnoremap <silent><buffer> <C-L> :DiffviewRefresh<CR>
endfunction

function! vimrc#diffview#buffer_mappings()
  call vimrc#git#include_git_mappings('diffview_buffer')
endfunction
