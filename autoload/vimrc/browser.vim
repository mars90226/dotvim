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

" Functions
" Asynchronously browse URI
" TODO Move to better place?
function! vimrc#browser#async_browse(uri)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  " Use xdg-open to open URI
  if !has("unix") || !executable("xdg-open")
    echoerr "No xdg-open found!"
    return
  endif

  call jobstart('xdg-open ' . a:uri, {})
endfunction

" Asynchronously open URL in browser
function! vimrc#browser#async_open_url(url)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let browser = vimrc#browser#get()
  if empty(browser)
    echoerr "No browser found!"
    return
  endif

  call jobstart(browser . ' ' . a:url, {})
endfunction

" Asynchronously search keyword in browser
function! vimrc#browser#async_search_keyword(keyword)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let search_command = vimrc#browser#get_search_command(a:keyword)
  if empty(search_command)
    echoerr "No browser found!"
    return
  endif

  call jobstart(search_command, {})
endfunction

" Asynchronously open URL in client browser
function! vimrc#browser#client_async_open_url(url)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let client_browser_command = vimrc#browser#get_client_command(a:url)
  if empty(client_browser_command)
    echoerr "No browser found!"
    return
  endif

  call jobstart(client_browser_command, {})
endfunction

" Asynchronously search keyword in client browser
function! vimrc#browser#client_async_search_keyword(keyword)
  " Currently only support neovim
  if !vimrc#plugin#check#has_rpc()
    echoerr "This version of vim does not have RPC!"
    return
  endif

  let client_browser_search_command = vimrc#browser#get_client_search_command(a:keyword)
  if empty(client_browser_search_command)
    echoerr "No browser found!"
    return
  endif

  call jobstart(client_browser_search_command, {})
endfunction
