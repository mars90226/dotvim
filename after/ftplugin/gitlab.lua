local gitlab = require("vimrc.plugins.gitlab")

vim.keymap.set("n", "gm", function() gitlab.minimize_discussion() end, { silent = true, buffer = true, desc = "Minimize Gitlab.nvim discussion panel width" })
vim.keymap.set("n", "gr", function() gitlab.reset_discussion() end, { silent = true, buffer = true, desc = "Reset Gitlab.nvim discussion panel width" })
vim.keymap.set("n", "J", [[<Cmd>call search('[] @')<CR>]], { buffer = true, desc = "Go to next node" })
vim.keymap.set("n", "K", [[<Cmd>call search('[] @', 'b')<CR>]], { buffer = true, desc = "Go to previous node" })
