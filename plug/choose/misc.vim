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

if !(has('job') || (has('nvim') && exists('*jobwait'))) || vimrc#get_nvim_terminal() == "yes"
  call vimrc#plugin#disable_plugin('vim-gutentags')
endif

if !vimrc#plugin#check#has_linux_build_env()
      \ || vimrc#get_nvim_terminal() == "yes"
      \ || vimrc#get_vim_mode()      == 'gitcommit'
      \ || vimrc#get_vim_mode()      == 'reader'
  call vimrc#plugin#disable_plugin('git-p.nvim')
endif

if !vimrc#plugin#check#has_browser()
  call vimrc#plugin#disable_plugin('open-browser.vim')
endif
