nnoremap <F4> :LuaTreeToggle<CR>
nnoremap <Space><F4> :LuaTreeFindFile<CR>

nmap <silent><expr> - "\<Plug>VinegarUp".":LuaTreeFindFile\<CR>\<C-O>"

augroup nvim_tree_lua_mappings
  autocmd!
  autocmd FileType LuaTree call vimrc#nvim_tree_lua#mappings()
augroup END
