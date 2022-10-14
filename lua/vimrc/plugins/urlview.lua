local search = require("urlview.search")
local search_helpers = require("urlview.search.helpers")
local utils = require("vimrc.utils")

local urlview = {}

urlview.extract_multi_pattern = function(content, capture, format)
  local captures = {}

  for _, match in ipairs(utils.gmatch_as_table(content, capture)) do
    table.insert(captures, string.format(format, unpack(match)))
  end

  return captures
end

urlview.generate_custom_search = function(pattern)
  if not pattern.multi_capture then
    return search_helpers.generate_custom_search(pattern)
  end

  return function(opts)
    local content = opts.content or search_helpers.get_buffer_content(opts.bufnr)
    return urlview.extract_multi_pattern(content, pattern.capture, pattern.format)
  end
end

urlview.setup_custom_search = function()
  -- TODO: Add custom search
end

urlview.setup_mapping = function()
  -- TODO: Add mapping
end

urlview.setup = function()
  urlview.setup_custom_search()
  urlview.setup_mapping()
end

return urlview
