if vim.b.loaded_lua_settings ~= nil then
  return
end

vim.b.loaded_lua_settings = true

vim.bo.keywordprg = ":help"

nmap("<Leader>dl", [[<Plug>(Luadev-RunLine)]], "buffer")
nmap("<Leader>dr", [[<Plug>(Luadev-Run)]], "buffer")
nmap("<Leader>dw", [[<Plug>(Luadev-RunWord)]], "buffer")
imap("<C-G><C-D>", [[<Plug>(Luadev-Complete)]], "buffer")
