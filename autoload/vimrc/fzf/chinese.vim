" Script Encoding: UTF-8
scriptencoding utf-8

" Config
let s:chinese_punctuations = {
      \ 'comma': '，',
      \ 'full_stop': '。',
      \ 'enumeration_comma': '、',
      \ 'colon': '：',
      \ 'semicolon': '；',
      \ 'exclamation_mark': '！',
      \ 'question_mark': '？',
      \ }

" Sources
function! vimrc#fzf#chinese#punctuations_source()
  return s:chinese_punctuations
endfunction

" Sinks
function! vimrc#fzf#chinese#punctuations_sink(line)
  let punctuation = split(a:line, "\t")[1]
  execute 'normal! a'.punctuation
endfunction

" Intend to be mapped in insert mode
function! vimrc#fzf#chinese#punctuations_in_insert_mode_sink(results, line)
  let punctuation = split(a:line, "\t")[1]
  call add(a:results, punctuation)
endfunction

" Commands
function! vimrc#fzf#chinese#punctuations()
  let list = vimrc#fzf#chinese#punctuations_source()
  if empty(list)
    return vimrc#utility#warn('No snippets available here')
  endif
  let aligned = sort(vimrc#fzf#align_lists(items(list)))
  let colored = map(aligned, 'vimrc#fzf#yellow(v:val[0])."\t".v:val[1]')

  return vimrc#fzf#fzf('Punctuations', {
        \ 'source': colored,
        \ 'sink': function('vimrc#fzf#chinese#punctuations_sink'),
        \ 'options': ['--ansi', '--tiebreak=index', '+m', '-n', '1', '-d', "\t", '--prompt', 'Punctuations> ']}, a:000)
endfunction

" Intend to be mapped in insert mode
function! vimrc#fzf#chinese#punctuations_in_insert_mode()
  let list = vimrc#fzf#chinese#punctuations_source()
  if empty(list)
    return vimrc#utility#warn('No snippets available here')
  endif
  let aligned = sort(vimrc#fzf#align_lists(items(list)))
  let colored = map(aligned, 'vimrc#fzf#yellow(v:val[0])."\t".v:val[1]')

  let results = []
  " FIXME Use tmux because of opening popup in insert mode conflict with
  " neovim floating window and cause serious error that need to restart neovim
  call vimrc#fzf#fzf('Punctuations', extend({
        \ 'source': colored,
        \ 'sink': function('vimrc#fzf#chinese#punctuations_in_insert_mode_sink', [results]),
        \ 'options': ['--ansi', '--tiebreak=index', '+m', '-n', '1', '-d', "\t", '--prompt', 'Punctuations> ']}, g:fzf_tmux_layout), a:000)
  return get(results, 0, '')
endfunction
