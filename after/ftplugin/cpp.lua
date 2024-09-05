vim.b.AutoPairsJumps = { [[\w\zs>]] }

-- Clangd
vim.keymap.set("n", "<M-`>", [[<Cmd>ClangdSwitchSourceHeader<CR>]], { silent = true, buffer = true})
