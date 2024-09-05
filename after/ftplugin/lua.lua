local choose = require("vimrc.choose")

if vim.b.loaded_lua_settings ~= nil then
  return
end

vim.b.loaded_lua_settings = true

vim.bo.keywordprg = ":help"

vim.keymap.set("n", "<Leader>dl", [[<Plug>(Luadev-RunLine)]], { buffer = true, remap = true })
vim.keymap.set("n", "<Leader>dr", [[<Plug>(Luadev-Run)]], { buffer = true, remap = true })
vim.keymap.set("n", "<Leader>dw", [[<Plug>(Luadev-RunWord)]], { buffer = true, remap = true })
vim.keymap.set("i", "<C-G><C-D>", [[<Plug>(Luadev-Complete)]], { buffer = true, remap = true })

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
