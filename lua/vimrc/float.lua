local float = {}

float.setup = function()
  -- TODO: Move these config to other place
  -- Zoom {{{
  nnoremap("<Leader>zz", [[:call vimrc#zoom#zoom()<CR>]], "silent")
  xnoremap("<Leader>zz", [[:<C-U>call vimrc#zoom#selected(vimrc#utility#get_visual_selection())<CR>]], "silent")

  nnoremap("<Leader>zf", [[:call vimrc#zoom#float()<CR>]], "silent")
  xnoremap("<Leader>zf", [[:<C-U>call vimrc#zoom#float_selected(vimrc#utility#get_visual_selection())<CR>]], "silent")
  nnoremap("<Leader>zF", [[:call vimrc#zoom#into_float()<CR>]], "silent")
  -- }}}

  -- Float {{{
  vim.cmd([[command! -bang -nargs=?                   VimrcFloatToggle call vimrc#float#toggle(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=? -complete=command VimrcFloatNew    call vimrc#float#new(<q-args>, <bang>0)]])
  vim.cmd([[command!                                  VimrcFloatPrev   call vimrc#float#prev()]])
  vim.cmd([[command!                                  VimrcFloatNext   call vimrc#float#next()]])
  vim.cmd([[command!                                  VimrcFloatRemove call vimrc#float#remove()]])
  -- TODO: Use floaterm & g:floaterm_autoclose = v:false for non-interactive
  -- terminal command
  vim.cmd([[command! -bang -nargs=? -complete=command VimrcFloatermNew call vimrc#float#new('TermOpen '.<q-args>, <bang>0)]])

  nnoremap("<M-,><M-l>", [[:VimrcFloatToggle<CR>]], "silent")
  inoremap("<M-,><M-l>", [[<Esc>:VimrcFloatToggle<CR>]], "silent")
  nnoremap("<M-,><M-n>", [[:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]], "silent")
  nnoremap("<M-,><M-m>", [[:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]], "silent")
  nnoremap("<M-,><M-j>", [[:VimrcFloatPrev<CR>]], "silent")
  nnoremap("<M-,><M-k>", [[:VimrcFloatNext<CR>]], "silent")
  nnoremap("<M-,><M-r>", [[:VimrcFloatRemove<CR>]], "silent")
  nnoremap("<M-,><M-x>", [[:execute 'VimrcFloatermNew '.input('command: ', '', 'shellcmd')<CR>]], "silent")
  nnoremap("<M-,><M-c>", [[:execute 'VimrcFloatermNew! '.input('command: ', '', 'shellcmd')<CR>]], "silent")

  -- terminal key mappings
  tnoremap("<M-q><M-,><M-l>", [[<C-\><C-N>:VimrcFloatToggle<CR>]], "silent")
  tnoremap("<M-q><M-,><M-n>", [[<C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]], "silent")
  tnoremap("<M-q><M-,><M-m>", [[<C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]], "silent")
  tnoremap("<M-q><M-,><M-j>", [[<C-\><C-N>:VimrcFloatPrev<CR>]], "silent")
  tnoremap("<M-q><M-,><M-k>", [[<C-\><C-N>:VimrcFloatNext<CR>]], "silent")
  tnoremap("<M-q><M-,><M-r>", [[<C-\><C-N>:VimrcFloatRemove<CR>]], "silent")

  tnoremap("<M-q><M-,><M-l>", [[<C-\><C-N>:VimrcFloatToggle<CR>]], "silent")
  tnoremap("<M-q><M-,><M-n>", [[<C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]], "silent")
  tnoremap("<M-q><M-,><M-m>", [[<C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]], "silent")
  tnoremap("<M-q><M-,><M-j>", [[<C-\><C-N>:VimrcFloatPrev<CR>]], "silent")
  tnoremap("<M-q><M-,><M-k>", [[<C-\><C-N>:VimrcFloatNext<CR>]], "silent")
  tnoremap("<M-q><M-,><M-r>", [[<C-\><C-N>:VimrcFloatRemove<CR>]], "silent")

  -- TODO For nested neovim
  -- Need to implement different prefix_count for diferrent key mappings in
  -- nested_neovim.vim
  -- }}}
end

return float
