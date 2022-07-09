local choose = require("vimrc.choose")

local misc = {}

misc.setup = function()
  if vim.fn.has("python") == 0 and vim.fn.has("python3") == 0 then
    choose.disable_plugin("vim-mundo")
  end

  -- Choose highlight plugin
  -- builtin vim.highlight

  -- Disable vim-gutentags when in nested neovim
  if vim.fn["vimrc#plugin#check#nvim_terminal"]() == "yes" then
    choose.disable_plugin("vim-gutentags")
  end

  if vim.fn["vimrc#plugin#check#has_browser"]() == 0 then
    choose.disable_plugin("open-browser.vim")
  end

  -- Choose indent line plugin
  -- indent-blankline.nvim

  -- Choose window switching plugin
  -- nvim-window

  -- Choose colorizer plugin
  -- nvim-colorizer.lua
end

return misc
