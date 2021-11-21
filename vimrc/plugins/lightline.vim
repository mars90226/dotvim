" Fugitive special revisions. call '0' "staging" ?
let s:names = {'0': 'index', '1': 'orig', '2':'fetch', '3':'merge'}
let s:sha1size = 7

let g:lightline = {}
let g:lightline.colorscheme = g:colorscheme
let g:lightline_gruvbox_style = 'hard_left'
let g:lightline.component = {
      \ 'truncate': '%<',
      \ }
let g:lightline.component_expand = {
      \ 'linter_checking': 'lightline#ale#checking',
      \ 'linter_warnings': 'lightline#ale#warnings',
      \ 'linter_errors': 'lightline#ale#errors',
      \ 'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \ 'linter_checking': 'left',
      \ 'linter_warnings': 'warning',
      \ 'linter_errors': 'error',
      \ 'linter_ok': 'left',
      \ }
let g:lightline.component_function = {
      \ 'cocstatus': 'vimrc#lightline#coc_status',
      \ 'filename': 'vimrc#lightline#filename',
      \ 'fileformat': 'vimrc#lightline#fileformat',
      \ 'filetype': 'vimrc#lightline#filetype',
      \ 'fileencoding': 'vimrc#lightline#fileencoding',
      \ 'git_status': 'vimrc#lightline#git_status',
      \ 'lineinfo': 'vimrc#lightline#lineinfo',
      \ 'method': 'vimrc#lightline#nearest_method_or_function',
      \ 'mode': 'vimrc#lightline#mode',
      \ 'percent': 'vimrc#lightline#percent',
      \ }
let g:lightline.tab_component_function = {
      \ 'filename': 'vimrc#lightline#tab_filename',
      \ 'modified': 'vimrc#lightline#tab_modified',
      \ }
let g:lightline.active = {
      \ 'left': [
      \   [ 'mode', 'paste' ],
      \   [ 'truncate', 'git_status', 'filename' ] ],
      \ 'right': [
      \   [ 'lineinfo', 'percent' ],
      \   [ 'filetype', 'fileformat', 'fileencoding' ],
      \   [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
      \   [ 'cocstatus' ],
      \   [ 'method' ] ],
      \ }
let g:lightline.inactive = {
      \ 'left': [
      \   ['filename'] ],
      \ 'right': [
      \   ['lineinfo', 'percent'] ]
      \ }
let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }
