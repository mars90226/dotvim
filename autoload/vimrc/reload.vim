" Reload

let s:current_filename = expand('<sfile>')

function! vimrc#reload#reload()
  for file in split(glob(vimrc#get_vimhome() . '/autoload/**/*.vim'), '\n')
    " Avoid reloading reload.vim
    if resolve(file) != s:current_filename
      execute 'source ' . file
    endif
  endfor

  source $MYVIMRC

  " Source $MYVIMRC will reset editorconfig to default config, so reload
  " editorconfig
  if exists(":EditorConfigReload")
    EditorConfigReload
  endif
endfunction
