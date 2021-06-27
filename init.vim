" Profile {{{
" Disabled by default, enable to profile
" profile start /tmp/profile.log
" profile file *
" profile func *
" }}}

call vimrc#source('plug/plugin_config_cache.vim')
call vimrc#source('vimrc/basic.vim')
call vimrc#source('vimrc/config.vim')
call vimrc#source('plug/plugin_choose.vim')
call vimrc#source('plug/auto_plug.vim')

" Plugin Settings Begin
call plug#begin(vimrc#get_vim_plug_dir())

call vimrc#source('plug/appearance.vim')
call vimrc#source('plug/completion.vim')
call vimrc#source('plug/file_explorer.vim')
call vimrc#source('plug/file_navigation.vim')
call vimrc#source('plug/text_navigation.vim')
call vimrc#source('plug/text_manipulation.vim')
call vimrc#source('plug/text_objects.vim')
call vimrc#source('plug/languages.vim')
call vimrc#source('plug/git.vim')
call vimrc#source('plug/terminal.vim')
call vimrc#source('plug/utility.vim')
call vimrc#source('plug/last.vim')

call plug#end()

" Post-loaded Plugin Settings
call vimrc#source('plug/after.vim')

call vimrc#source('vimrc/settings.vim')
call vimrc#source('vimrc/indent.vim')
call vimrc#source('vimrc/search.vim')
call vimrc#source('vimrc/syntax.vim')
call vimrc#source('vimrc/digraphs.vim')
call vimrc#source('vimrc/mappings.vim')
call vimrc#source('vimrc/float.vim')
call vimrc#source('vimrc/job.vim')
call vimrc#source('vimrc/terminal.vim')
call vimrc#source('vimrc/tui.vim')
call vimrc#source('vimrc/termdebug.vim')
call vimrc#source('vimrc/autocmd.vim')
call vimrc#source('vimrc/workaround.vim')
