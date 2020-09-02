if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

if vimrc#plugin#check#has_linux_build_env()
  " Currently prefer deoplete-clang over clang_complete
  " Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'cpp'], 'do': 'make install' }
  Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp'] }
  " Plug 'tweekmonster/deoplete-clang2', { 'for': ['c', 'cpp'] }
endif

Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'
Plug 'sebastianmarkow/deoplete-rust', { 'for': ['rust'] }

if vimrc#plugin#check#has_jedi()
  Plug 'deoplete-plugins/deoplete-jedi'
endif

Plug 'deoplete-plugins/deoplete-zsh'

" tern_for_vim will install tern
Plug 'carlitux/deoplete-ternjs' ", { 'do': 'npm install -g tern' }

" TODO Move this out of deoplete.nvim section
" Dock mode display error
" Check if nvim has float-window support
if has('nvim') && exists('*nvim_open_win') && exists('##CompleteChanged')
  Plug 'ncm2/float-preview.nvim'
endif

" Disabled for now
" Plug 'autozimu/LanguageClient-neovim', {
"   \ 'branch': 'next',
"   \ 'do': './install.sh'
"   \ }
