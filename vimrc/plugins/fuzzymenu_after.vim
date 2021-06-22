" Utility
call vimrc#fuzzymenu#try_add('ToggleFold', { 'exec': 'ToggleFold' })
call vimrc#fuzzymenu#try_add('ToggleIndent', { 'exec': 'ToggleIndent' })

" Terminal
call vimrc#fuzzymenu#try_add('SplitTerm', { 'exec' : 'new | terminal' })
call vimrc#fuzzymenu#try_add('TabTerm', { 'exec' : 'tabe | terminal' })
call vimrc#fuzzymenu#try_add('VerticalTerm', { 'exec' : 'vnew | terminal' })
