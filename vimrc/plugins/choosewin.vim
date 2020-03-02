" " seoul256 colors
" let g:choosewin_color_label_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
" let g:choosewin_color_label = { 'gui': ['#719872', ''], 'cterm': [65, 0] }
" let g:choosewin_color_other = { 'gui': ['#757575', '#BFBFBF'], 'cterm': [241, 249] }
" let g:choosewin_color_overlay_current = { 'gui': ['#7FBF00', '#121813'], 'cterm': [10, 15, 'bold'] }
" let g:choosewin_color_overlay = { 'gui': ['#007173', '#DEDFBD'], 'cterm': [23, 187, 'bold'] }

" gruvbox
let g:choosewin_color_label_current = { 'gui': ['#b8bb26', '#282828'], 'cterm': [142, 235, 'bold'] }
let g:choosewin_color_label = { 'gui': ['#83a598', '#282828'], 'cterm': [108, 234] }
let g:choosewin_color_other = { 'gui': ['#504945', '#ebdbb2'], 'cterm': [241, 249] }
let g:choosewin_color_overlay_current = { 'gui': ['#b8bb26', '#282828'], 'cterm': [142, 235, 'bold'] }
let g:choosewin_color_overlay = { 'gui': ['#83a598', '#ebdbb2'], 'cterm': [23, 187, 'bold'] }
let g:choosewin_color_land = { 'gui': ['#b8bb26', '#282828'], 'cterm': [142, 235, 'bold'] }

let g:choosewin_overlay_enable = 1
let g:choosewin_blink_on_land = 1

nmap =- <Plug>(choosewin)
