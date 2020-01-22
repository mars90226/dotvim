if exists('b:loaded_typescript_settings')
  finish
endif
let b:loaded_typescript_settings = 1

setlocal formatexpr=CocAction('formatSelected')
