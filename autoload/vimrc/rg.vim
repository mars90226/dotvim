" Get rg current type option
" TODO Not 100% accurate pattern, increase accuracy
let s:type_pattern_options = {
      \ 'c-family':   ['\v\.%(c|cpp|h|hpp)$',                 '-tc -tcpp'],
      \ 'cmake':      ['\v%(^CMakeLists\.txt|\.cmake)$',      '-tcmake'],
      \ 'config':     ['\v\.%(cfg|conf|config|ini)$',         '-tconfig'],
      \ 'css':        ['\v\.%(css|scss)$',                    '-tcss'],
      \ 'csv':        ['\.csv$',                              '-tcsv'],
      \ 'go':         ['\.go$',                               '-tgo'],
      \ 'html':       ['\.html$',                             '-thtml'],
      \ 'javascript': ['\v\.%(js|jsx)$',                      '-tjs'],
      \ 'json':       ['\.json$',                             '-tjson'],
      \ 'log':        ['\.log$',                              '-tlog'],
      \ 'lua':        ['\.lua$',                              '-tlua'],
      \ 'perl':       ['\v\.%(pl|pm|t)$',                     '-tperl'],
      \ 'php':        ['\v\.%(php|php[3-5]|phtml)$',          '-tphp'],
      \ 'python':     ['\.py$',                               '-tpy'],
      \ 'ruby':       ['\v%(\.rb|Gemfile|Rakefile)$',         '-truby'],
      \ 'rust':       ['\.rs$',                               '-trust'],
      \ 'shell':      ['\v\.%(bash|bashrc|sh|bash_aliases)$', "-g '{*.sh,.bashrc,.bash_*}'"],
      \ 'sql':        ['\.sql$',                              '-tsql'],
      \ 'txt':        ['\v(CMakeLists)\@<!\.txt$',            '-ttxt'],
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

  let rg_type_list = map(systemlist('rg --type-list'), { _, line -> split(line, ':')[0] })
  let rg_type_index = index(rg_type_list, &filetype)
  if rg_type_index >= 0
    return '-t'.rg_type_list[rg_type_index]
  endif

  return ''
endfunction
