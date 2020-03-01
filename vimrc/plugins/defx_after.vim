" Script Encoding: UTF-8
scriptencoding utf-8

call defx#custom#option('_', {
      \ 'columns': 'git:mark:indent:icon:filename:type:size:time',
      \ 'show_ignored_files': 1,
      \ })
call defx#custom#column('icon', {
      \ 'directory_icon': '▸',
      \ 'opened_icon': '▾',
      \ 'root_icon': ' ',
      \ })
call defx#custom#column('mark', {
      \ 'readonly_icon': '✗',
      \ 'selected_icon': '✓',
      \ })
call defx#custom#column('time', {'format': '%Y/%m/%d %H:%M'})
