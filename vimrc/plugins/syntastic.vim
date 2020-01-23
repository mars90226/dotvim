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

let g:syntastic_ignore_files = ['\m^/usr/include/', '\m\c\.h$']
if exists('g:syntastic_secret_ignore_files')
  let g:syntastic_ignore_files += g:syntastic_secret_ignore_files
endif

nnoremap <Space><F6> :SyntasticCheck<CR>
command! -bar SyntasticCheckHeader call vimrc#syntastic#check_header()
