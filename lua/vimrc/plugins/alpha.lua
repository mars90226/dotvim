local alpha = {}

-- Ignore case that we don't want alpha start
alpha.start = function(on_vimenter)
  if vim.tbl_contains(vim.v.argv, "-S") then
    return
  end

  require("alpha").start(on_vimenter)
end

return alpha
