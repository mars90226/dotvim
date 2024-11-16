" Variables
let s:fzf_preview_command = 'cat'
if v:lua.require('vimrc.plugin_utils').is_executable('bat')
  let s:fzf_preview_command = 'bat --style=numbers --color=always'
endif
let s:fzf_dir_preview_command = 'ls -la --color=always'
if v:lua.require('vimrc.plugin_utils').is_executable('eza')
  let s:fzf_dir_preview_command = 'eza -lag --color=always'
endif

let s:fzf_preview_toggle_key = 'ctrl-/'
let s:fzf_preview_default_layout = 'right:50%'
let s:fzf_preview_option_layout = s:fzf_preview_default_layout.':hidden'
let s:fzf_preview_bang_layout = 'right:50%'

function! vimrc#fzf#preview#get_command() abort
  return s:fzf_preview_command
endfunction
function! vimrc#fzf#preview#get_dir_command() abort
  return s:fzf_dir_preview_command
endfunction
function! vimrc#fzf#preview#get_preview_toggle_key() abort
  return s:fzf_preview_toggle_key
endfunction
function! vimrc#fzf#preview#get_preview_default_layout() abort
  return s:fzf_preview_default_layout
endfunction
function! vimrc#fzf#preview#get_preview_script() abort
  " Can only setup variable after loading fzf.vim
  if !exists('s:fzf_preview_script')
    let s:fzf_default_preview_options = fzf#vim#with_preview()
    " preview script should be the next option after '--preview'
    let s:fzf_preview_script = s:fzf_default_preview_options.options[index(s:fzf_default_preview_options.options, '--preview') + 1][0:-4]
  endif

  return s:fzf_preview_script
endfunction

function! vimrc#fzf#preview#windows() abort
  let options = fzf#vim#with_preview({ 'options': ['--prompt', 'Windows> '] })
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
        \ 'else ' . vimrc#fzf#preview#get_preview_script() . ' "$FILE";' .
        \ 'fi'

  call extend(options.options, ['--preview', final_script])
  return options
endfunction

function! vimrc#fzf#preview#buffer_lines(...) abort
  let query = a:0 > 0 && type(a:1) == type('') ? a:1 : ''
  let file = expand('%')
  let preview_command = vimrc#fzf#generate_preview_command_with_bat(1, file)
  let options = { 'options': ['--preview-window', 'right:50%:hidden', '--preview', preview_command] }
  if !empty(query)
    let options.options += ['--query', query]
  endif

  return vimrc#fzf#with_default_options(options)
endfunction

" Utility
let s:buffer_tags_preview_options = { 'placeholder': '{2}:{3}', 'options': ['-d', '\t'] }
function! vimrc#fzf#preview#buffer_tags_options(options) abort
  let preview_options = vimrc#fzf#preview#with_preview(s:buffer_tags_preview_options)
  let opts = has_key(a:options, 'options') ? remove(a:options, 'options') : ''
  let merged = extend(preview_options, a:options)
  call vimrc#fzf#merge_opts(merged, opts)

  return merged
endfunction

function! vimrc#fzf#preview#with_preview(...) abort
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

  return bang ? fzf#vim#with_preview(opts, s:fzf_preview_bang_layout) : fzf#vim#with_preview(opts, s:fzf_preview_default_layout, vimrc#fzf#preview#get_preview_toggle_key())
endfunction
