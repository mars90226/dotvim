" Settings
" TODO: Disable foldmethod=expr by default, it's too slow
" ref: https://github.com/nvim-treesitter/nvim-treesitter/issues/1100
" set foldmethod=expr
" set foldexpr=nvim_treesitter#foldexpr()

" nvim-ts-hint-textobject
onoremap <silent> m <Cmd>lua require('tsht').nodes()<CR>
xnoremap <silent> m <Cmd>lua require('tsht').nodes()<CR>
