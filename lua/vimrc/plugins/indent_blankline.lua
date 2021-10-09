require('indent_blankline').setup {
  char = "│",
  -- space_char_blankline = '·',
  space_char_blankline = ' ',
  filetype_exclude = {"any-jump", "clap", "defx", "help", "fugitive", "git", "gitcommit", "gitrebase", "gitsendemail", "man"},
  buftype_exclude = {"nofile", "terminal"},
  show_current_context = true,
}
