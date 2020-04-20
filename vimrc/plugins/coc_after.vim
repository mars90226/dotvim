" Common source
call coc#add_extension('coc-dictionary')
call coc#add_extension('coc-tag')
call coc#add_extension('coc-emoji')
call coc#add_extension('coc-syntax')
call coc#add_extension('coc-neosnippet')
call coc#add_extension('coc-emmet')
call coc#add_extension('coc-git')

" Language server
call coc#add_extension('coc-json')
call coc#add_extension('coc-tsserver')
call coc#add_extension('coc-python')
" Not work right now
" call coc#add_extension('coc-ccls')
call coc#add_extension('coc-rls')

call coc#config('languageserver', {
      \ 'ccls': {
      \   'command': 'ccls',
      \   'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
      \   'rootPatterns': [
      \     '.ccls',
      \     'compile_commands.json',
      \     '.git/',
      \     '.hg/'
      \   ],
      \  'initializationOptions': {
      \    'cache': {
      \      'directory': $HOME.'/.cache/ccls'
      \    },
      \    'client': {
      \      'snippetSupport': v:true
      \    },
      \    'index': {
      \      'threads': 2
      \    }
      \  }
      \ },
      \ 'phplang': {
      \   'command': 'php',
      \   'args': [$HOME.'/.config/composer/vendor/bin/php-language-server.php'],
      \   'filetypes': ['php']
      \ }
      \})

" Misc
call coc#add_extension('coc-prettier')
