call vimrc#lazy#lazy_load('unite_workflow')

let g:unite_source_history_yank_enable = 1

" for unite-workflow
let g:github_user = $GITHUB_USER

if vimrc#plugin#is_enabled_plugin('lightline.vim')
  let g:unite_force_overwrite_statusline = 0
endif

" Unite key mappings {{{
" Unite don't auto-preview file as it's slow
nnoremap <Space>l :Unite -start-insert line<CR>
nnoremap <Space>p :Unite -buffer-name=files buffer bookmark file<CR>
if has('nvim')
  nnoremap <Space>P :Unite -start-insert file_rec/neovim<CR>
else
  nnoremap <Space>P :Unite -start-insert file_rec<CR>
endif
nnoremap <Space>/ :call vimrc#unite#grep('.', '', 'grep', '', v:false)<CR>
nnoremap <Space>? :call vimrc#unite#grep('.', '', 'grep', input('Option: '), v:false)<CR>
nnoremap <Space>o :Unite outline -start-insert<CR>
nnoremap <Space>ua :Unite location_list<CR>
nnoremap <Space>uA :Unite apropos -start-insert<CR>
nnoremap <Space>ub :UniteWithBufferDir -buffer-name=files -prompt=%\  file<CR>
nnoremap <Space>uc :Unite -auto-preview change<CR>
nnoremap <Space>uC :UniteWithCurrentDir -buffer-name=files file<CR>
nnoremap <Space>ud :Unite directory<CR>
nnoremap <Space>uD :UniteWithBufferDir directory<CR>
nnoremap <Space>u<C-D> :execute 'Unite directory:' . input('dir: ', '', 'dir')<CR>
nnoremap <Space>ue :call vimrc#unite#grep(input('Folder: ', '', 'dir'), '', 'grep', '', v:false)<CR>
nnoremap <Space>uE :call vimrc#unite#grep(input('Folder: ', '', 'dir'), '', 'grep', input('Option: '), v:false)<CR>
nnoremap <Space>uf :Unite function -start-insert<CR>
nnoremap <Space>uh :Unite history/unite<CR>
nnoremap <Space>uj :Unite -auto-preview jump<CR>
nnoremap <Space>uk :call vimrc#unite#grep('.', expand('<cword>'), 'keyword', '', v:false)<CR>
nnoremap <Space>uK :call vimrc#unite#grep('.', expand('<cWORD>'), 'keyword', '', v:false)<CR>
nnoremap <Space>u8 :call vimrc#unite#grep('.', expand('<cword>'), 'keyword', '', v:true)<CR>
nnoremap <Space>u* :call vimrc#unite#grep('.', expand('<cWORD>'), 'keyword', '', v:true)<CR>
xnoremap <Space>uk :<C-U>call vimrc#unite#grep('.', vimrc#utility#get_visual_selection(), 'keyword', '', v:false)<CR>
xnoremap <Space>u8 :<C-U>call vimrc#unite#grep('.', vimrc#utility#get_visual_selection(), 'keyword', '', v:true)<CR>
nnoremap <Space>ul :UniteWithCursorWord -no-split -auto-preview line<CR>
nnoremap <Space>um :Unite -start-insert file_mru<CR>
nnoremap <Space>uM :Unite -buffer-name=files -default-action=lcd -start-insert directory_mru<CR>
nnoremap <Space>uo :Unite output -start-insert<CR>
nnoremap <Space>uO :Unite outline -start-insert<CR>
nnoremap <Space>up :UniteWithProjectDir -buffer-name=files -prompt=&\  file<CR>
nnoremap <Space>uq :Unite quickfix<CR>
nnoremap <Space>ur :Unite -buffer-name=register register<CR>
nnoremap <Space>us :Unite -quick-match tab<CR>
nnoremap <Space>ut :Unite -start-insert tab<CR>
nnoremap <Space>uu :UniteResume<CR>
nnoremap <Space>uU :Unite -buffer-name=resume resume<CR>
nnoremap <Space>uw :Unite window<CR>
nnoremap <Space>uy :Unite history/yank -start-insert<CR>
nnoremap <Space>u` :Unite mapping<CR>
nnoremap <Space>u: :Unite history/command -start-insert<CR>
nnoremap <Space>u; :Unite command -start-insert<CR>
nnoremap <Space>u/ :Unite history/search<CR>
nnoremap <Space>u<Space> :Unite source<CR>

nnoremap <Space><F1> :Unite output:map<CR>
nnoremap <Space><F2> :Unite output:map\ <buffer><CR>

if executable('fd')
  let g:unite_source_rec_async_command =
        \ ['fd', '--type', 'file', '--follow', '--hidden', '--exclude', '.git', '']
endif

if executable('rg')
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--hidden --no-heading --vimgrep -S'
  let g:unite_source_grep_recursive_opt = ''

  nnoremap <Space>g/ :call vimrc#unite#grep('.', '', 'grep', vimrc#rg#current_type_option(), v:false)<CR>
  nnoremap <Space>g? :call vimrc#unite#grep('.', '', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
endif
" }}}

augroup unite_mappings
  autocmd!
  autocmd FileType unite call vimrc#unite#mappings()
augroup END
