" Autoinstall vim-plug
if empty(glob(vimrc#get_vimhome().'/autoload/plug.vim'))
  silent! !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://rawgithubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_install
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif
