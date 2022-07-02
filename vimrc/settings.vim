" Script Encoding: UTF-8
scriptencoding utf-8

" Vim basic setting {{{
" source mswin.vim
if vimrc#plugin#check#get_os() !~# 'synology'
  source $VIMRUNTIME/mswin.vim
  behave xterm

  if has('gui')
    " Fix CTRL-F in gui will popup find window problem
    silent! unmap <C-F>
    silent! iunmap <C-F>
    silent! cunmap <C-F>
  endif

  " Unmap CTRL-A for selecting all
  silent! unmap <C-A>
  silent! iunmap <C-A>
  silent! cunmap <C-A>

  " Unmap CTRL-Z for undo
  silent! unmap <C-Z>
  silent! iunmap <C-Z>

  " Unmap CTRL-Z for redo
  silent! unmap <C-Y>
  silent! iunmap <C-Y>
endif
" }}}

set number
set hidden
set lazyredraw
set mouse=a
set modeline
" This config affect CursorHold event trigger time, default: 4000
" Avoid being to small to avoid multiple CursorHold event triggered when
" moving cursor fastly.
" NOTE: CursorHold updatetime is managed by FixCursorHold.nvim, so don't
" change 'updatetime'.
" set updatetime=300
set updatetime=4000
set cursorline
set ruler " show the cursor position all the time
" TODO: Remove this comment when neovim bug fixed
" Fix neovim VimResized bug: https://github.com/neovim/neovim/issues/12432
" set display-=msgsep

set scrolloff=0

set diffopt=internal,filler,vertical,closeoff,algorithm:histogram,hiddenoff

" completion menu
set pumheight=40
set pumblend=0

" ignore pattern for wildmenu
set wildmenu
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
set wildmode=full
set wildoptions=pum,tagfile

" fillchars
set fillchars=diff:⣿,fold:-,vert:│

" show hidden characters
set list
set listchars=tab:▸\ ,extends:»,precedes:«,nbsp:␣,space:⋅,eol:↴
if vimrc#get_vim_mode() =~# 'reader'
  " Don't show trailing space in reader vim mode
  set listchars+=trail:•
endif

set laststatus=2
set showcmd

" no distraction
set belloff=all

" Backup
" neovim has default folders for backup, undo, swap files
" Only move temporary files in vanilla vim
" TODO Use original backupdir and use other backupdir in Windows
let g:backupdir = $HOME.'/.local/share/nvim/backup'
if !isdirectory(g:backupdir)
  call mkdir(g:backupdir, 'p')
endif

set backup " keep a backup file (restore to previous version)
let &backupdir = g:backupdir.',.'

" Persistent Undo
set undofile

" session options
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank

" misc
set shellslash

" Complete
set dictionary=/usr/share/dict/words

" Remove '=' from isfilename to complete filename in 'options'='filename' format
" TODO Move to ftplugin setting
set isfname-==

" Indent {{{
set smarttab
set noexpandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
" Use cop instead
" set pastetoggle=<F10>
" }}}

" Search {{{
set hlsearch
set ignorecase
set incsearch
set smartcase
set inccommand=split

" For builtin 'incsearch'
cnoremap <C-J> <C-G>
cnoremap <C-K> <C-T>
" }}}
