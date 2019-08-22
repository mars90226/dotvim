" Reload

let s:current_filename = expand('<sfile>')

function! vimrc#reload#reload()
  for file in split(glob(vimrc#get_vimhome() . '/autoload/**/*.vim'), '\n')
    " Avoid reloading reload.vim
    if file != s:current_filename
      execute 'source ' . file
    endif
  endfor

  source $MYVIMRC
endfunction
