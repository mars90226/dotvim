let s:fzf_preview_command = 'cat'
if executable('bat')
  let s:fzf_preview_command = 'bat --style=numbers --color=always'
endif
let s:fzf_dir_preview_command = 'ls -la --color=always'
if executable('exa')
  let s:fzf_dir_preview_command = 'exa -lag --color=always'
endif

function! vimrc#fzf#preview#get_command()
  return s:fzf_preview_command
endfunction
function! vimrc#fzf#preview#get_dir_command()
  return s:fzf_dir_preview_command
endfunction

function! vimrc#fzf#preview#windows() abort
  let options = fzf#vim#with_preview({ 'options': ['--prompt', 'Windows> '] })
  let preview_script = remove(options.options, -1)[0:-4]
  let get_filename_script = expand(vimrc#get_vimhome() . '/bin/fzf_windows_preview_get_file.sh')
  let get_buffer_script = expand(vimrc#get_vimhome() . '/bin/get_buffer.py')
  let file_script = 'FILE="$(' . get_filename_script . ' {})"'
  let tab_script = "TAB=\"$(echo {} | awk '{ print $1 }')\""
  let win_script = "WIN=\"$(echo {} | awk '{ print $2 }')\""
  let is_terminal_script = '[[ "$FILE" =~ ^term://.* ]]'
  let final_script = file_script . ';' .
        \ tab_script . ';' .
        \ win_script . ';' .
        \ 'if ' . is_terminal_script . '; then ' .
        \ get_buffer_script . ' "$TAB" "$WIN" "$FZF_PREVIEW_LINES" | ' . vimrc#fzf#preview#get_command() . ';' .
        \ 'else ' . preview_script . ' "$FILE";' .
        \ 'fi'

  call remove(options.options, -1) " remove --preview
  call extend(options.options, ['--preview', final_script])
  return options
endfunction

function! vimrc#fzf#preview#buffer_lines() abort
  let file = expand('%')
  let preview_command = vimrc#fzf#generate_preview_command_with_bat(1, file)

  return vimrc#fzf#with_default_options({ 'options': ['--preview-window', 'right:50%:hidden', '--preview', preview_command] })
endfunction

" Utility
let s:buffer_tags_preview_options = { 'placeholder': '{2}:{3}', 'options': ['-d', '\t'] }
function! vimrc#fzf#preview#buffer_tags_options(options)
  let preview_options = vimrc#fzf#preview#with_preview(s:buffer_tags_preview_options)
  let opts = has_key(a:options, 'options') ? remove(a:options, 'options') : ''
  let merged = extend(preview_options, a:options)
  call vimrc#fzf#merge_opts(merged, opts)

  return merged
endfunction

function! vimrc#fzf#preview#with_preview(...)
  " Borrored from fzf#wrap()
  let args = [{}, 0]
  let expects = map(copy(args), 'type(v:val)')
  let tidx = 0
  for arg in copy(a:000)
    let tidx = index(expects, type(arg), tidx)
    if tidx < 0
      throw 'Invalid arguments (expected: [opts dict] [fullscreen boolean])'
    endif
    let args[tidx] = arg
    let tidx += 1
    unlet arg
  endfor
  let [opts, bang] = args

  return bang ? fzf#vim#with_preview(opts, 'up:60%') : fzf#vim#with_preview(opts, 'right:50%:hidden', 'ctrl-/')
endfunction
