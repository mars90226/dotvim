if exists('b:loaded_messages_settings')
  finish
endif
let b:loaded_messages_settings = 1

call vimrc#search#define_search_mappings()
