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

augroup seeingIsBelievingSettings
  autocmd!
  autocmd FileType ruby call s:seeing_is_believing_settings()
augroup END

function! s:seeing_is_believing_settings()
  nmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)
  xmap <silent><buffer> <Leader>r<CR> <Plug>(seeing-is-believing-mark-and-run)

  nmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  xmap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)
  imap <silent><buffer> <Leader>rm <Plug>(seeing-is-believing-mark)

  nmap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
  imap <silent><buffer> <Leader>rr <Plug>(seeing-is-believing-run)
endfunction
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
if executable('cargo')
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  endfunction

  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

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
  autocmd FileType javascript call s:tern_for_vim_settings()
augroup END

function! s:tern_for_vim_settings()
  nnoremap <silent><buffer> <C-X><C-K> :TernDoc<CR>
  nnoremap <silent><buffer> <C-X><C-B> :TernDocBrowse<CR>
  nnoremap <silent><buffer> <C-X><C-T> :TernType<CR>
  " To avoid accidentally delete
  nnoremap <silent><buffer> <C-X><C-D> :TernDef<CR>
  nnoremap <silent><buffer> <C-X><C-P> :TernDefPreview<CR>
  nnoremap <silent><buffer> <C-X><C-S> :TernDefSplit<CR>
  nnoremap <silent><buffer> <C-X><C-N> :TernDefTab<CR>
  nnoremap <silent><buffer> <C-X>c :TernRefs<CR>
  nnoremap <silent><buffer> <C-X><C-R> :TernRename<CR>
endfunction
" }}}

" jedi-vim {{{
if vimrc#plugin#check#has_jedi()
  Plug 'davidhalter/jedi-vim', { 'for': 'python' }

  let g:jedi#completions_enabled = 1

  let g:jedi#goto_command             = "<C-X><C-G>"
  let g:jedi#goto_assignments_command = "<C-X>a"
  let g:jedi#goto_definitions_command = "<C-X><C-D>"
  let g:jedi#documentation_command    = "<C-X><C-K>"
  let g:jedi#usages_command           = "<C-X>c"
  let g:jedi#completions_command      = "<C-X><C-X>"
  let g:jedi#rename_command           = "<C-X><C-R>"

  augroup jedi_vim_settings
    autocmd!
    autocmd FileType python call s:jedi_vim_settings()
  augroup END

  function! s:jedi_vim_settings()
    nnoremap <silent><buffer> <C-X><C-L> :call jedi#remove_usages()<CR>
    nnoremap <silent><buffer> <C-X><C-N> :tab split <Bar> call jedi#goto()<CR>
  endfunction
endif
" }}}

Plug 'moll/vim-node', { 'for': [] }
Plug 'tpope/vim-rails', { 'for': [] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
" Plug 'amadeus/vim-jsx', { 'for': 'jsx' } " It's included in vim-polyglot
Plug 'scrooloose/vim-slumlord'
Plug 'mars90226/perldoc-vim'
Plug 'gyim/vim-boxdraw'
Plug 'fs111/pydoc.vim'
