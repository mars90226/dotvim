" Common source
" call coc#add_extension('coc-highlight')
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
call coc#add_extension('coc-pyright')
" Not work right now
" call coc#add_extension('coc-ccls')
" call coc#add_extension('coc-rls')
call coc#add_extension('coc-rust-analyzer')
call coc#add_extension('coc-vimlsp')
call coc#add_extension('coc-cmake')
call coc#add_extension('coc-css')
call coc#add_extension('coc-vetur')
call coc#add_extension('coc-solargraph')
call coc#add_extension('coc-perl')
call coc#add_extension('coc-go')
call coc#add_extension('coc-sumneko-lua')

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
      \    'highlight': {
      \      'lsRanges': v:true
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
      \ })

let coc_git_config = {}
if vimrc#plugin#is_enabled_plugin('coc-git-gutter')
  let coc_git_config.enableGutters = v:true
else
  let coc_git_config.enableGutters = v:false
endif
if vimrc#plugin#is_enabled_plugin('coc-git-blamer')
  let coc_git_config.addGBlameToVirtualText = v:true
else
  let coc_git_config.addGBlameToVirtualText = v:false
endif

call coc#config('git', coc_git_config)

" Misc
call coc#add_extension('coc-prettier')
