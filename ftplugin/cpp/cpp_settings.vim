if exists('b:loaded_cpp_settings')
  finish
endif
let b:loaded_cpp_settings = 1

let b:AutoPairs = AutoPairsDefine({'\w\zs<' : '>'})
" Our vimrc#auto_pairs#jump()
let b:AutoPairsJumps = ['\w\zs>']
