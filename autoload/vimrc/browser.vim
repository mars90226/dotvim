" Utility functions

function! vimrc#browser#get()
  if executable('firefox')
    return "firefox"
  elseif executable('chrome')
    return "chrome"
  else
    return ""
  endif
endfunction

function! vimrc#browser#get_search_command(keyword)
  if executable('firefox')
    return "firefox --search '" . a:keyword . "'"
  elseif executable('chrome')
    return "chrome '? " . a:keyword . "'"
  else
    return ""
  endif
endfunction

function! vimrc#browser#get_client_command(command)
  " TODO Check client browser
  return "ssh ".$SSH_CLIENT_HOST." 'firefox ".a:command."'"
endfunction

function! vimrc#browser#get_client_search_command(keyword)
  " TODO Check client browser
  return "ssh ".$SSH_CLIENT_HOST." \"firefox --search '".a:keyword."'\""
endfunction
