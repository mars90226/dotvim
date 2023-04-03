local impatient = {}

impatient.startup = function(use)
  -- TODO: Monitor if any plugins break by module resolution cache
  use("lewis6991/impatient.nvim")
end

return impatient
