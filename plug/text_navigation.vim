" Match {{{
" vim-matchup {{{
Plug 'andymass/vim-matchup'

nnoremap <Leader>mk :<C-U>MatchupWhereAmI?<CR>
" }}}
" }}}

" EasyMotion {{{
Plug 'easymotion/vim-easymotion', { 'on': [] }

call vimrc#lazy#lazy_load('easymotion')

let g:EasyMotion_leader_key = '<Space>'
let g:EasyMotion_smartcase = 1

map ;        <Plug>(easymotion-s2)
map <Space>; <Plug>(easymotion-sn)

map \w <Plug>(easymotion-bd-wl)
map \f <Plug>(easymotion-bd-fl)
map \s <Plug>(easymotion-sl2)

map <Space><Space>f <Plug>(easymotion-bd-f)
map <Space><Space>l <Plug>(easymotion-bd-jk)
map <Space><Space>t <Plug>(easymotion-bd-t)
map <Plug>(easymotion-prefix)s <Plug>(easymotion-bd-f2)
map <Plug>(easymotion-prefix)w <Plug>(easymotion-bd-w)
map <Plug>(easymotion-prefix)W <Plug>(easymotion-bd-W)
map <Plug>(easymotion-prefix)e <Plug>(easymotion-bd-e)
map <Plug>(easymotion-prefix)E <Plug>(easymotion-bd-E)

nmap <Leader>' <Plug>(easymotion-next)
nmap <Leader>; <Plug>(easymotion-prev)
nmap <Leader>. <Plug>(easymotion-repeat)

map <Plug>(easymotion-prefix)J <Plug>(easymotion-eol-j)
map <Plug>(easymotion-prefix)K <Plug>(easymotion-eol-k)

map <Plug>(easymotion-prefix); <Plug>(easymotion-jumptoanywhere)
" }}}

" hop.nvim {{{
if vimrc#plugin#is_enabled_plugin('hop.nvim')
  Plug 'phaazon/hop.nvim'

  map <Space>w        <Cmd>HopWord<CR>
  map <Space>;        <Cmd>HopPattern<CR>
  map <Space><Space>f <Cmd>HopChar1<CR>
  map ;               <Cmd>HopChar2<CR>
  map <Space><Space>l <Cmd>HopLine<CR>
  map <Space>j        <Cmd>HopLineAC<CR>
  map <Space>k        <Cmd>HopLineBC<CR>
endif
" }}}

" lightspeed.nvim {{{
if vimrc#plugin#is_enabled_plugin('lightspeed.nvim')
  Plug 'ggandor/lightspeed.nvim'

  map ;     <Plug>Lightspeed_s
  map <M-;> <Plug>Lightspeed_S
endif
" }}}

" aerojump.nvim {{{
if vimrc#plugin#is_enabled_plugin('aerojump.nvim')
  Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }

  let g:aerojump_keymaps = {
        \ '<Esc>': 'AerojumpExit',
        \ '<C-C>': 'AerojumpExit',
        \ '<Tab>': 'AerojumpSelNext',
        \ '<S-Tab>': 'AerojumpSelPrev',
        \ }

  nmap <Space>as <Plug>(AerojumpSpace)
  nmap <Space>ab <Plug>(AerojumpBolt)
  nmap <Space>aa <Plug>(AerojumpFromCursorBolt)
  nmap <Space>ad <Plug>(AerojumpDefault)
  nmap <Space>am <Plug>(AerojumpMilk)
endif
" }}}

" Search {{{
" vim-asterisk {{{
Plug 'haya14busa/vim-asterisk'
" }}}

" nvim-hlslens {{{
if vimrc#plugin#is_enabled_plugin('nvim-hlslens')
  Plug 'kevinhwang91/nvim-hlslens'

  map *   <Plug>(asterisk-*)<Cmd>lua require('hlslens').start()<CR>
  map #   <Plug>(asterisk-#)<Cmd>lua require('hlslens').start()<CR>
  map g*  <Plug>(asterisk-g*)<Cmd>lua require('hlslens').start()<CR>
  map g#  <Plug>(asterisk-g#)<Cmd>lua require('hlslens').start()<CR>
  map z*  <Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>
  map gz* <Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>
  map z#  <Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>
  map gz# <Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>
