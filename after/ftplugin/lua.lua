local choose = require("vimrc.choose")

if vim.b.loaded_lua_settings ~= nil then
  return
end

vim.b.loaded_lua_settings = true

vim.bo.keywordprg = ":help"

nmap("<Leader>dl", [[<Plug>(Luadev-RunLine)]], "buffer")
nmap("<Leader>dr", [[<Plug>(Luadev-Run)]], "buffer")
nmap("<Leader>dw", [[<Plug>(Luadev-RunWord)]], "buffer")
imap("<C-G><C-D>", [[<Plug>(Luadev-Complete)]], "buffer")

if choose.is_enabled_plugin("nvim-surround") then
  local surround = require("nvim-surround")
  local my_nvim_surround = require("vimrc.plugins.nvim_surround")

  -- NOTE: 2-characters cannot use default find & delete & change implementation
  surround.buffer_setup({
    surrounds = {
      ["s"] = my_nvim_surround.create_all("[[", "]]"),
    },
  })
end
