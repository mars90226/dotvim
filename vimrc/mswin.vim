" TODO: Convert to lua
" NOTE: This is modified mswin.vim, changes:
" - Remove behave mswin
" - Remove gui <C-F> & <C-H>
" - Remove <C-Z> & <C-Y>
" - Remove <C-A>, <C-X>
" - Remove <C-Tab>, <C-F4>
" - Remove <M-Space>
" - Remove <C-S>
" - Remove <BS>
" - Do not check `has("clipboard")` to avoid clipboard loading efforts
" Set options and add mapping such that Vim behaves a lot like MS-Windows
"
" neovim nightly #23054 remove `:behave`
" Ref: https://github.com/neovim/neovim/pull/23054
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2018 Dec 07

" Bail out if this isn't wanted.
if exists("g:skip_loading_mswin") && g:skip_loading_mswin
  finish
endif

" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" SHIFT-Del are Cut
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP

cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

if 1
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
endif

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" restore 'cpoptions'
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
