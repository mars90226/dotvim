if exists('b:loaded_log_settings')
  finish
endif
let b:loaded_log_settings = 1

call vimrc#search#define_search_mappings()
