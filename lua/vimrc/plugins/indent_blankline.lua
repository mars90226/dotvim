local indent_blankline = {}

indent_blankline.setup = function()
  -- Currently, there's no way to differentiate tab and space.
  -- The only way to differentiate is to disable indent-blankline.nvim
  -- temporarily.
  nnoremap("<Space>il", ":IndentBlanklineToggle<CR>")
  nnoremap("<Space>ir", ":IndentBlanklineRefresh<CR>")

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
      "norg",
    },
    buftype_exclude = { "nofile", "terminal" },
    show_current_context = true,
    show_current_context_start = true,
  })
end

return indent_blankline
