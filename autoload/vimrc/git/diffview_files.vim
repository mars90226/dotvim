" Functions
function! vimrc#git#diffview_files#visual_shas() abort
  return matchlist(getline('$'), '^\vcommit (\w{7})\.\.(\w{7})$')[1:2]
endfunction

function! vimrc#git#diffview_files#all_visual_shas() abort
  let visual_shas = vimrc#git#diffview_files#visual_shas()
  return systemlist('git rev-list '.visual_shas[0].'..'.visual_shas[1])
endfunction
