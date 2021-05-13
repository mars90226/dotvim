" Reload

let s:current_filename = expand('<sfile>')

" Try to simulate vim/neovim initialization order
function! vimrc#reload#reload() abort
  " Reload in floating window to avoid affecting current buffer & window
  " settings
  if has('nvim')
    let [width, height] = vimrc#float#get_default_size()
    call vimrc#float#open(-1, width, height)
  endif

  " Reload autoload
  call vimrc#reload#recurive_reload(vimrc#get_vimhome() . '/autoload')

  " Reload init.vim
  source $MYVIMRC

  " Reload plugin
  call vimrc#reload#recurive_reload(vimrc#get_vimhome() . '/plugin')

  " Reload after/autoload
  call vimrc#reload#recurive_reload(vimrc#get_vimhome() . '/after/autoload')

  " Reload after/plugin
  call vimrc#reload#recurive_reload(vimrc#get_vimhome() . '/after/plugin')

  " Close floating window
  if has('nvim')
    close
  endif

  " Source $MYVIMRC will reset editorconfig to default config, so reload
  " editorconfig
  if exists(':EditorConfigReload') == 2
    EditorConfigReload
  endif

  " Source $MYVIMRC will reset localvimrc config, reload localvimrc
  if exists(':LocalVimRC') == 2
    LocalVimRC
  endif
endfunction

function! vimrc#reload#recurive_reload(path) abort
  let pattern = a:path . '/**/*.vim'

  for file in split(glob(pattern), '\n')
    " Avoid reloading reload.vim
    " When changing this file, a restart of neovim or manually reload this
    " file is needed
    if resolve(file) != s:current_filename
      execute 'source ' . file
    endif
  endfor
endfunction
