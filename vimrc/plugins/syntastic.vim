" Automatically setup by airline
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 2
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0

let g:syntastic_ruby_checkers = ['mri', 'rubylint']
let g:syntastic_tex_checkers  = ['lacheck']
let g:syntastic_c_checkers    = ['gcc']
let g:syntastic_cpp_checkers  = ['gcc']

let g:syntastic_ignore_files = ['\m^/usr/include/', '\m^/synosrc/packages/build_env/', '\m\c\.h$']
nnoremap <Space><F6> :SyntasticCheck<CR>
command! -bar SyntasticCheckHeader call s:SyntasticCheckHeader()
function! s:SyntasticCheckHeader()
  let header_pattern_index = index(g:syntastic_ignore_files, '\m\c\.h$')
  if header_pattern_index >= 0
    call remove(g:syntastic_ignore_files, header_pattern_index)
  endif

  let g:syntastic_c_check_header = 1
  let g:syntastic_cpp_check_header = 1
  SyntasticCheck
endfunction
