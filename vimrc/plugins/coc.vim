" <Tab>: completion.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ vimrc#check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" <S-Tab>: completion back.
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

" <M-Space>: trigger completion
inoremap <silent><expr> <M-Space> coc#refresh()

" <CR>: confirm completion, or insert <CR> with new undo chain
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<C-G>u\<CR>"

" Define mapping for diff mode to avoid recursive mapping
nnoremap <silent> <Plug>(diff-prev) [c
nnoremap <silent> <Plug>(diff-next) ]c
nmap <silent><expr> [c &diff ? "\<Plug>(diff-prev)" : "\<Plug>(coc-diagnostic-prev)"
nmap <silent><expr> ]c &diff ? "\<Plug>(diff-next)" : "\<Plug>(coc-diagnostic-next)"

" mapppings for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" mappings for funcobj
omap av <Plug>(coc-funcobj-a)
xmap av <Plug>(coc-funcobj-a)
omap iv <Plug>(coc-funcobj-i)
xmap iv <Plug>(coc-funcobj-i)

" mappings for range-select
xmap <silent> ar <Plug>(coc-range-select)

" K: show documentation in preview window
nnoremap <silent> K :call vimrc#coc#show_documentation()<CR>
" Remap for K
nnoremap gK K

" mappings for rename current word
nmap <Space>cr <Plug>(coc-rename)

" mappings for format selected region
nmap <Space>cf <Plug>(coc-format-selected)
xmap <Space>cf <Plug>(coc-format-selected)

augroup coc_settings
  autocmd!
  " Highlight symbol under cursor on CursorHold
  " Disabled as not useful and generate a lot of error when not indexed
  " autocmd CursorHold * silent call CocActionAsync('highlight')
  " Setup formatexpr
  autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END

" mappings for do codeAction of selected region
nmap <Space>ca <Plug>(coc-codeaction-selected)
xmap <Space>ca <Plug>(coc-codeaction-selected)

" mappings for do codeAction of current line
nmap <Space>cc <Plug>(coc-codeaction)
" mappings for fix autofix problem of current line
nmap <Space>cx <Plug>(coc-fix-current)

" :Format for format current buffer
command! -nargs=0 Format :call CocAction('format')

" :Fold for fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" TODO Add airline support

" Show all diagnostics
nnoremap <silent> <Space>cd :CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> <Space>ce :CocList extensions<CR>
" Show commands
nnoremap <silent> <Space>c; :CocList commands<CR>
" Show info
nnoremap <silent> <Space>ci :CocInfo<CR>
" Find symbol of current document
nnoremap <silent> <Space>co :CocList outline<CR>
" Search workspace symbols
nnoremap <silent> <Space>cs :CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent> <Space>cj :CocNext<CR>
" Do default action for prevous item.
nnoremap <silent> <Space>ck :CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <Space>cu :CocListResume<CR>
" Show lists
nnoremap <silent> <Space>cl :CocList lists<CR>

command! CocToggle call vimrc#coc#toggle()
nnoremap <silent> <Space>cy :CocToggle<CR>

augroup coc_ccls_settings
  autocmd!
  autocmd FileType c,cpp call vimrc#coc#ccls_mappings()
augroup END
