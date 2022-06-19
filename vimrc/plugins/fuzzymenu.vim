" Commands
" Before pull request merged: https://github.com/laher/fuzzymenu.vim/pull/4
command! -bang -nargs=0 Fzm call fuzzymenu#Run({'fullscreen': <bang>0})

" Mappings
nmap <Space>m <Plug>(Fzm)
xmap <Space>m <Plug>(FzmVisual)

" Setup {{{
" Utility
call vimrc#fuzzymenu#try_add('ToggleFold', { 'exec': 'ToggleFold' })
call vimrc#fuzzymenu#try_add('ToggleIndent', { 'exec': 'ToggleIndent' })

" Terminal
call vimrc#fuzzymenu#try_add('SplitTerm', { 'exec' : 'new | terminal' })
call vimrc#fuzzymenu#try_add('TabTerm', { 'exec' : 'tabe | terminal' })
call vimrc#fuzzymenu#try_add('VerticalTerm', { 'exec' : 'vnew | terminal' })
" }}}
