" FIXME Not working
" call textobj#user#plugin('surroundunicode', {
"       \ 'surroundunicode': {
"       \   'pattern': ['[^\x00-\x7F]', '[^\x00-\x7F]'],
"       \   'select-a': 'au',
"       \   'select-i': 'iu',
"       \ },
"       \ })

call textobj#user#plugin('comment', {
     \   '-': {
     \     'select-a-function': 'textobj#comment#select_a',
     \     'select-a': 'am',
     \     'select-i-function': 'textobj#comment#select_i',
     \     'select-i': 'im',
     \   },
     \   'big': {
     \     'select-a-function': 'textobj#comment#select_big_a',
     \     'select-a': 'aM',
     \   }
     \ })
