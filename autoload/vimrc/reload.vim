" Reload

let s:current_filename = expand('<sfile>')

function! vimrc#reload#reload()
  " reload in floating window to avoid affecting current buffer & window
  " settings
  if has('nvim')
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(-1, width, height)
  endif

  for file in split(glob(vimrc#get_vimhome() . '/autoload/**/*.vim'), '\n')
    " Avoid reloading reload.vim
    " When changing this file, a restart of neovim or manually reload this
    " file is needed
    if resolve(file) != s:current_filename
      execute 'source ' . file
    endif
  endfor

  source $MYVIMRC

  " Close floating window
  if has('nvim')
    close
  endif

  " Source $MYVIMRC will reset editorconfig to default config, so reload
  " editorconfig
  if exists(':EditorConfigReload')
    EditorConfigReload
  endif

  " Source $MYVIMRC will reset localvimrc config, reload localvimrc
  if exists(':LocalVimRC')
    LocalVimRC
  endif
endfunction
