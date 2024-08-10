local defx = {}

defx.load_defx = function()
  require("lazy").load({ plugins = { "defx.nvim", "defx-git", "defx-icons" } })
end

return defx
