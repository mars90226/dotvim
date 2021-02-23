" Config
let g:floaterm_position = 'center'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.8
let g:floaterm_winblend = 0
let g:floaterm_autoclose = v:false

" Mappings
nnoremap <silent> <M-2>      :FloatermToggle<CR>
nnoremap <silent> <M-3>      :FloatermPrev<CR>
nnoremap <silent> <M-4>      :FloatermNext<CR>
nnoremap <silent> <M-5>      :FloatermNew!<CR>
nnoremap <silent> <Leader>xh :FloatermHide<CR>
nnoremap          <Leader>xs :execute 'FloatermSend '.input('Command: ', '', 'shellcmd')<CR>
nnoremap          <Leader>xc :execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>
xnoremap          <Leader>xc :<C-U>execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>
" For inserting selection in input() using cmap
nnoremap          <Leader>xC :execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>
" For inserting selection in input() using cmap
xnoremap          <Leader>xC :<C-U>execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>
nnoremap          <Leader>xw :execute 'FloatermNew! cd '.shellescape(getcwd())<CR>

" For terminal
tnoremap <M-2>      <C-\><C-N>:FloatermToggle<CR>
tnoremap <M-3>      <C-\><C-N>:FloatermPrev<CR>
tnoremap <M-4>      <C-\><C-N>:FloatermNext<CR>
tnoremap <M-5>      <C-\><C-N>:FloatermNew<CR>

" For nested neovim
tnoremap <M-q><M-2> <C-\><C-\><C-N>:FloatermToggle<CR>
tnoremap <M-q><M-3> <C-\><C-\><C-N>:FloatermPrev<CR>
tnoremap <M-q><M-4> <C-\><C-\><C-N>:FloatermNext<CR>
tnoremap <M-q><M-5> <C-\><C-\><C-N>:FloatermNew!<CR>

" For nested nested neovim
call vimrc#terminal#nested_neovim#register("\<M-2>", ":FloatermToggle\<CR>")
call vimrc#terminal#nested_neovim#register("\<M-3>", ":FloatermPrev\<CR>")
call vimrc#terminal#nested_neovim#register("\<M-4>", ":FloatermNext\<CR>")
call vimrc#terminal#nested_neovim#register("\<M-5>", ":FloatermNew!\<CR>")
