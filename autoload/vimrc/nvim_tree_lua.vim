" Mappings
function! vimrc#nvim_tree_lua#mappings() abort
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
  nnoremap <silent><buffer><nowait> \\ :call vimrc#nvim_tree_lua#change_dir(getcwd())<CR>
endfunction

" Utilities
function! vimrc#nvim_tree_lua#get_node() abort
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

function! vimrc#nvim_tree_lua#get_path() abort
lua << EOF
  local state = require 'lib/state'
  local tree = state.get_tree()
  local node = tree[1]

  vim.api.nvim_buf_set_var(0, 'nvim_tree_path', node.path)
EOF

  return nvim_buf_get_var(0, 'nvim_tree_path')
endfunction

function! vimrc#nvim_tree_lua#change_dir(dir) abort
  call nvim_buf_set_var(0, 'nvim_tree_dir', a:dir)

lua << EOF
  local state = require 'lib/state'
  local winutils = require 'lib/winutils'

  state.set_root_path(vim.api.nvim_buf_get_var(0, 'nvim_tree_dir'))
  state.init_tree()
  winutils.update_view()
EOF
endfunction

function! vimrc#nvim_tree_lua#open() abort
lua << EOF
  local state = require 'lib/state'
  local winutils = require 'lib/winutils'

  state.init_tree()
  if winutils.is_win_open() == false then
    winutils.open()
    winutils.update_view()
    winutils.set_mappings()
  end
EOF
endfunction

" Functions
function! vimrc#nvim_tree_lua#fzf_files() abort
  let path = vimrc#nvim_tree_lua#get_path()

  call fzf#vim#files(path, fzf#vim#with_preview(), 0)
endfunction

function! vimrc#nvim_tree_lua#fzf_rg() abort
  let path = vimrc#nvim_tree_lua#get_path()

  execute 'RgWithOption '.path.'::'.input('Rg: ')
endfunction

function! vimrc#nvim_tree_lua#opendir() abort
  if expand('%') =~# '^$\|^term:[\/][\/]'
    let dir = '.'
  else
    let dir = expand('%:h')
  endif

  call vimrc#nvim_tree_lua#open()
  call vimrc#nvim_tree_lua#change_dir(dir)
endfunction

function! vimrc#nvim_tree_lua#up() abort
  let path = vimrc#nvim_tree_lua#get_path()
  let parent_path = simplify(path.'/..')
  call vimrc#nvim_tree_lua#change_dir(parent_path)
endfunction

function! vimrc#nvim_tree_lua#detect_folder(path) abort
  if a:path !=# '' && isdirectory(a:path)
    " Check for netrw pin
    if !vimrc#netrw#check_pin()
      execute "normal! \<C-O>"
      call vimrc#nvim_tree_lua#open()
      call vimrc#nvim_tree_lua#change_dir(a:path)
    endif
  endif
endfunction
