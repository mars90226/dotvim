local diffview_lib = require("diffview.lib")
local utils = require("vimrc.utils")

local diffview = {}

diffview.history_view = {}

local history_panel_get_item = function(history_panel, line)
  local comp = history_panel.components.comp:get_comp_on_line(line)
  if comp and (comp.name == "commit" or comp.name == "files") then
    local entry = comp.parent.context
    if comp.name == "files" then
      return entry.files[line - comp.lstart]
    end
    return entry
  end
end

local get_sha_from_item = function(item)
  return item.commit.hash
end

diffview.history_view.get_panel = function()
  return diffview_lib.get_current_view().panel
end

diffview.history_view.get_sha = function()
  local history_panel = diffview.history_view.get_panel()
  local item = history_panel:get_item_at_cursor()
  return get_sha_from_item(item)
end

diffview.history_view.get_visual_shas = function()
  local history_panel = diffview.history_view.get_panel()
  local range = { vim.fn.line("'<"), vim.fn.line("'>") }
  local visual_shas = utils.table_map(range, function(line)
    local item = history_panel_get_item(history_panel, line)
    return get_sha_from_item(item)
  end)

  return visual_shas
end

diffview.history_view.get_all_visual_shas = function()
  local history_panel = diffview.history_view.get_panel()
  local visual_shas = {}
  -- NOTE: Avoid duplicate sha as there's "file" type item with duplicate sha
  local visual_sha_map = {}

  for line = vim.fn.line("'<"), vim.fn.line("'>") do
    local item = history_panel_get_item(history_panel, line)
    local sha = get_sha_from_item(item)
    visual_sha_map[sha] = true
  end

  for key, _ in pairs(visual_sha_map) do
    visual_shas[#visual_shas+1] = key
  end

  return visual_shas
end

return diffview
