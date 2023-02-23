vim.b.AutoPairsJumps = { [[\w\zs>]] }

-- Clangd
nnoremap("<M-`>", [[<Cmd>ClangdSwitchSourceHeader<CR>]], "<silent>", "<buffer>")
