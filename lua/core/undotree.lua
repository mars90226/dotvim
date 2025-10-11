local undotree = {}

undotree.setup = function()
  -- NOTE: Beta test builtin nvim.undotree plugin
  vim.cmd([[packadd nvim.undotree]])
end

return undotree
