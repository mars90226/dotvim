" For vim-markdown-composer plugin

" Functions
function! vimrc#composer#build_composer(info) abort
  if a:info.status !=# 'unchanged' || a:info.force
    !cargo build --release
  endif
endfunction
