" Functions
function! vimrc#git#diffview_history#sha() abort
  return v:lua.require('vimrc.plugins.diffview').history_view.get_sha()
endfunction

function! vimrc#git#diffview_history#visual_shas() abort
  return v:lua.require('vimrc.plugins.diffview').history_view.get_visual_shas()
endfunction

function! vimrc#git#diffview_history#all_visual_shas() abort
  return v:lua.require('vimrc.plugins.diffview').history_view.get_all_visual_shas()
endfunction