endif
" }}}

" incsearch.vim {{{
if vimrc#plugin#is_enabled_plugin('incsearch.vim')
  Plug 'haya14busa/incsearch.vim'

  " :h g:incsearch#auto_nohlsearch
  let g:incsearch#auto_nohlsearch = 1

  map n  <Plug>(incsearch-nohl-n)
  map N  <Plug>(incsearch-nohl-N)

  " vim-asterisk
  map *   <Plug>(incsearch-nohl)<Plug>(asterisk-*)
  map #   <Plug>(incsearch-nohl)<Plug>(asterisk-#)
  map g*  <Plug>(incsearch-nohl)<Plug>(asterisk-g*)
  map g#  <Plug>(incsearch-nohl)<Plug>(asterisk-g#)
  map z*  <Plug>(incsearch-nohl0)<Plug>(asterisk-z*)
  map gz* <Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)
  map z#  <Plug>(incsearch-nohl0)<Plug>(asterisk-z#)
  map gz# <Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)

  " For original search incase need to insert special characters like NULL
  nnoremap <Leader><Leader>/ /
  nnoremap <Leader><Leader>? ?

  map /  <Plug>(incsearch-forward)
  map ?  <Plug>(incsearch-backward)
  map g/ <Plug>(incsearch-stay)

  " Search within visual selection
  xmap <M-/> <Esc><Plug>(incsearch-forward)\%V
  xmap <M-?> <Esc><Plug>(incsearch-backward)\%V

  augroup incsearch_settings
    autocmd!
    autocmd BufWinLeave,WinLeave * call vimrc#incsearch#clear_nohlsearch()
  augroup END

  command! ClearIncsearchAutoNohlsearch call vimrc#incsearch#clear_auto_nohlsearch()

  " incsearch-fuzzy {{{
  Plug 'haya14busa/incsearch-fuzzy.vim'

  map z/  <Plug>(incsearch-fuzzy-/)
  map z?  <Plug>(incsearch-fuzzy-?)
  map zg/ <Plug>(incsearch-fuzzy-stay)
  " }}}

  " incsearch-easymotion {{{
  Plug 'haya14busa/incsearch-easymotion.vim'

  map <Leader>/  <Plug>(incsearch-easymotion-/)
  map <Leader>?  <Plug>(incsearch-easymotion-?)
  map <Leader>g/ <Plug>(incsearch-easymotion-stay)
  " }}}

  " incsearch.vim x fuzzy x vim-easymotion {{{
  noremap <silent><expr> \/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
  noremap <silent><expr> Z/ incsearch#go(vimrc#incsearch#config_easyfuzzymotion())
" }}}
endif
" }}}
" }}}

" CamelCaseMotion {{{
Plug 'bkad/CamelCaseMotion'

map <Leader>mw <Plug>CamelCaseMotion_w
map <Leader>mb <Plug>CamelCaseMotion_b
map <Leader>me <Plug>CamelCaseMotion_e
map <Leader>mge <Plug>CamelCaseMotion_ge

omap <silent> imw <Plug>CamelCaseMotion_iw
xmap <silent> imw <Plug>CamelCaseMotion_iw
omap <silent> imb <Plug>CamelCaseMotion_ib
xmap <silent> imb <Plug>CamelCaseMotion_ib
omap <silent> ime <Plug>CamelCaseMotion_ie
xmap <silent> ime <Plug>CamelCaseMotion_ie
" }}}

" vim-edgemotion {{{
Plug 'haya14busa/vim-edgemotion'

map <Space><Space>j <Plug>(edgemotion-j)
map <Space><Space>k <Plug>(edgemotion-k)
" }}}

" vim-indentwise {{{
Plug 'jeetsukumaran/vim-indentwise', { 'on': [] }

call vimrc#lazy#lazy_load('indentwise')
" }}}
