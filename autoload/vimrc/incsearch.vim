" Functions
function! vimrc#incsearch#config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzy#converter()],
  \   'modules': [incsearch#config#easymotion#module()],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

function! vimrc#incsearch#clear_auto_nohlsearch()
  " clear incsearch-nohlsearch autocmd
  silent! autocmd! incsearch-auto-nohlsearch
endfunction

function! vimrc#incsearch#clear_nohlsearch()
  nohlsearch

  call vimrc#incsearch#clear_auto_nohlsearch()
endfunction
