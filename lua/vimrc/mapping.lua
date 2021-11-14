local mapping = {}

mapping.setup = function()
  vim.cmd [[command! HelptagsAll lua require('vimrc.utils').helptags_all()]]
end

return mapping
