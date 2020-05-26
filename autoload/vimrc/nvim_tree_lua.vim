" Mappings
function! vimrc#nvim_tree_lua#mappings()
  nnoremap <silent><buffer> R :LuaTreeRefresh<CR>
  nnoremap <silent><buffer> q :LuaTreeToggle<CR>

  nnoremap <silent><buffer> \f :call vimrc#nvim_tree_lua#fzf_files()<CR>
  nnoremap <silent><buffer> \r :call vimrc#nvim_tree_lua#fzf_rg()<CR>
endfunction

" Utilities
function! vimrc#nvim_tree_lua#get_node()
lua << EOF
  local state = require 'lib/state'
  local tree = state.get_tree()
  local tree_index = vim.api.nvim_win_get_cursor(0)[1]
  local node = tree[tree_index]

  local node_path = ''
  if node.dir == true then
    node_path = node.path .. node.name .. '/'
  else
    node_path = node.path .. node.name
  end

  vim.api.nvim_buf_set_var(0, 'nvim_tree_node_path', node_path)
EOF

  return nvim_buf_get_var(0, 'nvim_tree_node_path')
endfunction

function! vimrc#nvim_tree_lua#get_path()
lua << EOF
  local state = require 'lib/state'
  local tree = state.get_tree()
  local node = tree[1]

  vim.api.nvim_buf_set_var(0, 'nvim_tree_path', node.path)
EOF

  return nvim_buf_get_var(0, 'nvim_tree_path')
endfunction

" Functions
function! vimrc#nvim_tree_lua#fzf_files()
  let path = vimrc#nvim_tree_lua#get_path()

  call fzf#vim#files(path, fzf#vim#with_preview(), 0)
endfunction

function! vimrc#nvim_tree_lua#fzf_rg()
  let path = vimrc#nvim_tree_lua#get_path()

  execute 'RgWithOption '.path.'::'.input('Rg: ')
endfunction
