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

nnoremap QQ :call vimrc#utility#quit_tab()<CR>
nnoremap g4 :tablast<CR>
" }}}

" Quickly adjust window size
nnoremap <C-W><Space>- <C-W>10-
nnoremap <C-W><Space>+ <C-W>10+
nnoremap <C-W><Space>< <C-W>10<
nnoremap <C-W><Space>> <C-W>10>
nnoremap <C-W><Space>= :call vimrc#utility#window_equal()<CR>
nnoremap <C-W><Space>x <C-W>_<C-W><Bar>

" Move tab
nnoremap <Leader>t< :tabmove -1<CR>
nnoremap <Leader>t> :tabmove +1<CR>

" Create new line in insert mode
inoremap <M-o> <C-O>o
inoremap <M-S-o> <C-O>O

" Go to matched bracket in insert mode
imap <M-5> <C-O>%

" Go to WORD end in insert mode
inoremap <M-E> <Esc>Ea

" Create new line without indent & prefix
nnoremap <M-o> o <C-U>
nnoremap <M-S-o> O <C-U>

" Save
nnoremap <C-S>        :update<CR>
nnoremap <Space><C-S> :wall<CR>

" Quit
nnoremap <Space>q :quit<CR>
nnoremap <Space>Q :qall!<CR>

" Quick execute
if vimrc#plugin#check#get_os() =~# 'windows'
  " Win32
  nnoremap <Leader>xx :call vimrc#windows#execute_current_file()<CR>
  nnoremap <Leader>X :call vimrc#windows#open_terminal_in_current_file_folder()<CR>
  nnoremap <Leader>E :call vimrc#windows#reveal_current_file_folder_in_explorer()<CR>
else
  " Linux
  if executable('xdg-open')
    nnoremap <Leader>xx :execute vimrc#utility#get_xdg_open() . ' ' . "%:p"<CR>
  endif
endif

" Easier file status
nnoremap <Space><C-G> 2<C-G>

" Change current window working directory to parent folder
nnoremap <Leader>du :lcd ..<CR>

" Change current window working directory to folder containing current buffer
nnoremap <Leader>dh :lcd %:h<CR>

" Horizontally scroll to center of window, like horizontal 'zz'
nnoremap zc zszH

" Operator mapping for current word
onoremap x iw
onoremap X iW

" Quick yank cursor word
" TODO This overrides jump to mark
nnoremap y' ""yiw
nnoremap y" ""yiW
nnoremap y= "+yiw
nnoremap y+ "+yiW

" Quick yank/paste to/from system clipboard
" TODO This overrides jump to mark
nnoremap =y "+y
xnoremap =y "+y
nnoremap +p "+p
xnoremap +p "+p
nnoremap +P "+P
xnoremap +P "+P
" TODO Previous key mappings not work in vimwiki as it use '=' & '+'
nmap     <p "+[p
nmap     >p "+]p

" Quick yank filename
nnoremap <Leader>y5 :let @" = expand('%:t:r')<CR>
nnoremap <Leader>y% :let @" = @%<CR>
nnoremap <Leader>y4 :let @" = expand('%:p')<CR>

" Quick yank current directory
nnoremap <Leader>yd :let @" = getcwd()<CR>

" Quick split
nnoremap <Leader>yt :tab split<CR>
nnoremap <Leader>ys :split<CR>
nnoremap <Leader>yv :vertical split<CR>

" Copy unnamed register to system clipboard
nnoremap <Space>sr :let @+ = @"<CR>
nnoremap <Space>sR :let @" = @+<CR>

" Trim system clipboard to 7 chars (for git commit sha)
nnoremap <Space>s7 :let @+ = @+[0:6]<CR>

