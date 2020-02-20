" This file is for commands that use Neovim's job API

if has("nvim")
  " Asynchronous open URI
  if has("unix") && executable("xdg-open")
    command! -bar -nargs=1 Browse call vimrc#browser#async_browse(<f-args>)
    nnoremap <Leader>bb :execute 'Browse ' . expand('<cWORD>')<CR>
    nnoremap <Leader>bB :execute 'Browse ' . expand('<cword>')<CR>
    xnoremap <Leader>bb :<C-U>execute 'Browse ' . vimrc#get_visual_selection()<CR>
  endif

  " Asynchronous open URL in browser
  " For now, this function can be done by Browse command
  command! -bar -nargs=1 OpenUrl call vimrc#browser#async_open_url(<f-args>)

  " Asynchronous search keyword in browser
  command! -bar -nargs=1 SearchKeyword call vimrc#browser#async_search_keyword(<f-args>)
  nnoremap <Leader>kk :execute 'SearchKeyword ' . expand('<cword>')<CR>
  nnoremap <Leader>kK :execute 'SearchKeyword ' . expand('<cWORD>')<CR>
  xnoremap <Leader>kk :<C-U>execute 'SearchKeyword ' . vimrc#get_visual_selection()<CR>

  " Asynchronous open URL in client browser
  command! -bar -nargs=1 ClientOpenUrl call vimrc#browser#client_async_open_url(<f-args>)
  nnoremap <Leader>bc :execute 'ClientOpenUrl ' . expand('<cWORD>')<CR>
  nnoremap <Leader>bC :execute 'ClientOpenUrl ' . expand('<cword>')<CR>
  xnoremap <Leader>bc :<C-U>execute 'ClientOpenUrl ' . vimrc#get_visual_selection()<CR>

  " Asynchronous search keyword in client browser
  command! -bar -nargs=1 ClientSearchKeyword call vimrc#browser#client_async_search_keyword(<f-args>)
  nnoremap <Leader>kc :execute 'ClientSearchKeyword ' . expand('<cword>')<CR>
  nnoremap <Leader>kC :execute 'ClientSearchKeyword ' . expand('<cWORD>')<CR>
  xnoremap <Leader>kc :<C-U>execute 'ClientSearchKeyword ' . vimrc#get_visual_selection()<CR>
endif
