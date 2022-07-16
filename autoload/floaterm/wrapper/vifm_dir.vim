function! floaterm#wrapper#vifm_dir#(cmd, jobopts, config) abort
  let s:vifm_tmpfile = tempname()
  let original_dir = getcwd()
  lcd %:p:h

  let cmdlist = split(a:cmd)
  let cmd = 'vifm --choose-dir "' . s:vifm_tmpfile . '"'
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' "' . getcwd() . '"'
  endif

  exe "lcd " . original_dir
  let cmd = [&shell, &shellcmdflag, cmd]
  let jobopts = {'on_exit': funcref('s:vifm_dir_callback')}
  call floaterm#util#deep_extend(a:jobopts, jobopts)
  return [v:false, cmd]
endfunction

function! s:vifm_dir_callback(job, data, event, opener) abort
  if filereadable(s:vifm_tmpfile)
    let filenames = readfile(s:vifm_tmpfile)
    if !empty(filenames)
      if has('nvim')
        call floaterm#window#hide(bufnr('%'))
      endif
      let locations = []
      for filename in filenames
        let dict = {'filename': fnamemodify(filename, ':p')}
        call add(locations, dict)
      endfor
      " FIXME: Do nothing in cancel
      if len(locations) != 0
        call floaterm#util#open(locations, a:opener)
      endif
    endif
  endif
endfunction
