" Use deoplete.
let g:deoplete#enable_at_startup = 1

" TODO Detect clang version
" deoplete_clang
let g:deoplete#sources#clang#libclang_path = vimrc#plugin#check#detect_clang_dir('/lib/libclang.so.1')
let g:deoplete#sources#clang#clang_header = vimrc#plugin#check#detect_clang_dir('/lib/clang')

" clang_complete
" let g:clang_library_path = vimrc#plugin#check#detect_clang_dir('/lib/libclang.so.1')
"
" let g:clang_debug = 1
" let g:clang_use_library = 1
" let g:clang_complete_auto = 0
" let g:clang_auto_select = 0
" let g:clang_omnicppcomplete_compliance = 0
" let g:clang_make_default_keymappings = 0

" deoplete_rust
let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = '/code/rust/src'

" LanguageClient-neovim
" let g:LanguageClient_serverCommands = {
"     \ 'c': ['cquery', '--language-server'],
"     \ 'cpp': ['cquery', '--language-server'],
"     \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
"     \ }
" let g:LanguageClient_loadSettings = 1
" let g:LanguageClient_settingsPath = vimrc#get_vimhome()."/settings.json"

" deoplete-ternjs
let g:deoplete#sources#ternjs#tern_bin = vimrc#get_vim_plug_dir().'/tern_for_vim/node_modules/tern/bin/tern'

" float-preview.nvim
if has('nvim')
  set completeopt-=preview

  let g:float_preview#docked = 0
endif

" TODO Set python & python3 for jedi

" <Tab>: completion.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ vimrc#insert#check_back_space() ? "\<Tab>" :
      \ deoplete#manual_complete()

" <S-Tab>: completion back.
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

" <C-H>, <BS>: close popup and delete backword char.
inoremap <expr><C-H> deoplete#smart_close_popup()."\<C-H>"
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-H>"

inoremap <expr><C-G><C-G> deoplete#refresh()
inoremap <silent><expr><C-L> deoplete#complete_common_string()
