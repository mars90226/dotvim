" Utility

" Functions
function! vimrc#windows#execute_current_file()
  !start cmd /c "%:p"
endfunction

function! vimrc#windows#open_terminal_in_current_file_folder()
  !start cmd /K cd /D %:p:h
endfunction

function! vimrc#windows#reveal_current_file_folder_in_explorer()
  execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'
endfunction
