" <Tab>: completion.
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ vimrc#insert#check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" <S-Tab>: completion back.
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"

" <M-Space>: trigger completion
inoremap <silent><expr> <M-Space> coc#refresh()

" <CR>: confirm completion, or select first completion item, or insert <CR> with new undo chain
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<C-G>u\<CR>\<C-R>=coc#on_enter()\<CR>"

" <C-X><C-G>: start neosnippet completion
inoremap <silent> <C-X><C-G> <C-R>=coc#start({ 'source': 'neosnippet' })<CR>

" Define mapping for diff mode to avoid recursive mapping
nnoremap <silent> <Plug>(diff-prev) [c
nnoremap <silent> <Plug>(diff-next) ]c
nmap <silent><expr> [c &diff ? "\<Plug>(diff-prev)" : "\<Plug>(coc-diagnostic-prev)"
nmap <silent><expr> ]c &diff ? "\<Plug>(diff-next)" : "\<Plug>(coc-diagnostic-next)"

" mappings for gotos
nnoremap <silent> gd :call CocActionAsync('jumpDefinition')<CR>
nnoremap <silent> gD :call CocActionAsync('jumpDefinition', 'split')<CR>
nnoremap <silent> gy :call CocActionAsync('jumpTypeDefinition')<CR>
nnoremap <silent> gY :call CocActionAsync('jumpTypeDefinition', 'split')<CR>
nnoremap <silent> gi :call CocActionAsync('jumpImplementation')<CR>
nnoremap <silent> gI :call CocActionAsync('jumpImplementation', 'split')<CR>
nnoremap <silent> gr :call CocActionAsync('jumpReferences')<CR>
nnoremap <silent> gR :call CocActionAsync('jumpReferences', 'split')<CR>

" mappings for funcobj & classobj
omap av <Plug>(coc-funcobj-a)
xmap av <Plug>(coc-funcobj-a)
omap iv <Plug>(coc-funcobj-i)
xmap iv <Plug>(coc-funcobj-i)
omap ac <Plug>(coc-classcobj-a)
xmap ac <Plug>(coc-classcobj-a)
omap ic <Plug>(coc-classcobj-i)
xmap ic <Plug>(coc-classcobj-i)

" mappings for range-select
xmap <silent> ar <Plug>(coc-range-select)

" K: show documentation in preview window
nnoremap <silent> K :call vimrc#coc#show_documentation()<CR>
" Remap for K
nnoremap gK K

" mappings for rename current word
nmap <Leader>cr <Plug>(coc-rename)

" mappings for format selected region
nmap <Leader>cf <Plug>(coc-format-selected)
xmap <Leader>cf <Plug>(coc-format-selected)

nnoremap <silent><nowait><expr> <C-F> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-F>"
nnoremap <silent><nowait><expr> <C-B> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-B>"

augroup coc_settings
  autocmd!
  " Highlight symbol under cursor on CursorHold
  " Disabled as not useful and generate a lot of error when not indexed
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  if vimrc#plugin#is_enabled_plugin('lightline.vim')
    " Add lightline support
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
  endif
augroup END

" mappings for do codeAction of selected region
nmap <Leader>ca <Plug>(coc-codeaction-selected)
xmap <Leader>ca <Plug>(coc-codeaction-selected)

" mappings for do codeLensAction
nmap <Leader>cL <Plug>(coc-codelens-action)

" mappings for do codeAction of current line
nmap <Leader>cc <Plug>(coc-codeaction)
" mappings for fix autofix problem of current line
nmap <Leader>cx <Plug>(coc-fix-current)

" :Format for format current buffer
command! -nargs=0 Format :call CocAction('format')

" :Fold for fold current buffer
command! -nargs=? Fold   :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR     :call CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics
nnoremap <silent> <Leader>cd :CocList diagnostics<CR>
" Manage extensions
nnoremap <silent> <Leader>ce :CocList extensions<CR>
" Show commands
nnoremap <silent> <Leader>c; :CocList commands<CR>
" Show info
nnoremap <silent> <Leader>ci :CocInfo<CR>
" Find symbol of current document
nnoremap <silent> <Leader>co :CocList outline<CR>
" Search workspace symbols
nnoremap <silent> <Leader>cs :CocList -I symbols<CR>
" Do default action for next item.
nnoremap <silent> [C         :CocNext<CR>
" Do default action for prevous item.
nnoremap <silent> ]C         :CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <Leader>cu :CocListResume<CR>
" Show lists
nnoremap <silent> <Leader>cl :CocList lists<CR>

command! CocToggle call vimrc#coc#toggle()
nnoremap <silent> <Leader>cy :CocToggle<CR>

" Find cursor word in outline
nnoremap <silent> <Leader>ck :call vimrc#coc#outline_with_query(expand('<cword>'))<CR>
nnoremap <silent> <Leader>cK :call vimrc#coc#outline_with_query(expand('<cWORD>'))<CR>
xnoremap <silent> <Leader>ck :<C-U>call vimrc#coc#outline_with_query(vimrc#utility#get_visual_selection())<CR>

augroup coc_ccls_settings
  autocmd!
  autocmd FileType c,cpp call vimrc#coc#ccls_mappings()
augroup END

" coc-git {{{
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

" show chunk diff at current position
nmap <Leader>gp <Plug>(coc-git-chunkinfo)

" show commit contains current position
" Use our vimrc#fugitive#goto_blame_line()
" nmap <Leader>gc <Plug>(coc-git-commit)

" create text object for git chunks
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ag <Plug>(coc-git-chunk-outer)
xmap ag <Plug>(coc-git-chunk-outer)
" }}}]
