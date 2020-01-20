" This file is for commands that use Neovim's job API

if has("nvim")
  " Asynchronous open URI
  if has("unix") && executable("xdg-open")
    command! -bar -nargs=1 Browse call vimrc#async_browse(<f-args>)
    nnoremap <Leader>b :execute 'Browse ' . expand('<cword>')<CR>
    nnoremap <Leader>B :execute 'Browse ' . expand('<cWORD>')<CR>
  endif

  " Asynchronous open URL in browser
  command! -bar -nargs=1 OpenUrl call vimrc#async_open_url_in_browser(<f-args>)

  " Asynchronous search keyword in browser
  command! -bar -nargs=1 SearchKeyword call vimrc#async_search_keyword_in_browser(<f-args>)
  nnoremap <Leader>k :execute 'SearchKeyword ' . expand('<cword>')<CR>
  nnoremap <Leader>K :execute 'SearchKeyword ' . expand('<cWORD>')<CR>

  " Asynchronous open URL in client browser
  command! -bar -nargs=1 OpenUrlInClientBrowser call vimrc#async_open_url_in_client_browser(<f-args>)

  " Asynchronous search keyword in client browser
  command! -bar -nargs=1 SearchKeywordInClientBrowser call vimrc#async_search_keyword_in_client_browser(<f-args>)
endif
