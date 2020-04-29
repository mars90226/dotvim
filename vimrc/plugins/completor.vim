" Settings
if vimrc#plugin#check#has_linux_build_env()
  " TODO Detect clang version
  let g:completor_clang_binary = '/usr/lib/llvm-8/lib/clang'
end

" <Tab>: completion
inoremap <expr> <Tab>
      \ pumvisible() ? "\<C-N>" :
      \ "<C-R>=completor#do('complete')<CR>"
