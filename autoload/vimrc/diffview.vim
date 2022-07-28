" Mappings
function! vimrc#diffview#mappings()
  call vimrc#git#include_git_mappings('diffview_files', v:false, v:true)
  call vimrc#search#define_search_mappings()

  nnoremap <silent><buffer> <C-L> :DiffviewRefresh<CR>
endfunction

function! vimrc#diffview#buffer_mappings()
  call vimrc#git#include_git_mappings('diffview_buffer')
  call vimrc#search#define_search_mappings()
endfunction

function! vimrc#diffview#history_mappings()
  call vimrc#git#include_git_mappings('diffview_history', v:true, v:true)
  call vimrc#search#define_search_mappings()
endfunction
