if exists('b:loaded_python_settings')
  finish
endif
let b:loaded_python_settings = 1

setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal expandtab

" pydoc.vim mappings
nnoremap <silent> <buffer> <Leader>pw :call vimrc#pydoc#show_pydoc('<C-R><C-W>', 1)<CR>
nnoremap <silent> <buffer> <Leader>pW :call vimrc#pydoc#show_pydoc('<C-R><C-A>', 1)<CR>
nnoremap <silent> <buffer> <Leader>pk :call vimrc#pydoc#show_pydoc('<C-R><C-W>', 0)<CR>
nnoremap <silent> <buffer> <Leader>pK :call vimrc#pydoc#show_pydoc('<C-R><C-A>', 0)<CR>
nnoremap <silent> <buffer> gK :call vimrc#pydoc#show_pydoc(vimrc#pydoc#replace_module_alias(), 1)<CR>

if executable('black-macchiato')
  setlocal formatprg=black-macchiato
elseif executable('autopep8')
  setlocal formatprg=autopep8
end

if executable('isort')
  command -range SortImport :<line1>,<line2>!isort -
endif
