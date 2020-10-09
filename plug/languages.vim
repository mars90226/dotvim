" emmet {{{
Plug 'mattn/emmet-vim', { 'on': [] }

call vimrc#lazy#lazy_load('emmet')

let g:user_emmet_leader_key = '<C-E>'
" }}}

" cscope-macros.vim {{{
Plug 'mars90226/cscope_macros.vim', { 'on': [] }

call vimrc#source('vimrc/plugins/cscope.vim')
" }}}

" vim-seeing-is-believing {{{
Plug 'hwartig/vim-seeing-is-believing', { 'for': 'ruby' }

augroup seeing_is_believing_settings
  autocmd!
  autocmd FileType ruby call vimrc#seeing_is_believing#mappings()
augroup END
" }}}

" syntastic {{{
if vimrc#plugin#is_enabled_plugin('syntastic')
  Plug 'vim-syntastic/syntastic'

  call vimrc#source('vimrc/plugins/syntastic.vim')
end
" }}}

" ale {{{
if vimrc#plugin#is_enabled_plugin('ale')
  Plug 'w0rp/ale'

  call vimrc#source('vimrc/plugins/ale.vim')
end
" }}}

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
if vimrc#plugin#check#has_cargo()
  Plug 'euclio/vim-markdown-composer', { 'do': function('vimrc#composer#build_composer') }

  " Manually execute :ComposerStart instead
  let g:markdown_composer_autostart = 0
endif
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

" tern_for_vim {{{
Plug 'ternjs/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }

augroup tern_for_vim_settings
  autocmd!
  autocmd FileType javascript call vimrc#tern#mappings()
augroup END
" }}}

" jedi-vim {{{
if vimrc#plugin#check#has_jedi()
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }

  let g:jedi#completions_enabled = 1

  let g:jedi#goto_command             = '<C-X><C-G>'
  let g:jedi#goto_assignments_command = '<C-X>a'
  let g:jedi#goto_definitions_command = '<C-X><C-D>'
  let g:jedi#documentation_command    = '<C-X><C-K>'
  let g:jedi#usages_command           = '<C-X>c'
  let g:jedi#completions_command      = '<C-X>x'
  let g:jedi#rename_command           = '<C-X><C-R>'
  let g:jedi#goto_stubs_command       = '<C-X><C-S>'

  augroup jedi_vim_settings
    autocmd!
    autocmd FileType python call vimrc#jedi#mappings()
  augroup END
endif
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

" vim-lsp-cxx-highlight {{{
if vimrc#plugin#is_enabled_plugin('vim-lsp-cxx-highlight')
  Plug 'jackguo380/vim-lsp-cxx-highlight'
endif
" }}}

" vim-doge {{{
if vimrc#plugin#is_enabled_plugin('vim-doge')
  Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

  let g:doge_mapping = '<Leader><Leader>d'
endif
" }}}

Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'mars90226/perldoc-vim', { 'for': 'perl' }
Plug 'fs111/pydoc.vim', { 'for': 'python' }
