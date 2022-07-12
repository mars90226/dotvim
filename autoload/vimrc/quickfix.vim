" Mappings
function! vimrc#quickfix#mappings() abort
  nnoremap <silent><buffer> q :close<CR>
  nnoremap <silent><buffer> <C-T> :set switchbuf+=newtab<CR><CR>:set switchbuf-=newtab<CR>
  nnoremap <silent><buffer> <C-S> :set switchbuf+=split<CR><CR>:set switchbuf-=split<CR>
  nnoremap <silent><buffer> <C-V> :set switchbuf+=vsplit<CR><CR>:set switchbuf-=vsplit<CR>

  " Use fugitive to open file
  " TODO Add key mapping for :cnext and :cprevious for opening with fugitive
  " TODO: Organize code
  nnoremap <silent><buffer> <M-f> :call vimrc#quickfix#open('Gedit')<CR>
  nnoremap <silent><buffer> <M-t> :call vimrc#quickfix#open('Gtabedit')<CR>
  nnoremap <silent><buffer> <M-s> :call vimrc#quickfix#open('Gsplit')<CR>
  nnoremap <silent><buffer> <M-v> :call vimrc#quickfix#open('Gvsplit')<CR>

  " Use fugitive to open commit
  nnoremap <silent><buffer><nowait> gc 0:execute 'Gsplit '.expand('<cword>')<CR>
endfunction

" Functions
function! vimrc#quickfix#open(cmd) abort
  " Get current selected quickfix item
  let item = getqflist()[line('.') - 1]
  let buffer_name = bufname(item.bufnr)

  " Emulate switchbuf by CTRL-W_W to window above/left of current one and
  " execute cmd
  wincmd W
  execute a:cmd.' '.buffer_name
  execute item.lnum
  if item.col
    execute 'normal! ' . item.col . '|'
  endif
  normal! zz
endfunction

function! vimrc#quickfix#execute(args) abort
  cexpr execute(a:args)
  copen
endfunction

function! vimrc#quickfix#loc_execute(args) abort
  lexpr execute(a:args)
  lopen
endfunction

" NOTE: Assume file per line
function! vimrc#quickfix#build_from_buffer(bufnr) abort
  let lines = getbufline(a:bufnr, 1, '$')
  let qflist = map(lines, '{"filename": v:val, "lnum": 1, "col": 1}')
  call setqflist(qflist)
  copen
  cfirst
endfunction
