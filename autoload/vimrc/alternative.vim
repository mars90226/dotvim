" Settings
function! vimrc#alternative#settings()
  " ReactJS
  let g:alternateExtensionsDict['javascript.jsx'] = {}
  let g:alternateExtensionsDict['javascript.jsx']['js'] = 'css,scss'
  let g:alternateExtensionsDict['css'] = {}
  let g:alternateExtensionsDict['css']['css'] = 'js'
  let g:alternateExtensionsDict['scss'] = {}
  let g:alternateExtensionsDict['scss']['scss'] = 'js'
endfunction
