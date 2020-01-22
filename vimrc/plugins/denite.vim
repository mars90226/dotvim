let g:session_directory = $HOME.'/vim-sessions/'
let g:denite_source_session_path = $HOME.'/vim-sessions/'
let g:project_folders = []
let g:project_folders += g:denite_secret_project_folders

" Denite key mappings {{{
" Override Unite key mapping {{{
call vimrc#remap('<Space>up', '<Space>u<C-P>', 'n') " UniteWithProjectDir file
call vimrc#remap('<Space>P',  '<Space>uP',     'n') " Unite file/rec
call vimrc#remap('<Space>p',  '<Space>up',     'n') " Unite file
call vimrc#remap('<Space>ul', '<Space>uL',     'n') " UniteWithCursorWord line
call vimrc#remap('<Space>l',  '<Space>ul',     'n') " Unite line
call vimrc#remap('<Space>o',  '<Space>O',      'n') " Unite outline

nnoremap <Space>p     :Denite -auto-resume buffer dirmark file<CR>
nnoremap <Space>P     :Denite -auto-resume file/rec<CR>
nnoremap <Space><C-P> :DeniteProjectDir -auto-resume file<CR>
nnoremap <Space>l     :Denite -auto-action=highlight line<CR>
nnoremap <Space>L     :Denite -default-action=switch line:buffers<CR>
nnoremap <Space>dl    :DeniteCursorWord -auto-action=preview -split=no line<CR>
xnoremap <Space>dl    :<C-U>execute 'Denite -auto-action=preview -split=no -input='.vimrc#escape_symbol(vimrc#get_visual_selection()).' line'<CR>
nnoremap <Space>o     :Denite outline<CR>
" }}}

" TODO Denite quickfix seems not working
" TODO Add Denite tselect source
" Denite don't use auto-preview file because it's slow

nnoremap <Space>da :Denite location_list<CR>
nnoremap <Space>db :DeniteBufferDir -auto-resume file<CR>
nnoremap <Space>dc :Denite -auto-action=preview change<CR>
nnoremap <Space>dd :Denite directory_rec<CR>
nnoremap <Space>dD :Denite directory_mru<CR>
nnoremap <Space>df :Denite filetype<CR>
nnoremap <Space>dh :Denite help<CR>
nnoremap <Space>dj :Denite -auto-action=preview jump<CR>
nnoremap <Space>dJ :Denite project<CR>
nnoremap <Space>di :call vimrc#denite#grep('!', 'grep', '', v:false)<CR>
nnoremap <Space>dk :call vimrc#denite#grep(expand('<cword>'), 'grep', '', v:false)<CR>
nnoremap <Space>dK :call vimrc#denite#grep(expand('<cWORD>'), 'grep', '', v:false)<CR>
nnoremap <Space>d8 :call vimrc#denite#grep(expand('<cword>'), 'grep', '', v:true)<CR>
nnoremap <Space>d* :call vimrc#denite#grep(expand('<cWORD>'), 'grep', '', v:true)<CR>
xnoremap <Space>dk :<C-U>call vimrc#denite#grep(vimrc#get_visual_selection(), 'grep', '', v:false)<CR>
xnoremap <Space>d8 :<C-U>call vimrc#denite#grep(vimrc#get_visual_selection(), 'grep', '', v:true)<CR>
nnoremap <Space>dm :Denite file_mru<CR>
nnoremap <Space>dM :Denite directory_mru<CR>
nnoremap <Space>do :execute 'Denite output:' . vimrc#escape_symbol(input('output: ', '', 'command'))<CR>
nnoremap <Space>dO :Denite outline<CR>
nnoremap <Space>d<C-O> :Denite unite:outline<CR>
nnoremap <Space>dp :call vimrc#denite#project_tags('')<CR>
nnoremap <Space>dP :call vimrc#denite#project_tags(expand('<cword>'))<CR>
nnoremap <Space>d<C-P> :Denite -auto-resume -auto-action=preview file/rec<CR>
nnoremap <Space>dq :Denite quickfix<CR>
nnoremap <Space>dr :Denite register<CR>
nnoremap <Space>ds :Denite session<CR>
nnoremap <Space>d<Space> :Denite source<CR>
nnoremap <Space>dt :Denite tag<CR>
nnoremap <Space>du :Denite -resume<CR>
nnoremap <Space>dU :Denite -resume -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
nnoremap <Space>d<C-U> :Denite -resume -refresh -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
nnoremap <Space>dy :Denite neoyank<CR>
nnoremap <Space>d: :Denite command_history<CR>
nnoremap <Space>d; :Denite command<CR>
nnoremap <Space>d/ :call vimrc#denite#grep('', 'grep', '', v:false)<CR>
nnoremap <Space>d? :call vimrc#denite#grep('', 'grep', input('Option: '), v:false)<CR>

nnoremap <silent> [d :Denite -resume -immediately -cursor-pos=-1<CR>
nnoremap <silent> ]d :Denite -resume -immediately -cursor-pos=+1<CR>
nnoremap <silent> [D :Denite -resume -immediately -cursor-pos=-1 -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>
nnoremap <silent> ]D :Denite -resume -immediately -cursor-pos=+1 -buffer-name=`vimrc#denite#get_buffer_name('grep')`<CR>

if executable('rg')
  nnoremap <Space>dg/ :call vimrc#denite#grep('', 'grep', vimrc#rg_current_type_option(), v:false)<CR>
  nnoremap <Space>dg? :call vimrc#denite#grep('', 'grep', "-g '" . input('glob: ') . "'", v:false)<CR>
endif
" }}}

" Denite buffer key mappings {{{
augroup denite_mappings
  autocmd!
  autocmd FileType denite        call vimrc#denite#mappings()
  autocmd FileType denite-filter call vimrc#denite#filter_mappings()
augroup END
" }}}
