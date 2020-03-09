let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

nnoremap <C-P> :CtrlP<CR>
nnoremap <Leader>cO :CtrlPFunky<CR>
nnoremap <Leader>ck :execute 'CtrlPFunky ' . expand('<cword>')<CR>
xnoremap <Leader>ck :<C-U>execute 'CtrlPFunky ' . vimrc#get_visual_selection()<CR>
nnoremap <Leader>cm :CtrlPMRU<CR>
nnoremap <Leader>c] :CtrlPtjump<CR>
xnoremap <Leader>c] :CtrlPtjumpVisual<CR>

command! -nargs=1 CtrlPSetTimeout call vimrc#ctrlp#set_timeout(<f-args>)

if executable('fd')
  let g:ctrlp_base_user_command = 'fd --type f --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore "" %s'
endif

call vimrc#ctrlp#update_user_command(v:true)
