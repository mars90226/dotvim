if exists('b:loaded_ruby_settings')
  finish
endif
let b:loaded_ruby_settings = 1

" gvim feature
if exists('&balloneval')
  setlocal noballooneval
endif
