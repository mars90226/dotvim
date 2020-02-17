" This file is for commands that use Neovim's job API

if has("nvim")
  " Asynchronous open URI
  if has("unix") && executable("xdg-open")
    command! -bar -nargs=1 Browse call vimrc#async_browse(<f-args>)
    nnoremap <Leader>bb :execute 'Browse ' . expand('<cword>')<CR>
    nnoremap <Leader>bB :execute 'Browse ' . expand('<cWORD>')<CR>
    xnoremap <Leader>bb :<C-U>execute 'Browse ' . vimrc#get_visual_selection()<CR>
  endif

  " Asynchronous open URL in browser
  command! -bar -nargs=1 OpenUrl call vimrc#async_open_url_in_browser(<f-args>)

  " Asynchronous search keyword in browser
  command! -bar -nargs=1 SearchKeyword call vimrc#async_search_keyword_in_browser(<f-args>)
  nnoremap <Leader>kk :execute 'SearchKeyword ' . expand('<cword>')<CR>
  nnoremap <Leader>kK :execute 'SearchKeyword ' . expand('<cWORD>')<CR>
  xnoremap <Leader>kk :<C-U>execute 'SearchKeyword ' . vimrc#get_visual_selection()<CR>

  " Asynchronous open URL in client browser
  command! -bar -nargs=1 OpenUrlInClientBrowser call vimrc#async_open_url_in_client_browser(<f-args>)
  nnoremap <Leader>bc :execute 'OpenUrlInClientBrowser ' . expand('<cword>')<CR>
  nnoremap <Leader>bC :execute 'OpenUrlInClientBrowser ' . expand('<cWORD>')<CR>
  xnoremap <Leader>bc :<C-U>execute 'OpenUrlInClientBrowser ' . vimrc#get_visual_selection()<CR>

  " Asynchronous search keyword in client browser
  command! -bar -nargs=1 SearchKeywordInClientBrowser call vimrc#async_search_keyword_in_client_browser(<f-args>)
  nnoremap <Leader>kc :execute 'SearchKeywordInClientBrowser ' . expand('<cword>')<CR>
  nnoremap <Leader>kC :execute 'SearchKeywordInClientBrowser ' . expand('<cWORD>')<CR>
  xnoremap <Leader>kc :<C-U>execute 'SearchKeywordInClientBrowser ' . vimrc#get_visual_selection()<CR>
endif
