if exists('b:loaded_xml_settings')
  finish
endif
let b:loaded_xml_settings = 1

let b:AutoPairsJumps = ['>']

setlocal formatprg=rustfmt
