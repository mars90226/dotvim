" Highlighting {{{
" nvim-treesitter {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' } " Updating the parsers on update
  Plug 'nvim-treesitter/nvim-treesitter-refactor'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'nvim-treesitter/playground'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'mfussenegger/nvim-ts-hint-textobject'

  call vimrc#source('vimrc/plugins/nvim_treesitter.vim')
endif
" }}}

" vim-lsp-cxx-highlight {{{
if vimrc#plugin#is_enabled_plugin('vim-lsp-cxx-highlight')
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif
" }}}
" }}}

" Context {{{
" nvim-treesitter-context {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter-context')
  Plug 'romgrk/nvim-treesitter-context'

  nnoremap <F6> :TSContextToggle<CR>
endif
" }}}

" context.vim {{{
if vimrc#plugin#is_enabled_plugin('context.vim')
  Plug 'wellle/context.vim'

  let g:context_enabled = 0

  nnoremap <F6> :ContextToggleWindow<CR>
  nnoremap <Space><F6> :ContextToggle<CR>
endif
" }}}
" }}}

" emmet {{{
Plug 'mattn/emmet-vim', { 'on': [] }

call vimrc#lazy#lazy_load('emmet')

let g:user_emmet_leader_key = '<C-E>'
" }}}

" cscope-macros.vim {{{
Plug 'mars90226/cscope_macros.vim', { 'on': [] }

call vimrc#lazy#lazy_load('cscope_macros')

call vimrc#source('vimrc/plugins/cscope.vim')
" }}}

" Lint {{{
" ale {{{
if vimrc#plugin#is_enabled_plugin('ale')
  Plug 'w0rp/ale'

  call vimrc#source('vimrc/plugins/ale.vim')
end
" }}}
" }}}

" Markdown preview {{{
" markdown-preview.vim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.vim')
  Plug 'iamcco/markdown-preview.vim'
endif
" }}}

" markdown-preview.nvim {{{
if vimrc#plugin#is_enabled_plugin('markdown-preview.nvim')
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
endif
" }}}

" vim-markdown-composer {{{
if vimrc#plugin#is_enabled_plugin('vim-markdown-composer')
  Plug 'euclio/vim-markdown-composer', { 'do': function('vimrc#composer#build_composer') }

  " Manually execute :ComposerStart instead
  let g:markdown_composer_autostart = 0
endif
" }}}
" }}}

" vim-go {{{
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

let g:go_decls_mode = 'fzf'

" TODO Add key mappings for vim-go commands
" }}}

" vim-polyglot {{{
Plug 'sheerun/vim-polyglot'

" Avoid conflict with vim-go, must after vim-go loaded
let g:polyglot_disabled = ['go']
" }}}

" rust-doc.vim {{{
Plug 'rhysd/rust-doc.vim', { 'for': 'rust' }

let g:rust_doc#define_map_K = 0
let g:rust_doc#vim_open_cmd = 'RustDocOpen'

command! -nargs=1 RustDocOpen call vimrc#rust_doc#open(<f-args>)
" }}}

" vim-syntax-syslog-ng {{{
Plug 'apeschel/vim-syntax-syslog-ng'

augroup vim_syntax_syslog_ng_settings
  autocmd!
  autocmd BufNewFile,BufReadPost syslog-ng.conf       setlocal filetype=syslog-ng
  autocmd BufNewFile,BufReadPost syslog-ng/*/*.conf   setlocal filetype=syslog-ng
  autocmd BufNewFile,BufReadPost patterndb.d/*.conf   setlocal filetype=syslog-ng
  autocmd BufNewFile,BufReadPost patterndb.d/*/*.conf setlocal filetype=syslog-ng
augroup END
" }}}

" vim-doge {{{
if vimrc#plugin#is_enabled_plugin('vim-doge')
  Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

  let g:doge_mapping = '<Leader><Leader>d'
endif
" }}}

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'mars90226/perldoc-vim', { 'for': 'perl' }

" pydoc.vim {{{
Plug 'fs111/pydoc.vim', { 'for': 'python' }

let g:pydoc_perform_mappings = 0
" }}}
