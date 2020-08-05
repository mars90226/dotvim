" Utilities
let s:clap_pythonx_clap_dir = simplify(g:clap#autoload_dir.'/../pythonx/clap')
let s:clap_fuzzymatch_rs_so = s:clap_pythonx_clap_dir.'/fuzzymatch_rs.so'

function! vimrc#clap#get_clap_pythonx_clap_dir()
  return s:clap_pythonx_clap_dir
endfunction

function! vimrc#clap#get_clap_fuzzymatch_rs_so()
  return s:clap_fuzzymatch_rs_so
endfunction

function! vimrc#clap#install()
  Clap install-binary
  call vimrc#clap#build_fuzzymatch_rs()
endfunction

function! vimrc#clap#build_fuzzymatch_rs() abort
  belowright 10new
  setlocal buftype=nofile winfixheight norelativenumber nonumber bufhidden=wipe

  let bufnr = bufnr('')

  function! s:OnExit(status) closure abort
    if a:status == 0
      execute 'silent! bd! '.bufnr
      call clap#helper#echo_info('build fuzzymatch_rs successfully')
    endif
  endfunction

  call termopen('make build', {
    \ 'cwd': s:clap_pythonx_clap_dir,
    \ 'on_exit': {job, status -> s:OnExit(status)}
    \ })
endfunction

" Settings
function! vimrc#clap#settings()
  " FIXME Should make scroll full window, but does not work
  let &l:scroll *= 2
endfunction

" Mappings
function! vimrc#clap#mappings()
  " Press <Esc> to exit
  nnoremap <silent><buffer> <Esc> :call clap#handler#exit()<CR>
  inoremap <silent><buffer> <Esc> <Esc>:<C-U>call clap#handler#exit()<CR>

  " Use <C-O> to goto normal mode
  inoremap <silent><buffer> <C-O> <Esc>

  " Use <C-S> to open in split
  nnoremap <silent><buffer> <C-S> :<C-U>call clap#selection#try_open("ctrl-x")<CR>
  inoremap <silent><buffer> <C-S> <Esc>:<C-U>call clap#selection#try_open("ctrl-x")<CR>

  " Use <M-j>/<M-k> to scroll down/up
  nnoremap <silent><buffer> <M-j> :call clap#navigation#scroll('down')<CR>
  nnoremap <silent><buffer> <M-k> :call clap#navigation#scroll('up')<CR>
  inoremap <silent><buffer> <M-j> <C-R>=clap#navigation#scroll('down')<CR>
  inoremap <silent><buffer> <M-k> <C-R>=clap#navigation#scroll('up')<CR>

  " Completion
  inoremap <silent><buffer> <M-p> <C-P>
  inoremap <silent><buffer> <M-n> <C-N>
endfunction
