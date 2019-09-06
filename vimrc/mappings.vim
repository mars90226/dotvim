" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" CTRL-L clear hlsearch
nnoremap <C-L> <C-L>:nohlsearch<CR>:call vimrc#clear_and_redraw()<CR>

" Add key mapping for suspend
nnoremap <Space><C-Z> :suspend<CR>

" Quickly switch window {{{
nnoremap <M-h> <C-W>h
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-l> <C-W>l

" Move in insert mode
inoremap <M-h> <Left>
inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-l> <Right>
" }}}

" Saner command-line history {{{
cnoremap <M-n> <Down>
cnoremap <M-p> <Up>
" }}}

" Tab key mapping {{{
" Quickly switch tab
nnoremap <C-J> gT
nnoremap <C-K> gt

nnoremap QQ :call <SID>QuitTab()<CR>
nnoremap g4 :tablast<CR>
function! s:QuitTab()
  try
    tabclose
  catch /E784/ " Can't close last tab
    qall
  endtry
endfunction
" }}}

" Quickly adjust window size
nnoremap <C-W><Space>- <C-W>10-
nnoremap <C-W><Space>+ <C-W>10+
nnoremap <C-W><Space>< <C-W>10<
nnoremap <C-W><Space>> <C-W>10>
nnoremap <C-W><Space>= :call <SID>window_equal()<CR>
function! s:window_equal()
  windo setlocal nowinfixheight nowinfixwidth
  wincmd =
endfunction

" Move tab
nnoremap <Leader>t< :tabmove -1<CR>
nnoremap <Leader>t> :tabmove +1<CR>

" Create new line in insert mode
inoremap <M-o> <C-O>o
inoremap <M-S-o> <C-O>O

" Go to matched bracket in insert mode
imap <M-5> <C-O>%

" Create new line without indent & prefix
nnoremap <M-o> o <C-U>
nnoremap <M-S-o> O <C-U>

" Save
nnoremap <C-S> :update<CR>

" Quit
nnoremap <Space>q :q<CR>
nnoremap <Space>Q :qa!<CR>

" Quick execute
if vimrc#plugin#check#get_os() =~ "windows"
  " Win32
  "nnoremap <Leader>x :execute ':! "'.expand('%').'"'<CR>
  nnoremap <Leader>x :!start cmd /c "%:p"<CR>
  nnoremap <Leader>X :!start cmd /K cd /D %:p:h<CR>
  nnoremap <Leader>E :execute '!start explorer "' . expand("%:p:h:gs?\\??:gs?/?\\?") . '"'<CR>
else
  " Linux
  nnoremap <Leader>x :!xdg-open "%:p"<CR>

  if has('nvim')
    nnoremap <Leader>x :terminal xdg-open "%:p"<CR>
  endif
endif

" Easier file status
nnoremap <Space><C-G> 2<C-G>

" Move working directory up
nnoremap <Leader>u :cd ..<CR>

" Move working directory to current buffer's parent folder
nnoremap <Leader>cb :cd %:h<CR>

" Quick yank cursor word
nnoremap y' ""yiw
nnoremap y" ""yiW
nnoremap y= "+yiw
nnoremap y+ "+yiW

" Quick yank/paste to/from system clipboard
nnoremap =y "+y
xnoremap =y "+y
nnoremap +p "+p
xnoremap +p "+p
nnoremap +P "+P
xnoremap +P "+P
nnoremap +[p "+[p
nnoremap +]p "+]p

" Quick yank filename
nnoremap <Leader>y5 :let @" = expand('%:t:r')<CR>
nnoremap <Leader>y% :let @" = @%<CR>
nnoremap <Leader>y4 :let @" = expand('%:p')<CR>

" Quick split
nnoremap <Leader>yt :tab split<CR>
nnoremap <Leader>ys :split<CR>
nnoremap <Leader>yv :vertical split<CR>

" Copy unnamed register to system clipboard
nnoremap <Space>sr :let @+ = @"<CR>

