let s:defx_fzf_action = extend({
      \ 'enter':      'DefxOpenSink',
      \ 'ctrl-t':     'DefxTabOpenSink',
      \ 'ctrl-s':     'DefxSplitOpenSink',
      \ 'ctrl-x':     'DefxSplitOpenSink',
      \ 'ctrl-v':     'DefxVSplitOpenSink',
      \ 'alt-v':      'DefxRightVSplitOpenSink',
      \ 'alt-x':      'DefxOpenDirSink',
      \ 'ctrl-alt-x': 'DefxSplitOpenDirSink',
      \ 'alt-z':      'VimrcFloatNew DefxOpenSink',
      \ }, g:misc_fzf_action)
function! vimrc#fzf#defx#get_defx_fzf_action()
  return s:defx_fzf_action
endfunction

" TODO: This may be removed as Defx folder detection is added in augroup
" defx_detect_folder
" TODO s:common_sink() in fzf/plugin/fzf.vim will always use 'edit' if it
" think the current file is empty file. It's hard to workaround the check
" and still does not interfere other things like buffer list.
function! vimrc#fzf#defx#use_defx_fzf_action(function)
  let g:fzf_action = s:defx_fzf_action
  augroup use_defx_fzf_action_callback
    autocmd!
    autocmd TermClose term://*fzf*
          \ let g:fzf_action = g:default_fzf_action |
          \ autocmd! use_defx_fzf_action_callback
  augroup END
  call a:function()
endfunction
