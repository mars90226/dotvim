" Functions
function! vimrc#git#diffview_buffer#sha() abort
  " diffview buffer pattern: "^diffview/(\d+_)?(\w{7})_.*$"
  "                                     ^index ^sha    ^filename
  return matchlist(bufname(), '^\vdiffview/%(\d+_)?(\w{7})_.*$')[1]
endfunction