" Command line & Insert mode mapping
cnoremap <C-G><C-G> <C-G>
inoremap <C-G><C-G> <C-G>
cnoremap <expr> <C-G><C-F> vimrc#fzf#files_in_commandline()
inoremap <expr> <C-G><C-F> vimrc#fzf#files_in_commandline()
" <BS> and <C-H> are the same key
cnoremap <expr> <C-G><BS>  vimrc#fzf#mru#mru_in_commandline()
inoremap <expr> <C-G><BS>  vimrc#fzf#mru#mru_in_commandline()
cnoremap <expr> <C-G><C-M> vimrc#fzf#mru#directory_mru_in_commandline()
inoremap <expr> <C-G><C-M> vimrc#fzf#mru#directory_mru_in_commandline()
cnoremap <expr> <C-G><C-T> vimrc#rg#current_type_option()
inoremap <expr> <C-G><C-T> vimrc#rg#current_type_option()
" <C-]> and <C-%> are the same key
cnoremap <expr> <C-G><C-]> expand('%:t:r')
inoremap <expr> <C-G><C-]> expand('%:t:r')
" <C-\> and <C-$> are the same key
cnoremap <expr> <C-G><C-\> expand('%:p')
inoremap <expr> <C-G><C-\> expand('%:p')
" Expand buffer folder
cnoremap <expr> <C-G><C-R> expand('%:h')
inoremap <expr> <C-G><C-R> expand('%:h')
" For grepping word
cnoremap <expr> <C-G><C-W> "\\b" . expand('<cword>') . "\\b"
cnoremap <expr> <C-G><C-A> "\\b" . expand('<cWORD>') . "\\b"
cnoremap <expr> <C-G>b     "\<C-B>\\b\<C-E>\\b"
" Fugitive commit sha
cnoremap <expr> <C-G><C-Y> vimrc#fugitive#commit_sha()
inoremap <expr> <C-G><C-Y> vimrc#fugitive#commit_sha()
" Fill commit
cnoremap <expr> <C-G><C-I> vimrc#fzf#git#commits_in_commandline(0, [])
inoremap <expr> <C-G><C-I> vimrc#fzf#git#commits_in_commandline(0, [])
" FIXME: Currently, use bcommits command with fzf-tmux will cause error
" Vim(let):E684: list index out of range: 1
" cnoremap <expr> <C-G><C-O> vimrc#fzf#git#commits_in_commandline(1, [])
" inoremap <expr> <C-G><C-O> vimrc#fzf#git#commits_in_commandline(1, [])
" Fill branches
cnoremap <expr> <C-G><C-B> vimrc#fzf#git#branches_in_commandline()
inoremap <expr> <C-G><C-B> vimrc#fzf#git#branches_in_commandline()
" Fill git email
cnoremap <expr> <C-G><C-E> vimrc#git#get_email()
inoremap <expr> <C-G><C-E> vimrc#git#get_email()
" Get visual selection
cnoremap <expr> <C-G><C-V> vimrc#utility#get_visual_selection()
" Trim command line content (Use <Space> to separate `<C-\>e` and function)
cnoremap <C-G>t <C-\>e<Space>vimrc#insert#trim_cmdline()<CR>
" Delete whole word (Use <Space> to separate `<C-\>e` and function)
cnoremap <C-G>w <C-\>e<Space>vimrc#insert#delete_whole_word()<CR>

" Ex mode for special buffer that map 'q' as ':quit'
nnoremap \q: q:
nnoremap \q/ q/
nnoremap \q? q?

" Execute last command
" Note: @: should execute last command, but didn't work when using
" vimrc#execute_and_save()
nnoremap <M-x><M-x> :<C-P><CR>

" Substitute visual selection
xnoremap <M-s> :s/\%V

" Find non-ASCII character
map <M-x> [Meta-x]
noremap [Meta-x] <NOP>
nnoremap <silent> [Meta-x]<M-n> /[^\x00-\x7F]<CR>:nohlsearch<CR>
xnoremap <silent> [Meta-x]<M-n> /[^\x00-\x7F]<CR>
onoremap <silent> [Meta-x]<M-n> /[^\x00-\x7F]<CR>
nnoremap <silent> [Meta-x]<M-p> ?[^\x00-\x7F]<CR>:nohlsearch<CR>
xnoremap <silent> [Meta-x]<M-p> ?[^\x00-\x7F]<CR>
onoremap <silent> [Meta-x]<M-p> ?[^\x00-\x7F]<CR>
xnoremap <silent> [Meta-x]<M-s> ?[^\x00-\x7F]<CR>lo/[^\x00-\x7F]<CR>
onoremap <silent> [Meta-x]<M-s> :<C-U>call vimrc#textobj#inner_surround_unicode()<CR>
xnoremap <silent> [Meta-x]<M-S> ?[^\x00-\x7F]<CR>o/[^\x00-\x7F]<CR>l
onoremap <silent> [Meta-x]<M-S> :<C-U>call vimrc#textobj#around_surround_unicode()<CR>

