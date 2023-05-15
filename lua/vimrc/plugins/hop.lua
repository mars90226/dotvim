local origin_hop = require('hop')

local hop = {}

hop.search_patterns = function(opts, pattern_type)
  local pattern = vim.fn['vimrc#search#get_pattern'](pattern_type)
  origin_hop.hint_patterns(opts, pattern)
end

return hop
