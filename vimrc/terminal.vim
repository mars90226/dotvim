" neovim terminal key mapping and settings {{{
" Set terminal buffer size to unlimited
set scrollback=100000

command! -nargs=* TermOpen call vimrc#terminal#open_current_folder('edit', <q-args>)

" For quick terminal access
nnoremap <silent> <Leader>tr :call vimrc#terminal#open_current_shell('edit')<CR>
nnoremap <silent> <Leader>tt :call vimrc#terminal#open_current_shell('tabnew')<CR>
nnoremap <silent> <Leader>ts :call vimrc#terminal#open_current_shell('new')<CR>
nnoremap <silent> <Leader>tv :call vimrc#terminal#open_current_shell('vnew')<CR>
nnoremap <silent> <Leader>tb :call vimrc#terminal#open_current_shell('rightbelow vnew')<CR>
nnoremap <silent> <Leader>td :call vimrc#terminal#open_shell('new', input('Folder: ', '', 'dir'))<CR>
nnoremap <silent> <Leader>tD :call vimrc#terminal#open_shell('tabnew', input('Folder: ', '', 'dir'))<CR>

" Quick terminal function
tnoremap <M-F1> <C-\><C-N>
tnoremap <M-F2> <C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>
tnoremap <M-F3> <C-\><C-N>:Windows<CR>

" Quickly switch window in terminal
tnoremap <M-S-h> <C-\><C-N><C-W>h
tnoremap <M-S-j> <C-\><C-N><C-W>j
tnoremap <M-S-k> <C-\><C-N><C-W>k
tnoremap <M-S-l> <C-\><C-N><C-W>l

" Quickly switch tab in terminal
tnoremap <M-C-J> <C-\><C-N>gT
tnoremap <M-C-K> <C-\><C-N>gt

" Quickly switch to last tab in terminal
tnoremap <M-1> <C-\><C-N>:LastTab<CR>

" Quickly paste from register
tnoremap <M-r>      <C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>
tnoremap <M-r><M-r> <M-r>

" Quickly suspend neovim
tnoremap <M-C-Z> <C-\><C-N>:suspend<CR>

" Quickly page-up/page-down
tnoremap <M-PageUp>   <C-\><C-N><PageUp>
tnoremap <M-PageDown> <C-\><C-N><PageDown>

" Search pattern
tnoremap <M-s><C-F> <C-\><C-N>:call vimrc#search#search_file(0)<CR>
tnoremap <M-s><C-Y> <C-\><C-N>:call vimrc#search#search_hash(0)<CR>
tnoremap <M-s><C-U> <C-\><C-N>:call vimrc#search#search_url(0)<CR>
tnoremap <M-s><C-I> <C-\><C-N>:call vimrc#search#search_ip(0)<CR>
tnoremap <M-s><M-s> <M-s>

" Fuzzymenu
tnoremap <M-m><M-m> <C-\><C-N>:call fuzzymenu#Run({})<CR>

