" Mappings
function! vimrc#coc#ccls_mappings()
  " ccls navigate commands
  nnoremap <silent><buffer> <C-X>l :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'D' })<CR>
  nnoremap <silent><buffer> <C-X>k :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'L' })<CR>
  nnoremap <silent><buffer> <C-X>j :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'R' })<CR>
  nnoremap <silent><buffer> <C-X>h :call CocLocations('ccls', '$ccls/navigate', { 'direction': 'U' })<CR>

  " TODO Add mapping for hierarchy

  " ccls inheritance
  " bases
  nnoremap <silent><buffer> <C-X>b :call CocLocations('ccls', '$ccls/inheritance')<CR>
  " bases of up to 3 levels
  nnoremap <silent><buffer> <C-X>B :call CocLocations('ccls', '$ccls/inheritance', { 'levels': 3 })<CR>
  " derived
  nnoremap <silent><buffer> <C-X>d :call CocLocations('ccls', '$ccls/inheritance', { 'derived': v:true })<CR>
  " derived of up to 3 levels
  nnoremap <silent><buffer> <C-X>D :call CocLocations('ccls', '$ccls/inheritance', { 'derived': v:true, 'levels': 3 })<CR>

  " ccls caller
  nnoremap <silent><buffer> <C-X>c :call CocLocations('ccls', '$ccls/call')<CR>
  " ccls callee
  nnoremap <silent><buffer> <C-X>C :call CocLocations('ccls', '$ccls/call', { 'callee': v:true })<CR>

  " ccls member
  " member variables / variables in a namespace
  nnoremap <silent><buffer> <C-X>m :call CocLocations('ccls', '$ccls/member')<CR>
  " member functions / functions in a namespace
  nnoremap <silent><buffer> <C-X>f :call CocLocations('ccls', '$ccls/member', { 'kind': 3 })<CR>
  " member classes / types in a namespace
  nnoremap <silent><buffer> <C-X>s :call CocLocations('ccls', '$ccls/member', { 'kind': 2 })<CR>

  " ccls vars
  " vars field, local, parameter
  nnoremap <silent><buffer> <C-X>v :call CocLocations('ccls', '$ccls/vars')<CR>
  " vars field
  nnoremap <silent><buffer> <C-X>V :call CocLocations('ccls', '$ccls/vars', { 'kind': 1 })<CR>
endfunction

" Functions
function! vimrc#coc#show_documentation()
  if &filetype == 'vim' || &filetype == 'help'
    execute 'help ' . expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

function! vimrc#coc#toggle()
  if g:coc_enabled
    CocDisable
  else
    CocEnable
  endif
endfunction
