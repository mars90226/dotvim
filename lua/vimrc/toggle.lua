local choose = require("vimrc.choose")

local M = {}

--- Toggle indentation settings between using spaces (expandtab) and tabs.
--- When expandtab is enabled, switch to tab settings for a 4‑space width.
--- Otherwise, switch to settings for a 2‑space width.
function M.toggle_indent()
  if vim.bo.expandtab then
    vim.bo.expandtab = false
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
  else
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
  end
end

--- Toggle the fold method between manual and automatic (syntax/treesitter).
--- If the current fold method is manual, then:
---   - If the 'nvim-treesitter' plugin is enabled (via vimrc.choose.is_enabled_plugin),
---     set fold method to expression and use nvim_treesitter#foldexpr().
---   - Otherwise, set the fold method to syntax and reset foldexpr to its default value.
--- If the current fold method is not manual, switch it back to manual and reset foldexpr.
function M.toggle_fold_method()
  if vim.wo.foldmethod == "manual" then
    if choose.is_enabled_plugin("nvim-treesitter") then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.wo.foldmethod = "syntax"
      vim.cmd("setlocal foldexpr&")
    end
  else
    vim.wo.foldmethod = "manual"
    vim.cmd("setlocal foldexpr&")
  end
end

--- Toggle the inclusion of a parent folder tag (i.e. "./tags;") in the 'tags' option.
--- If the tag is already present in the comma‑separated 'tags' list, remove it;
--- otherwise, add it.
function M.toggle_parent_folder_tag()
  local parent_folder_tag_pattern = "./tags;"
  local found = false
  local tags = vim.bo.tags -- get the current tags setting

  -- Split the tags string by commas and search for the pattern.
  for tag in string.gmatch(tags, "([^,]+)") do
    if tag == parent_folder_tag_pattern then
      found = true
      break
    end
  end

  if found then
    vim.cmd("set tags-=" .. parent_folder_tag_pattern)
  else
    vim.cmd("set tags+=" .. parent_folder_tag_pattern)
  end
end

return M
