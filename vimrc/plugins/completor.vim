" Settings
if vimrc#plugin#check#has_linux_build_env()
  " TODO Detect clang version
  let g:completor_clang_binary = vimrc#plugin#check#detect_clang_dir().'/bin/clang'
end

" <Tab>: completion
inoremap <expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ "<C-R>=completor#do('complete')<CR>"
