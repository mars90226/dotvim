local neotree_manager = require("neo-tree.sources.manager")
-- local neotree_manager =require("neo-tree.sources.manager").get_state('filesystem', vim.api.nvim_tabpage_get_number(0))

local neotree = {}

-- NOTE: Do not use winid parameter as currently 3 of neotree sources don't use winid
neotree.get_state = function(source, tabnr)
  local status, state = pcall(neotree_manager.get_state, source, tabnr)

  if status then
    return state
  else
    return nil
  end
end

neotree.get_tree = function(source)
  local tabpage = vim.api.nvim_get_current_tabpage()
  local state = neotree.get_state(source, vim.api.nvim_tabpage_get_number(tabpage))

  if state == nil then
    return nil
  end

  return state.tree
end

neotree.get_current_node = function(source)
  local tree = neotree.get_tree(source)

  if tree == nil then
    return nil
  end

  return tree:get_node()
end

neotree.get_current_path = function(source)
  local node = neotree.get_current_node(source)

  if node == nil then
    return ""
  end

  return node.path
end

neotree.get_current_dir = function(source)
  local tree = neotree.get_tree(source)
  local node = neotree.get_current_node(source)

  if tree == nil or node == nil then
    return ""
  end

  local parent_node = tree:get_node(node:get_parent_id())
  if parent_node == nil then
    return ""
  end

  return parent_node.path
end

return neotree