" Find character past specified character
nnoremap <silent> <M-p> :<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:true)<CR>
xnoremap <silent> <M-p> :<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:true)<CR>
onoremap <silent> <M-p> :<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:true)<CR>
nnoremap <silent> <M-P> :<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:false)<CR>
xnoremap <silent> <M-P> :<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:false)<CR>
onoremap <silent> <M-P> :<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:false)<CR>

" Man
" :Man is defined in $VIMRUNTIME/plugin/man.vim which is loaded after .vimrc
" TODO Move this to 'after' folder
if has('nvim')
  " TODO Detect goyo mode and use normal :Man
  nnoremap <Leader><F1> :Man<Space>
  if vimrc#plugin#check#has_floating_window()
    nnoremap <Leader><F2> :VimrcFloatNew! Man<Space>
  endif
endif

" sdcv
if executable('sdcv')
  nnoremap <Leader>sd :execute vimrc#utility#get_sdcv_command() . ' ' . expand('<cword>')<CR>
  xnoremap <Leader>sd :<C-U>execute vimrc#utility#get_sdcv_command() . " '" . vimrc#utility#get_visual_selection() . "'"<CR>
  nnoremap <Space>sd  :call vimrc#utility#execute_command(vimrc#utility#get_sdcv_command(), 'sdcv: ')<CR>
endif

" Quickfix & Locaiton List {{{
augroup quickfix_settings
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

command! ToggleIndent call vimrc#toggle#toggle#indent()
command! ToggleFold call vimrc#toggle#fold_method()

" LastTab
command! -count -bar LastTab call vimrc#last_tab#jump(<count>)
nnoremap <M-1> :call vimrc#last_tab#jump(v:count)<CR>

augroup last_tab_settings
  autocmd!
  autocmd TabLeave * call vimrc#last_tab#insert(tabpagenr())
  autocmd TabClosed * call vimrc#last_tab#clear_invalid()
augroup END

" Toggle parent folder tag
command! ToggleParentFolderTag call vimrc#toggle#parent_folder_tag()
nnoremap <silent> <Leader>p :ToggleParentFolderTag<CR>

" Display file size
command! -nargs=1 -complete=file FileSize call vimrc#utility#file_size(<q-args>)

" Set tab size
command! -nargs=1 SetTabSize call vimrc#utility#set_tab_size(<q-args>)

command! GetCursorSyntax echo vimrc#utility#get_cursor_syntax()

" Find the cursor
command! FindCursor call vimrc#utility#blink_cursor_location()

if executable('tmux')
  command! RefreshDisplay call vimrc#utility#refresh_display()
endif

command! ClearWinfixsize call vimrc#clear_winfixsize()
" }}}

" Custom command {{{
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if exists(':DiffOrig') != 2
  command DiffOrig call vimrc#utility#diff_original()
endif

" Delete inactive buffers
command! -bang Bdi call vimrc#utility#delete_inactive_buffers(0, <bang>0)
command! -bang Bwi call vimrc#utility#delete_inactive_buffers(1, <bang>0)
nnoremap <Leader>D :Bdi<CR>
nnoremap <Leader><C-D> :Bdi!<CR>
nnoremap <Leader>Q :Bwi<CR>
nnoremap <Leader><C-Q> :Bwi!<CR>

command! TrimWhitespace call vimrc#utility#trim_whitespace()

command! DisplayChar call vimrc#display_char()

command! ReloadVimrc call vimrc#reload#reload()

command! -nargs=1 -complete=command QuickfixOutput call vimrc#quickfix#execute(<f-args>)
nnoremap <Leader>o :execute 'QuickfixOutput '.input('output: ', '', 'command')<CR>

if vimrc#plugin#check#get_os() !~# 'windows'
  command! Args echo system("ps -o command= -p " . getpid())
endif

command! -nargs=1 -complete=file Switch call vimrc#open#switch(<q-args>, 'edit')
" }}}
