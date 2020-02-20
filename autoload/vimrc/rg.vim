" Get rg current type option
" TODO Not 100% accurate pattern, increase accuracy
let s:type_pattern_options = {
      \ 'c-family':   ['\v\.%(c|cpp|h|hpp)$',                 '-tc -tcpp'],
      \ 'config':     ['\v\.%(cfg|conf|config|ini)$',         '-tconfig'],
      \ 'css':        ['\v\.%(css|scss)$',                    '-tcss'],
      \ 'csv':        ['\.csv$',                              '-tcsv'],
      \ 'go':         ['\.go$',                               '-tgo'],
      \ 'html':       ['\.html$',                             '-thtml'],
      \ 'javascript': ['\v\.%(js|jsx)$',                      '-tjs'],
      \ 'json':       ['\.json$',                             '-tjson'],
      \ 'log':        ['\.log$',                              '-tlog'],
      \ 'lua':        ['\.lua$',                              '-tlua'],
      \ 'perl':       ['\v\.%(pl|pm|t)$',                      '-tperl'],
      \ 'python':     ['\.py$',                               '-tpy'],
      \ 'ruby':       ['\v%(\.rb|Gemfile|Rakefile)$',         '-truby'],
      \ 'rust':       ['\.rs$',                               '-trust'],
      \ 'shell':      ['\v\.%(bash|bashrc|sh|bash_aliases)$', "-g '{*.sh,.bashrc,.bash_*}'"],
      \ 'sql':        ['\.sql$',                              '-tsql'],
      \ 'txt':        ['\.txt$',                              '-ttxt'],
      \ 'typescript': ['\.ts$',                               "-g '*.ts'"],
      \ 'vim':        ['\v%(\.vim|\.vimrc|_vimrc)$',          "-g '{*.vim,_vimrc}'"],
      \ 'yaml':       ['\v\.%(yaml|yml)$',                    '-tyaml'],
      \ 'wiki':       ['\.wiki$',                             '-twiki'],
      \ }

" TODO Use ripgrep type list
" TODO Change to global function?
" TODO Detect non-file buffer
function! vimrc#rg#current_type_option() abort
  let filename = expand('%:t')

  for [type, value] in items(s:type_pattern_options)
    let pattern = value[0]
    let option = value[1]
    if filename =~ pattern
      return option
    endif
  endfor

  return ''
endfunction
