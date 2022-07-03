require("indent_blankline").setup({
  char = "│",
  show_end_of_line = true,
  filetype_exclude = {
    "any-jump",
    "defx",
    "help",
    "fugitive",
    "git",
    "gitcommit",
    "gitrebase",
    "gitsendemail",
    "man",
  },
  buftype_exclude = { "nofile", "terminal" },
  show_current_context = true,
  show_current_context_start = true,
})
