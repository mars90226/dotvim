" Here is the place for config/script to use plugin autoload functions
" TODO Move all plugin settings to post-loaded settings

" Colors {{{
" NOTE: Set colorscheme before statusline & tabline to avoid loading wrong
" colors in statusline & tabline
execute 'colorscheme '.g:colorscheme
" }}}

" lualine.nvim {{{
if vimrc#plugin#is_enabled_plugin('lualine.nvim')
  lua require('vimrc.plugins.lualine')
endi
" }}}

" tabby.nvim {{{
if vimrc#plugin#is_enabled_plugin('tabby.nvim')
  lua require('vimrc.plugins.tabby')
endif
" }}}

" tabline.nvim {{{
if vimrc#plugin#is_enabled_plugin('tabline.nvim')
  lua require('vimrc.plugins.tabline')
endif
" }}}

" coc.nvim {{{
if vimrc#plugin#is_enabled_plugin('coc.nvim')
  call vimrc#source('vimrc/plugins/coc_after.vim')
endif
" }}}

" nvim-autopairs {{{
if vimrc#plugin#is_enabled_plugin('nvim-autopairs')
lua << EOF
  require('nvim-autopairs').setup{
    check_ts = vim.fn['vimrc#plugin#is_enabled_plugin']('nvim-treesitter') == 1,
    fast_wrap = {},
  }
EOF
endif
" }}}

" nvim-lsp {{{
if vimrc#plugin#is_enabled_plugin('nvim-lsp')
  lua require('vimrc.plugins.nvim_lsp')
endif
" }}}

" Denite {{{
if vimrc#plugin#is_enabled_plugin('denite.nvim')
  call vimrc#source('vimrc/plugins/denite_after.vim')
endif
" }}}

" telescope.nvim {{{
if vimrc#plugin#is_enabled_plugin('telescope.nvim')
  lua require('vimrc.plugins.telescope')
endif
" }}}

" Defx {{{
if vimrc#plugin#is_enabled_plugin('defx.nvim')
  call vimrc#source('vimrc/plugins/defx_after.vim')
endif
" }}}

" vim-matchup {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
lua << EOF
  require'nvim-treesitter.configs'.setup {
    matchup = {
      enable = true,              -- mandatory, false will disable the whole extension
    },
  }
EOF
endif
" }}}

" hop.nvim {{{
if vimrc#plugin#is_enabled_plugin('hop.nvim')
  lua require'hop'.setup{}
endif
" }}}

" vim-sandwich {{{
call vimrc#source('vimrc/plugins/sandwich_after.vim')
" }}}

" nvim-treesitter {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter')
  lua require('vimrc.plugins.nvim_treesitter')
endif
" }}}

" nvim-treesitter-contex {{{
if vimrc#plugin#is_enabled_plugin('nvim-treesitter-context')
lua << EOF
  require'treesitter-context.config'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  }
EOF
endif
" }}}

" gitsigns.nvim {{{
if vimrc#plugin#is_enabled_plugin('gitsigns.nvim')
  lua require('vimrc.plugins.gitsigns')
endif
" }}}

" vim-textobj-user {{{
call vimrc#source('vimrc/plugins/textobj_user_after.vim')
" }}}

" indent-blankline.nvim {{{
if vimrc#plugin#is_enabled_plugin('indent-blankline.nvim')
  lua require('vimrc.plugins.indent_blankline')
endif
" }}}

" nvim-colorizer.lua {{{
if vimrc#plugin#is_enabled_plugin('nvim-colorizer.lua')
  set termguicolors

  lua require'colorizer'.setup()
endif
" }}}

" fuzzymenu {{{
call vimrc#source('vimrc/plugins/fuzzymenu_after.vim')
" }}}