" For nested neovim {{{
  " Use <M-q> as prefix

  " Quick terminal function
  tnoremap <M-q>1 <C-\><C-\><C-N>
  tnoremap <M-q>2 <C-\><C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>
  tnoremap <M-q>3 <C-\><C-\><C-N>:Windows<CR>

  " Quickly switch window in terminal
  tnoremap <M-q><M-h> <C-\><C-\><C-N><C-W>h
  tnoremap <M-q><M-j> <C-\><C-\><C-N><C-W>j
  tnoremap <M-q><M-k> <C-\><C-\><C-N><C-W>k
  tnoremap <M-q><M-l> <C-\><C-\><C-N><C-W>l

  " Quickly switch tab in terminal
  tnoremap <M-q><C-J> <C-\><C-\><C-N>gT
  tnoremap <M-q><C-K> <C-\><C-\><C-N>gt

  " Quickly switch to last tab in terminal
  tnoremap <M-q><M-1> <C-\><C-\><C-N>:LastTab<CR>

  " Quickly paste from register
  tnoremap <M-q><M-r> <C-\><C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>

  " Quickly suspend neovim
  tnoremap <M-q><C-Z> <C-\><C-\><C-N>:suspend<CR>

  " Quickly page-up/page-down
  tnoremap <M-q><PageUp>   <C-\><C-\><C-N><PageUp>
  tnoremap <M-q><PageDown> <C-\><C-\><C-N><PageDown>

  " Search pattern
  tnoremap <M-q><C-F> <C-\><C-\><C-N>:call vimrc#search#search_file(0)<CR>
  tnoremap <M-q><C-Y> <C-\><C-\><C-N>:call vimrc#search#search_hash(0)<CR>
  tnoremap <M-q><C-U> <C-\><C-\><C-N>:call vimrc#search#search_url(0)<CR>
  tnoremap <M-q><C-I> <C-\><C-\><C-N>:call vimrc#search#search_ip(0)<CR>

  " Fuzzymenu
  tnoremap <M-q><M-m> <C-\><C-\><C-N>:call fuzzymenu#Run({})<CR>

  " For nested nested neovim {{{
    tnoremap <silent> <expr> <M-q><M-q> vimrc#terminal#nested_neovim#start("\<M-q>", 2)

    " Quick terminal function
    call vimrc#terminal#nested_neovim#register('1', '')
    call vimrc#terminal#nested_neovim#register('2', ":call vimrc#terminal#open_current_shell('tabnew')\<CR>")
    call vimrc#terminal#nested_neovim#register('3', ":Windows\<CR>")

    " Quickly switch window in terminal
    call vimrc#terminal#nested_neovim#register("\<M-h>", "\<C-W>h")
    call vimrc#terminal#nested_neovim#register("\<M-j>", "\<C-W>j")
    call vimrc#terminal#nested_neovim#register("\<M-k>", "\<C-W>k")
    call vimrc#terminal#nested_neovim#register("\<M-l>", "\<C-W>l")

    " Quickly switch tab in terminal
    call vimrc#terminal#nested_neovim#register("\<C-J>", 'gT')
    call vimrc#terminal#nested_neovim#register("\<C-K>", 'gt')

    " Quickly switch to last tab in terminal
    call vimrc#terminal#nested_neovim#register("\<M-1>", ":LastTab\<CR>")

    " Quickly paste from register
    call vimrc#terminal#nested_neovim#register("\<M-r>", ":execute 'normal! \"'.v:lua.require('vimrc.utils').get_char_string().'pi'\<CR>")

    " Quickly suspend neovim
    call vimrc#terminal#nested_neovim#register("\<C-Z>", ":suspend\<CR>")

    " Quickly page-up/page-down
    call vimrc#terminal#nested_neovim#register("\<PageUp>", "\<PageUp>")
    call vimrc#terminal#nested_neovim#register("\<PageDown>", "\<PageDown>")

    " Search pattern
    call vimrc#terminal#nested_neovim#register("\<C-F>", ":call vimrc#search#search_file(0)\<CR>")
    call vimrc#terminal#nested_neovim#register("\<C-Y>", ":call vimrc#search#search_hash(0)\<CR>")
    call vimrc#terminal#nested_neovim#register("\<C-U>", ":call vimrc#search#search_url(0)\<CR>")
    call vimrc#terminal#nested_neovim#register("\<C-I>", ":call vimrc#search#search_ip(0)\<CR>")

    " Fuzzymenu
    call vimrc#terminal#nested_neovim#register("\<M-m><M-m>", ":call fuzzymenu#Run({})\<CR>")
  " }}}
" }}}

augroup terminal_settings
  autocmd!
  autocmd TermOpen * call vimrc#terminal#settings()
  autocmd TermOpen * call vimrc#terminal#mappings()

  " TODO Start insert mode when cancelling :Windows in terminal mode or
  " selecting another terminal buffer
  autocmd BufWinEnter,WinEnter term://* if &buftype ==# 'terminal' | startinsert | endif
  autocmd BufLeave             term://* if &buftype ==# 'terminal' | stopinsert  | endif

  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf
  autocmd TermClose term://* call vimrc#terminal#close_result_buffer(expand('<afile>'))
augroup END
" }}}
