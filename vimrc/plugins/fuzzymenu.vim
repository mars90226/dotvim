" Commands
" Before pull request merged: https://github.com/laher/fuzzymenu.vim/pull/4
command! -bang -nargs=0 Fzm call fuzzymenu#Run({'fullscreen': <bang>0})

" Mappings
nmap <Space>m <Plug>(Fzm)
xmap <Space>m <Plug>(FzmVisual)
