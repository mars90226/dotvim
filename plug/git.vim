" vim-fugitive {{{
Plug 'tpope/vim-fugitive'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'tommcdo/vim-fubitive'
Plug 'tpope/vim-rhubarb'
Plug 'idanarye/vim-merginal', { 'branch': 'develop' }

call vimrc#source('vimrc/plugins/fugitive.vim')
call vimrc#source('vimrc/plugins/merginal.vim')
" }}}

" gv.vim {{{
Plug 'junegunn/gv.vim', { 'on': 'GV' }

command! -bang -nargs=* GVA GV<bang> --all <args>

" GV with company filter
execute 'command! -nargs=* GVD  GV --author='.get(g:, 'company_domain', '').' <args>'
execute 'command! -nargs=* GVDA GV --author='.get(g:, 'company_domain', '').' --all <args>'
execute 'command! -nargs=* GVE  GV --author='.get(g:, 'company_email', '').' <args>'
execute 'command! -nargs=* GVEA GV --author='.get(g:, 'company_email', '').' --all <args>'

nnoremap <Space>gv :call vimrc#gv#open({})<CR>
nnoremap <Space>gV :call vimrc#gv#open({'all': v:true})<CR>

nnoremap <Leader>gv     :call vimrc#gv#show_file('%', {})<CR>
nnoremap <Leader>gV     :call vimrc#gv#show_file('%', {'author': g:company_domain})<CR>
nnoremap <Leader>g<C-V> :call vimrc#gv#show_file('%', {'author': g:company_email})<CR>

augroup gv_settings
  autocmd!
  autocmd FileType GV call vimrc#gv#mappings()
augroup END
" }}}

" vim-flog {{{
Plug 'rbong/vim-flog'

command! -nargs=* Floga Flog -all <args>

" GV with company filter
execute 'command! -nargs=* Flogd  Flog -author='.get(g:, 'company_domain', '').' <args>'
execute 'command! -nargs=* Flogda Flog -author='.get(g:, 'company_domain', '').' -all <args>'
execute 'command! -nargs=* Floge  Flog -author='.get(g:, 'company_email', '').' <args>'
execute 'command! -nargs=* Flogea Flog -author='.get(g:, 'company_email', '').' -all <args>'

nnoremap <Space>gf :call vimrc#flog#open({})<CR>
nnoremap <Space>gF :call vimrc#flog#open({'all': v:true})<CR>

nnoremap <Leader>gf     :call vimrc#flog#show_file('%', {})<CR>
nnoremap <Leader>gF     :call vimrc#flog#show_file('%', {'author': g:company_domain})<CR>
nnoremap <Leader>g<C-F> :call vimrc#flog#show_file('%', {'author': g:company_email})<CR>

augroup flog_settings
  autocmd!
  autocmd FileType floggraph call vimrc#flog#mappings()
augroup END
" }}}

" " vim-gitgutter {{{
" if vimrc#plugin#is_enabled_plugin('vim-gitgutter')
"   " Plug 'airblade/vim-gitgutter', { 'on': [] }
"   Plug 'airblade/vim-gitgutter'
"
"   " call vimrc#lazy#lazy_load('gitgutter')
"
"   let g:gitgutter_grep = 'rg --hidden --follow --glob "!.git/*"'
"
"   nnoremap cog :GitGutterBufferToggle<CR>
"   nnoremap coG :GitGutterToggle<CR>
"
"   nmap <silent> [h <Plug>(GitGutterPrevHunk)
"   nmap <silent> ]h <Plug>(GitGutterNextHunk)
"
"   omap ih <Plug>(GitGutterTextObjectInnerPending)
"   omap ah <Plug>(GitGutterTextObjectOuterPending)
"   xmap ih <Plug>(GitGutterTextObjectInnerVisual)
"   xmap ah <Plug>(GitGutterTextObjectOuterVisual)
" endif
" " }}}

" vim-signify {{{
Plug 'mhinz/vim-signify'

let g:signify_priority = 40

nnoremap <Leader>hd :SignifyDiff<CR>
nnoremap <Leader>hf :SignifyFold<CR>
nnoremap <Leader>hp :SignifyHunkDiff<CR>
nnoremap <Leader>hu :SignifyHunkUndo<CR>

nmap [h <Plug>(signify-prev-hunk)
nmap ]h <Plug>(signify-next-hunk)
nmap [H 9999<Plug>(signify-prev-hunk)
nmap ]H 9999<Plug>(signify-next-hunk)

omap ih <Plug>(signify-motion-inner-pending)
xmap ih <Plug>(signify-motion-inner-visual)
omap ah <Plug>(signify-motion-outer-pending)
xmap ah <Plug>(signify-motion-outer-visual)
" }}}

" vim-tig {{{
Plug 'codeindulgence/vim-tig', { 'on': ['Tig', 'Tig!'] }

call vimrc#source('vimrc/plugins/tig.vim')
" }}}

" git-messenger.vim {{{
Plug 'rhysd/git-messenger.vim', { 'on': ['GitMessenger', '<Plug>(git-messenger)'] }

nmap <Leader>gm <Plug>(git-messenger)

augroup git_messenger_settings
  autocmd!
  autocmd FileType gitmessengerpopup call vimrc#git_messenger#mappings()
augroup END
" }}}

" diffview.nvim {{{
if vimrc#plugin#is_enabled_plugin('diffview.nvim')
  Plug 'sindrets/diffview.nvim'

  augroup diffview_settings
    autocmd!
    autocmd FileType DiffviewFiles call vimrc#diffview#mappings()
    " diffview.nvim use nvim_buf_set_name() to change buffer name to
    " corresponding file, so use BufFilePost event
    " diffview buffer pattern: "^diffview/(\d+_)?(\w{7})_.*$"
    "                                     ^index ^sha    ^filename
    autocmd BufFilePost diffview/\(\d\\\{1,\}_\)\\\{0,1\}\w\\\{7\}_* call vimrc#diffview#buffer_mappings()
  augroup END
endif
" }}}

" blamer.nvim {{{
if vimrc#plugin#is_enabled_plugin('blamer.nvim')
  Plug 'APZelos/blamer.nvim'

  let g:blamer_enabled = 1
  let g:blamer_delay = 500
  let g:blamer_date_format = '%Y-%m-%d %H:%M'
  let g:blamer_relative_time = 1
endif
" }}}

" Disabled as not used
Plug 'mattn/gist-vim', { 'for': [] }
