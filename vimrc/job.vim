" This file is for commands that use Neovim's job API

if has('nvim')
  let g:execute_prefix        = '<Leader>x'
  let g:open_url_prefix       = '<Leader>b'
  let g:search_keyword_prefix = '<Leader>k'

  let g:browser_maps = {
        \ 'OpenUrl':             ['current', 'open_url',       g:open_url_prefix,       'b'],
        \ 'SearchKeyword':       ['current', 'search_keyword', g:search_keyword_prefix, 'k'],
        \ 'ClientOpenUrl':       ['client',  'open_url',       g:open_url_prefix,       'c'],
        \ 'ClientSearchKeyword': ['client',  'search_keyword', g:search_keyword_prefix, 'c'],
        \ }
  let g:search_engine_maps = {
        \ 'SearchKeywordDdg':           ['current', 'duckduckgo', g:search_keyword_prefix, 'd'],
        \ 'SearchKeywordDevDocs':       ['current', 'devdocs',    g:search_keyword_prefix, 'e'],
        \ 'ClientSearchKeywordDdg':     ['client',  'duckduckgo', g:search_keyword_prefix, 'v'],
        \ 'ClientSearchKeywordDevDocs': ['client',  'devdocs',    g:search_keyword_prefix, 'b'],
        \ }

  " Asynchronous open URI
  if has('unix') && executable('xdg-open')
    " Required by fugitive :GBrowse
    call vimrc#browser#define_command('Browse', 'vimrc#browser#async_open', g:execute_prefix, 'x')
  endif

  for [command, definition] in items(g:browser_maps)
    let browser = definition[0]
    let type    = definition[1]
    let prefix  = definition[2]
    let suffix  = definition[3]

    call vimrc#browser#define_command(command, browser, type, prefix, suffix)
  endfor

  for [command, definition] in items(g:search_engine_maps)
    let browser       = definition[0]
    let search_engine = definition[1]
    let prefix        = definition[2]
    let suffix        = definition[3]

    call vimrc#search_engine#define_command(command, browser, search_engine, prefix, suffix)
  endfor
endif
