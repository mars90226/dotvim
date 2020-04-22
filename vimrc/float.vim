" Zoom
nnoremap <silent> <Leader>zz :call vimrc#zoom#zoom()<CR>
xnoremap <silent> <Leader>zz :<C-U>call vimrc#zoom#selected(vimrc#utility#get_visual_selection())<CR>

if has('nvim') && vimrc#plugin#check#has_floating_window()
  nnoremap <silent> <Leader>zf :call vimrc#zoom#float()<CR>
  xnoremap <silent> <Leader>zf :<C-U>call vimrc#zoom#float_selected(vimrc#utility#get_visual_selection())<CR>
  nnoremap <silent> <Leader>zF :call vimrc#zoom#into_float()<CR>
endif

" Float
if has('nvim') && vimrc#plugin#check#has_floating_window()
  command! -bang -nargs=?                   VimrcFloatToggle call vimrc#float#toggle(<q-args>, <bang>0)
  command! -bang -nargs=? -complete=command VimrcFloatNew    call vimrc#float#new(<q-args>, <bang>0)
  command!                                  VimrcFloatPrev   call vimrc#float#prev()
  command!                                  VimrcFloatNext   call vimrc#float#next()
  command!                                  VimrcFloatRemove call vimrc#float#remove()
  " TODO: Use floaterm & g:floaterm_autoclose = v:false for non-interactive
  " terminal command
  command! -bang -nargs=? -complete=command VimrcFloatermNew call vimrc#float#new('TermOpen '.<q-args>, <bang>0)

  nnoremap <silent> <M-,><M-l> :VimrcFloatToggle<CR>
  inoremap <silent> <M-,><M-l> <Esc>:VimrcFloatToggle<CR>
  nnoremap <silent> <M-,><M-n> :execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>
  nnoremap <silent> <M-,><M-m> :execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>
  nnoremap <silent> <M-,><M-j> :VimrcFloatPrev<CR>
  nnoremap <silent> <M-,><M-k> :VimrcFloatNext<CR>
  nnoremap <silent> <M-,><M-r> :VimrcFloatRemove<CR>
  nnoremap <silent> <M-,><M-x> :execute 'VimrcFloatermNew '.input('command: ', '', 'shellcmd')<CR>
  nnoremap <silent> <M-,><M-c> :execute 'VimrcFloatermNew! '.input('command: ', '', 'shellcmd')<CR>

  " terminal key mappings
  tnoremap <silent> <M-q><M-,><M-l> <C-\><C-N>:VimrcFloatToggle<CR>
  tnoremap <silent> <M-q><M-,><M-n> <C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>
  tnoremap <silent> <M-q><M-,><M-m> <C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>
  tnoremap <silent> <M-q><M-,><M-j> <C-\><C-N>:VimrcFloatPrev<CR>
  tnoremap <silent> <M-q><M-,><M-k> <C-\><C-N>:VimrcFloatNext<CR>
  tnoremap <silent> <M-q><M-,><M-r> <C-\><C-N>:VimrcFloatRemove<CR>

  tnoremap <silent> <M-q><M-,><M-l> <C-\><C-N>:VimrcFloatToggle<CR>
  tnoremap <silent> <M-q><M-,><M-n> <C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>
  tnoremap <silent> <M-q><M-,><M-m> <C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>
  tnoremap <silent> <M-q><M-,><M-j> <C-\><C-N>:VimrcFloatPrev<CR>
  tnoremap <silent> <M-q><M-,><M-k> <C-\><C-N>:VimrcFloatNext<CR>
  tnoremap <silent> <M-q><M-,><M-r> <C-\><C-N>:VimrcFloatRemove<CR>

  " TODO For nested neovim
  " Need to implement different prefix_count for diferrent key mappings in
  " nested_neovim.vim
endif

