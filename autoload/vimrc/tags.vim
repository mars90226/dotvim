" Functions
function! vimrc#tags#use_project_tags() abort
  let origin_tags = &tags

  set tags-=./tags;
  if exists('b:project_tags_excludes')
    for project_tags_exclude in b:project_tags_excludes
      " Use set option to remove project_tags from array-like string option
      " Instead of using split & join to remove option
      execute 'set tags-='.project_tags_exclude
    endfor
  endif

  return origin_tags
endfunction

function! vimrc#tags#restore_tags(backup) abort
  let &tags = a:backup
endfunction
