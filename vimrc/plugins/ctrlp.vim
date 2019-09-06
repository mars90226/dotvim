let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
" let g:ctrlp_cmdpalette_execute = 1

nnoremap <C-P> :CtrlP<CR>
nnoremap <Space>cO :CtrlPFunky<CR>
nnoremap <Space>cK :execute 'CtrlPFunky ' . expand('<cword>')<CR>
xnoremap <Space>cK :<C-U>execute 'CtrlPFunky ' . vimrc#get_visual_selection()<CR>
nnoremap <Space>cp :CtrlPCmdPalette<CR>
nnoremap <Space>cm :CtrlPCmdline<CR>
nnoremap <Space>c] :CtrlPtjump<CR>
xnoremap <Space>c] :CtrlPtjumpVisual<CR>

command! -nargs=1 CtrlPSetTimeout call vimrc#ctrlp#set_timeout(<f-args>)

if executable('fd')
  let g:ctrlp_base_user_command = 'fd --type f --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore "" %s'
endif

call vimrc#ctrlp#update_user_command(v:true)
" }}}

" netrw {{{
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro' " add line number

augroup netrw_mapping
  autocmd!
  autocmd FileType netrw call s:netrw_mapping()
augroup END

function! s:netrw_mapping()
  nmap <buffer> <BS> <Plug>VinegarUp
endfunction
