if exists('b:loaded_cpp_settings')
  finish
endif
let b:loaded_cpp_settings = 1

if vimrc#plugin#is_enabled_plugin('auto-pairs')
  let b:AutoPairs = AutoPairsDefine({'\w\zs<' : '>'})
endif

" Our vimrc#auto_pairs#jump()
let b:AutoPairsJumps = ['\w\zs>']
