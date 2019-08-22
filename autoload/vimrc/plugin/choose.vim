" Plugin Choosing

function! vimrc#plugin#choose#start(vim_mode, nvim_terminal)
  call vimrc#plugin#clear_disabled_plugins()

  " airline, lightline
  if a:vim_mode == 'full'
    call vimrc#plugin#disable_plugin('lightline.vim')
  else
    call vimrc#plugin#disable_plugin('vim-airline')
  endif

  " Choose autocompletion plugin {{{
  " coc.nvim, deoplete.nvim, completor.vim, YouCompleteMe, supertab
  call vimrc#plugin#disable_plugins(
        \ ['coc.nvim', 'deoplete.nvim', 'completor.vim', 'YouCompleteMe', 'supertab'])
  if vimrc#plugin#check#has_async()
        \ && vimrc#plugin#check#has_rpc()
        \ && executable('node')
        \ && executable('yarn')
        \ && a:vim_mode != 'reader'
    " coc.nvim
    call vimrc#plugin#enable_plugin('coc.nvim')
  elseif vimrc#plugin#check#has_async()
        \ && vimrc#plugin#check#has_rpc()
        \ && has("python3")
        \ && vimrc#plugin#check#python_version() >= "3.6.1"
        \ && a:vim_mode != 'reader'
    " deoplete.nvim
    call vimrc#plugin#enable_plugin('deoplete.nvim')
  elseif has("python") || has("python3")
    " completor.vim
    call vimrc#plugin#enable_plugin('completor.vim')
  elseif vimrc#plugin#check#has_linux_build_env()
    " YouCompleteMe
    call vimrc#plugin#enable_plugin('YouCompleteMe')
  else
    " supertab
    call vimrc#plugin#enable_plugin('supertab')
  endif
  " }}}

  " Choose Lint plugin
  " syntastic, ale
  if vimrc#plugin#check#has_async()
    call vimrc#plugin#disable_plugin('syntastic')
  else
    call vimrc#plugin#disable_plugin('ale')
  end

  " Choose file explorer
  " Defx requires python 3.6.1+
  if has("nvim") && vimrc#plugin#check#python_version() >= "3.6.1"
    call vimrc#plugin#disable_plugin("vimfiler")
  else
    call vimrc#plugin#disable_plugin("defx")
  endif

  if !has("python")
    call vimrc#plugin#disable_plugin('github-issues.vim')
  endif

  if !(vimrc#plugin#check#has_async()
        \ && vimrc#plugin#check#has_rpc()
        \ && has("python3")
        \ && vimrc#plugin#check#python_version() >= "3.6.1")
    call vimrc#plugin#disable_plugin('denite.nvim')
  end

  if v:version < 730 || !(has("python") || has("python3"))
    call vimrc#plugin#disable_plugin('vim-mundo')
  endif

  " Choose markdown-preview plugin
  if has("nvim")
    call vimrc#plugin#disable_plugin('markdown-preview.vim')
  else
    call vimrc#plugin#disable_plugin('markdown-preview.nvim')
  endif

  if !exists("##TextYankPost")
    call vimrc#plugin#disable_plugin('vim-highlightedyank')
  endif

  if !(has('job') || (has('nvim') && exists('*jobwait'))) || a:nvim_terminal == "yes"
    call vimrc#plugin#disable_plugin('vim-gutentags')
  endif

  if !vimrc#plugin#check#has_linux_build_env()
        \ || a:nvim_terminal == "yes"
        \ || a:vim_mode      == 'gitcommit'
        \ || a:vim_mode      == 'reader'
    call vimrc#plugin#disable_plugin('git-p.nvim')
  endif
endfunction
