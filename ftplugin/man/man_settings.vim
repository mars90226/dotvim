if exists('b:loaded_man_settings')
  finish
endif
let b:loaded_man_settings = 1

nnoremap <silent><buffer> <Leader>gf :call vimrc#zoom#into_float()<CR>
