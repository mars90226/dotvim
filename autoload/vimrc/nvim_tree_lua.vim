" Mappings
function! vimrc#nvim_tree_lua#mappings()
  nnoremap <silent><buffer> R :LuaTreeRefresh<CR>
  nnoremap <silent><buffer> q :LuaTreeToggle<CR>

  nnoremap <silent><buffer> h :call vimrc#nvim_tree_lua#up()<CR>
  nnoremap <silent><buffer> l :lua require"tree".open_file("chdir")<CR>

  nnoremap <silent><buffer> \f :call vimrc#nvim_tree_lua#fzf_files()<CR>
  nnoremap <silent><buffer> \r :call vimrc#nvim_tree_lua#fzf_rg()<CR>
  nnoremap <silent><buffer> cv :call vimrc#nvim_tree_lua#change_dir(expand(input('cd: ', '', 'dir')))<CR>
  nnoremap <silent><buffer> gv :call vimrc#nvim_tree_lua#change_dir($VIMRUNTIME)<CR>
  nnoremap <silent><buffer> gl :call vimrc#nvim_tree_lua#change_dir('/usr/lib')<CR>
  nnoremap <silent><buffer> gr :call vimrc#nvim_tree_lua#change_dir('/')<CR>
  nnoremap <silent><buffer> \\ :call vimrc#nvim_tree_lua#change_dir(getcwd())<CR>
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

function! vimrc#nvim_tree_lua#change_dir(dir)
  call nvim_buf_set_var(0, 'nvim_tree_dir', a:dir)

lua << EOF
  local state = require 'lib/state'
  local winutils = require 'lib/winutils'

  state.set_root_path(vim.api.nvim_buf_get_var(0, 'nvim_tree_dir'))
  state.init_tree()
  winutils.update_view()
EOF
endfunction

function! vimrc#nvim_tree_lua#open()
lua << EOF
  local winutils = require 'lib/winutils'

  winutils.open()
  winutils.update_view()
  winutils.set_mappings()
EOF
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

function! vimrc#nvim_tree_lua#opendir()
  if expand('%') =~# '^$\|^term:[\/][\/]'
    let dir = '.'
  else
    let dir = expand('%:h')
  endif

  call vimrc#nvim_tree_lua#open()
  call vimrc#nvim_tree_lua#change_dir(dir)
endfunction

function! vimrc#nvim_tree_lua#up()
  let path = vimrc#nvim_tree_lua#get_path()
  let parent_path = simplify(path.'/..')
  call vimrc#nvim_tree_lua#change_dir(parent_path)
endfunction
