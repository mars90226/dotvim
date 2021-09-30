require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
    {'diagnostics', sources={'nvim_lsp', 'coc'}}},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'b:vista_nearest_method_or_function', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive', 'fzf', 'quickfix'}
}
