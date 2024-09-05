vim.fn["vimrc#quickfix#mappings"]()

-- Qfreplace
vim.keymap.set("n", "r", [[:<C-U>Qfreplace<CR>]], { silent = true, buffer = true})
