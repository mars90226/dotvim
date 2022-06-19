" TODO: Rewrite in Lua
let g:lua_tree_width = 35

nnoremap <F4> :LuaTreeToggle<CR>
nnoremap <Space><F4> :LuaTreeFindFile<CR>

nnoremap - :call vimrc#nvim_tree_lua#opendir()<CR>

augroup nvim_tree_lua_mappings
  autocmd!
  autocmd FileType LuaTree call vimrc#nvim_tree_lua#mappings()
augroup END

augroup nvim_tree_lua_detect_folder
  autocmd!
  " nvim-tree.lua already disable loading netrw
  autocmd BufEnter * call vimrc#nvim_tree_lua#detect_folder(expand('<afile>'))
augroup END
