" Settings
if vimrc#plugin#check#has_linux_build_env()
  " TODO Detect clang version
  let g:completor_clang_binary = vimrc#plugin#check#detect_clang_dir('/bin/clang')
end

let g:completor_blacklist = ['tagbar', 'qf', 'netrw']

" <Tab>: completion
inoremap <expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ vimrc#insert#check_back_space() ? "\<Tab>" :
      \ "<C-R>=completor#do('complete')<CR>"
