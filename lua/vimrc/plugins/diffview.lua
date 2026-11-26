local diffview_lib = require("diffview.lib")
local utils = require("vimrc.utils")

local diffview = {}

function diffview.open_other_diff()
  local view = diffview_lib.get_current_view()
  local DiffView = require("diffview.scene.views.diff.diff_view").DiffView
  if not (view and view:instanceof(DiffView)) then
    vim.cmd.Other()
    return
  end

  local current = view:infer_cur_file()
  if not current then
    vim.notify("No file selected in Diffview", vim.log.levels.WARN)
    return
  end

  local other = require("other-nvim")
  local other_paths = {}
  for _, match in ipairs(other.findOther(current.absolute_path)) do
    -- A deleted file can still have a diff even when other.nvim marks it missing.
    other_paths[match.filename] = true
  end

  -- Resolve wildcard targets against this diff as well as the working tree.
  local wildcard_targets =
    require("vimrc.plugins.other").wildcard_target_patterns(current.absolute_path, other.getOptions())
  local entries = {}
  for _, entry in view.files:iter() do
    if
      other_paths[entry.absolute_path]
      or vim.iter(wildcard_targets):any(function(pattern)
        return entry.absolute_path:match(pattern) ~= nil
      end)
    then
      entries[#entries + 1] = entry
    end
  end

  if #entries == 0 then
    vim.notify("No paired file in this Diffview", vim.log.levels.INFO)
  elseif #entries == 1 then
    view:set_file(entries[1], true, true)
  else
    vim.ui.select(entries, {
      prompt = "Jump to paired diff",
      format_item = function(entry)
        return ("%s (%s)"):format(entry.path, entry.kind)
      end,
    }, function(entry)
      if entry and diffview_lib.get_current_view() == view then
        view:set_file(entry, true, true)
      end
    end)
  end
end

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
    visual_shas[#visual_shas + 1] = key
  end

  return visual_shas
end

return diffview
