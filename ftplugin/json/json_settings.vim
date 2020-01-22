if exists('b:loaded_json_settings')
  finish
endif
let b:loaded_json_settings = 1

setlocal formatexpr=CocAction('formatSelected')