" Command line mapping
cnoremap <expr> <C-G><C-F> vimrc#fzf#files_in_commandline()
cnoremap <expr> <C-G><C-T> vimrc#rg_current_type_option()
" <C-]> and <C-%> is the same key
cnoremap <expr> <C-G><C-]> expand('%:t:r')
" <C-\> and <C-$> is the same key
cnoremap <expr> <C-G><C-\> expand('%:p')
" For grepping word
cnoremap <expr> <C-G><C-W> "\\b" . expand('<cword>') . "\\b"
cnoremap <expr> <C-G><C-A> "\\b" . expand('<cWORD>') . "\\b"
" Fugitive commit sha
cnoremap <expr> <C-G><C-Y> vimrc#fugitive#commit_sha()

" Ex mode for special buffer that map 'q' as ':quit'
nnoremap \q: q:
nnoremap \q/ q/
nnoremap \q? q?

" s:execute_command() for executing command with query
" TODO input completion
function! s:execute_command(command, prompt)
  let query = input(a:prompt)
  if query != ''
    execute a:command . ' ' . query
  else
    echomsg 'Cancelled!'
  endif
endfunction

" Man
" :Man is defined in $VIMRUNTIME/plugin/man.vim which is loaded after .vimrc
" TODO Move this to 'after' folder
if has('nvim')
  nnoremap <Leader><F1> :Man 
endif

" sdcv
if executable('sdcv')
  nnoremap <Leader>sd :execute '!sdcv ' . expand('<cword>')<CR>
  nnoremap <Space>sd :call <SID>execute_command('!sdcv', 'sdcv: ')<CR>
endif

" Quickfix & Locaiton List {{{
augroup quickfixSettings
  autocmd!
  autocmd FileType qf call vimrc#quickfix#mappings()
augroup END
" }}}

" Custom function {{{
" This cannot be moved to autoload, because sid will change when <sfile> change
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'),
        \ '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
let g:sid = s:SID_PREFIX()

command! ToggleIndent call vimrc#toggle_indent()
command! ToggleFold call vimrc#toggle_fold()

" LastTab
command! -count -bar LastTab call vimrc#last_tab(<count>)
nnoremap <M-1> :call vimrc#last_tab(v:count)<CR>

augroup last_tab_settings
  autocmd!
  autocmd TabLeave * call vimrc#insert_last_tab(tabpagenr())
augroup END

" Zoom
nnoremap <silent> <Leader>z :call vimrc#zoom()<CR>
xnoremap <silent> <Leader>z :<C-U>call vimrc#zoom_selected(vimrc#get_visual_selection())<CR>

" Toggle parent folder tag
command! ToggleParentFolderTag call vimrc#toggle_parent_folder_tag()
nnoremap <silent> <Leader>p :ToggleParentFolderTag<CR>

" Display file size
command! -nargs=1 -complete=file FileSize call vimrc#file_size(<q-args>)

" Set tab size
command! -nargs=1 SetTabSize call vimrc#set_tab_size(<q-args>)

command! GetCursorSyntax echo vimrc#get_cursor_syntax()

" Find the cursor
command! FindCursor call vimrc#blink_cursor_location()

if executable('tmux')
  command! RefreshDisplay call vimrc#refresh_display()
endif
" }}}

" Custom command {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" Delete inactive buffers
command! -bang Bdi call vimrc#delete_inactive_buffers(0, <bang>0)
command! -bang Bwi call vimrc#delete_inactive_buffers(1, <bang>0)
nnoremap <Leader>D :Bdi<CR>
nnoremap <Leader><C-D> :Bdi!<CR>
nnoremap <Leader>Q :Bwi<CR>
nnoremap <Leader><C-Q> :Bwi!<CR>

command! TrimWhitespace call vimrc#trim_whitespace()

command! GetChar call vimrc#getchar()

command! ReloadVimrc call vimrc#reload#reload()

if vimrc#plugin#check#get_os() !~ "windows"
  command! Args echo system("ps -o command= -p " . getpid())
endif
" }}}
