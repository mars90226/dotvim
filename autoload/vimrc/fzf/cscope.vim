" Sinks
" Borrowed from: https://gist.github.com/amitab/cd051f1ea23c588109c6cfcb7d1d5776
function! vimrc#fzf#cscope#cscope_sink(lines)
  if len(a:lines) < 2
    return
  end
  let cmd = vimrc#fzf#action_for(a:lines[0], 'edit')
  let qfl = []
  for result in a:lines[1:]
    let text = join(split(result)[1:])
    let [filename, line_number] = split(split(result)[0], ":")
    call add(qfl, {'filename': filename, 'lnum': line_number, 'text': text})
  endfor

  let first = qfl[0]
  execute cmd . ' +' . first.lnum . ' ' . first.filename
  normal! zzzv

  call vimrc#fzf#fill_quickfix(qfl)
endfunction

" Commands
function! vimrc#fzf#cscope#cscope(option, query)
  let color = '{ x = $1; $1 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s:\033[0m\011\033[37m%s\033[0m\n", x,z,$0; }'
  " TODO prompt for every cscope query type
  let opts = fzf#vim#with_preview({
        \ 'source':  "cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'",
        \ 'sink*': function('vimrc#fzf#cscope#cscope_sink'),
        \ 'options': ['--ansi', '--prompt', '> ',
        \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
        \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104',
        \             '--prompt', 'Cscope> ',
        \             '--expect=' . vimrc#fzf#expect_keys()]},
        \ 'right:50%:hidden', '?')
  call fzf#run(fzf#wrap('Cscope', opts))
endfunction

function! vimrc#fzf#cscope#cscope_query(option)
  call inputsave()
  if a:option == '0'
    let query = input('C Symbol: ')
  elseif a:option == '1'
    let query = input('Definition: ')
  elseif a:option == '2'
    let query = input('Functions called by: ')
  elseif a:option == '3'
    let query = input('Functions calling: ')
  elseif a:option == '4'
    let query = input('Text: ')
  elseif a:option == '6'
    let query = input('Egrep: ')
  elseif a:option == '7'
    let query = input('File: ')
  elseif a:option == '8'
    let query = input('Files #including: ')
  elseif a:option == '9'
    let query = input('Assignments to: ')
  else
    echo "Invalid option!"
    return
  endif
  call inputrestore()
  if query != ""
    call vimrc#fzf#cscope#cscope(a:option, query)
  else
    echomsg "Cancelled Search!"
  endif
endfunction
