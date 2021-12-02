" Variables
let s:pydoc_ftplugin_script_name = 'ftplugin/python_pydoc.vim'
let s:pydoc_ftplugin_functions = {}

function! vimrc#pydoc#get_pydoc_ftplugin_snr() abort
  if !exists('s:pydoc_ftplugin_snr')
    let s:pydoc_ftplugin_snr = vimrc#utility#get_script_id(s:pydoc_ftplugin_script_name)
  endif

  return s:pydoc_ftplugin_snr
endfunction

function! vimrc#pydoc#get_pydoc_ftplugin_function(function_name) abort
  if !has_key(s:pydoc_ftplugin_functions, a:function_name)
    let s:pydoc_ftplugin_functions[a:function_name] = vimrc#utility#get_script_function(vimrc#pydoc#get_pydoc_ftplugin_snr(), a:function_name)
  endif

  return s:pydoc_ftplugin_functions[a:function_name]
endfunction

function! vimrc#pydoc#show_pydoc(name, type) abort
  let ShowPyDoc = vimrc#pydoc#get_pydoc_ftplugin_function('ShowPyDoc')
  return ShowPyDoc(a:name, a:type)
endfunction

function! vimrc#pydoc#replace_module_alias() abort
  let ReplaceModuleAlias = vimrc#pydoc#get_pydoc_ftplugin_function('ReplaceModuleAlias')
  return ReplaceModuleAlias()
endfunction
