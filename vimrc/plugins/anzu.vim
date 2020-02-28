map n <Plug>(incsearch-nohl)<Plug>(anzu-n-with-echo)
map N <Plug>(incsearch-nohl)<Plug>(anzu-N-with-echo)

command! AnzuToggleUpdate call vimrc#anzu#toggle_update()

augroup anzu_disable_update_on_large_file
  autocmd!
  autocmd BufWinEnter,WinEnter * call vimrc#anzu#disable_on_large_file()
augroup END
