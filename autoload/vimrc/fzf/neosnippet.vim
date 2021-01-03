" Borrowed from fzf.vim

" Source
function! vimrc#fzf#neosnippet#neosnippet_source() abort
  let snippets = neosnippet#helpers#get_snippets('i')
  return map(snippets, { _, snippet -> snippet.description })
endfunction

" Sink
function! vimrc#fzf#neosnippet#neosnippet_sink(line) abort
  let snip = split(a:line, "\t")[0]
  execute 'normal a'.vimrc#fzf#strip(snip)."\<Plug>(neosnippet_expand_or_jump)"
endfunction

" Intend to be mapped in insert mode
function! vimrc#fzf#neosnippet#neosnippet_in_insert_mode_sink(results, line) abort
  let snip = split(a:line, "\t")[0]
  call add(a:results, vimrc#fzf#strip(snip)."\<Plug>(neosnippet_expand_or_jump)")
endfunction

" Commands
function! vimrc#fzf#neosnippet#neosnippet() abort
  if exists(':NeoSnippetEdit') != 2
    return vimrc#utility#warn('Neosnippet not found')
  endif
  let list = vimrc#fzf#neosnippet#neosnippet_source()
  if empty(list)
    return vimrc#utility#warn('No snippets available here')
  endif
  let aligned = sort(vimrc#fzf#align_lists(items(list)))
  let colored = map(aligned, 'vimrc#fzf#yellow(v:val[0])."\t".v:val[1]')
  return vimrc#fzf#fzf('Neosnippets', {
        \ 'source':  colored,
        \ 'options': '--ansi --tiebreak=index +m -n 1 -d "\t" --prompt "Neosnippets> "',
        \ 'sink':    function('vimrc#fzf#neosnippet#neosnippet_sink')}, a:000)
endfunction

" Intend to be mapped in insert mode
function! vimrc#fzf#neosnippet#neosnippet_in_insert_mode() abort
  if exists(':NeoSnippetEdit') != 2
    return vimrc#utility#warn('Neosnippet not found')
  endif
  let list = vimrc#fzf#neosnippet#neosnippet_source()
  if empty(list)
    return vimrc#utility#warn('No snippets available here')
  endif
  let aligned = sort(vimrc#fzf#align_lists(items(list)))
  let colored = map(aligned, 'vimrc#fzf#yellow(v:val[0])."\t".v:val[1]')
  let results = []
  " FIXME Use tmux because of opening popup in insert mode conflict with
  " neovim floating window and cause serious error that need to restart neovim
  call vimrc#fzf#fzf('Neosnippets', extend({
        \ 'source':  colored,
        \ 'options': '--ansi --tiebreak=index +m -n 1 -d "\t" --prompt "Neosnippets> "',
        \ 'sink':    function('vimrc#fzf#neosnippet#neosnippet_in_insert_mode_sink', [results])}, g:fzf_tmux_layout), a:000)
  return get(results, 0, '')
endfunction
