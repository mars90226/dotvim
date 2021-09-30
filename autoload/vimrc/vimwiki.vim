" Variables
let s:vimwiki_plugin_script_name = 'plugin/vimwiki.vim'

function! vimrc#vimwiki#get_vimwiki_plugin_snr() abort
  if !exists('s:vimwiki_plugin_snr')
    let s:vimwiki_plugin_snr = vimrc#utility#get_script_id(s:vimwiki_plugin_script_name)
  endif

  return s:vimwiki_plugin_snr
endfunction

" Settings
function! vimrc#vimwiki#settings() abort
  " Currently, do nothing
endfunction

" Mappings
function! vimrc#vimwiki#mappings() abort
  nnoremap <silent><buffer> <Leader>wg :VimwikiToggleListItem<CR>

  " for original vimwiki <Tab> & <S-Tab> in insert mode
  inoremap <expr><buffer> <C-X><Tab> vimwiki#tbl#kbd_tab()
  inoremap <expr><buffer> <C-X><S-Tab> vimwiki#tbl#kbd_shift_tab()

  " The following will override auto-pairs' <CR> mappings
  inoremap <silent><buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<Esc>:VimwikiReturn 1 5\<CR>"

  nnoremap <silent><buffer> <Space><F10> :VimwikiToggleFolding<CR>
endfunction

" Functions
function! vimrc#vimwiki#toggle_folding(...) abort
  if &filetype !~# 'vimwiki'
    return
  endif

  let folding = a:0 > 0 && type(a:1) == type('') ? a:1 : vimwiki#vars#get_global('folding')

  if folding =~? '^expr.*'
    call vimrc#vimwiki#manual_folding()
    echo 'set foldmethod=manual'
  else
    call vimrc#vimwiki#expr_folding()
    echo 'set foldmethod=expr'
  endif
endfunction

function! vimrc#vimwiki#manual_folding() abort
  if &filetype !~# 'vimwiki'
    return
  endif

  " Do not call vimwiki setup function as it will elinimate all folds
  call vimwiki#vars#set_global('folding', 'manual')
  setlocal foldmethod=manual
  setlocal foldexpr&
endfunction

function! vimrc#vimwiki#expr_folding() abort
  if &filetype !~# 'vimwiki'
    return
  endif

  let VimwikiSetupFunc = vimrc#utility#get_script_function(vimrc#vimwiki#get_vimwiki_plugin_snr(), 'setup_buffer_win_enter')

  call vimwiki#vars#set_global('folding', 'expr:quick')
  call VimwikiSetupFunc()
endfunction

function! vimrc#vimwiki#toggle_all_folding() abort
  let folding = vimwiki#vars#get_global('folding')
  call vimrc#utility#all_tab_win_execute({ -> vimrc#vimwiki#toggle_folding(folding) })
endfunction

function! vimrc#vimwiki#manual_all_folding() abort
  call vimrc#utility#all_tab_win_execute({ -> vimrc#vimwiki#manual_folding() })
endfunction

function! vimrc#vimwiki#expr_all_folding() abort
  let folding = vimwiki#vars#get_global('folding')
  call vimrc#utility#all_tab_win_execute({ -> vimrc#vimwiki#expr_folding() })
endfunction
