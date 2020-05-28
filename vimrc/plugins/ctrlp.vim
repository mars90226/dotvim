let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
      \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

nnoremap <C-P> :CtrlP<CR>
nnoremap <Leader>pO :CtrlPFunky<CR>
nnoremap <Leader>pk :execute 'CtrlPFunky ' . expand('<cword>')<CR>
xnoremap <Leader>pk :<C-U>execute 'CtrlPFunky ' . vimrc#utility#get_visual_selection()<CR>
nnoremap <Leader>pm :CtrlPMRU<CR>
nnoremap <Leader>p] :CtrlPtjump<CR>
xnoremap <Leader>p] :CtrlPtjumpVisual<CR>

command! -nargs=1 CtrlPSetTimeout call vimrc#ctrlp#set_timeout(<f-args>)

if executable('fd')
  let g:ctrlp_base_user_command = 'fd --type f --no-ignore-vcs --hidden --follow --ignore-file ' . $HOME . '/.ignore "" %s'
endif

call vimrc#ctrlp#update_user_command(v:true)
