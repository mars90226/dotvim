" Script Encoding: UTF-8
scriptencoding utf-8

" Vim basic setting {{{
" source mswin.vim
if vimrc#plugin#check#get_os() !~# 'synology'
  source $VIMRUNTIME/mswin.vim
  " TODO Fix this in Linux
  behave mswin

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
set updatetime=100 " default: 4000
set cursorline
set ruler " show the cursor position all the time
" TODO: Remove this comment when neovim bug fixed
" Fix neovim VimResized bug: https://github.com/neovim/neovim/issues/12432
" Disabled fix as vim-clap removed VimResized autocmd that trigger bug: https://github.com/liuchengxu/vim-clap/pull/593
" set display-=msgsep

set scrolloff=0

set diffopt=filler,vertical
if has('patch-8.0.1361')
  set diffopt+=hiddenoff
endif

" completion menu
set pumheight=40
if exists('&pumblend')
  set pumblend=0
endif

" ignore pattern for wildmenu
set wildmenu
set wildignore+=*.a,*.o,*.pyc,*~,*.swp,*.tmp
" wildoptions=pum added in 'NVIM v0.4.0-401-g5c836d2ef'
if has('nvim-0.4.2') || (has('nvim-0.4.0') && vimrc#plugin#check#nvim_patch_version() >= 401)
  set wildmode=full
  silent! set wildoptions+=pum
else
  set wildmode=list:longest,full
endif
set wildoptions+=tagfile

" fillchars
set fillchars=diff:⣿,fold:-,vert:│

" show hidden characters
set list
if vimrc#get_vim_mode() =~# 'reader'
  " Don't show trailing space in reader vim mode
  set listchars=tab:▸\ ,trail:\ ,extends:»,precedes:«,nbsp:␣
else
  set listchars=tab:▸\ ,trail:•,extends:»,precedes:«,nbsp:␣
endif

set laststatus=2
set showcmd

" no distraction
if has('balloon_eval')
  set noballooneval
endif
set belloff=all

" Backup
" neovim has default folders for backup, undo, swap files
" Only move temporary files in vanilla vim
" TODO Use original backupdir and use other backupdir in Windows
if has('nvim')
  let g:backupdir = $HOME.'/.local/share/nvim/backup'
else
  let g:backupdir = $HOME.'/.vimtmp'
endif
if !isdirectory(g:backupdir)
  call mkdir(g:backupdir, 'p')
endif

set backup " keep a backup file (restore to previous version)
if has('nvim')
  let &backupdir = g:backupdir.',.'
else
  execute 'set backupdir^='.g:backupdir
  set directory^=~/.vimtmp
endif

" Persistent Undo
if has('persistent_undo')
  set undofile
  if !has('nvim')
    set undodir^=~/.vimtmp
  endif
endif

" session options
set sessionoptions-=options
set sessionoptions-=folds
set sessionoptions-=blank

" misc
set shellslash
" set appropriate grep programs
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
else
  set grepprg=grep\ -nH\ $*
endif

if !has('nvim')
  set t_Co=256
endif

" Fold
set foldtext=vimrc#fold#neat_fold_text()
set foldlevelstart=99

" Complete
set dictionary=/usr/share/dict/words

" Remove '=' from isfilename to complete filename in 'options'='filename' format
" TODO Move to ftplugin setting
set isfname-==

if has('wsl') && has('nvim')
  let g:clipboard = {
        \ 'name': 'wsl_clipboard',
        \ 'copy': {
        \     '+': 'xsel -i',
        \     '*': 'xsel -i',
        \ },
        \ 'paste': {
        \     '+': 'xsel -o',
        \     '*': 'xsel -o',
        \ },
        \ 'cache_enabled': 1,
        \ }

  " Force loading clipboard
  " TODO Create issue in neovim, this should be fixed in neovim
  call provider#clipboard#Executable()
endif
