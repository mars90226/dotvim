local hop_extensions = {}

hop_extensions.setup = function()
  -- Treesitter
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "l",
    [[<Cmd>lua require('hop-extensions').ts.hint_locals({})<CR>]],
    { desc = "Hop locals", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "d",
    [[<Cmd>lua require('hop-extensions').ts.hint_definitions({})<CR>]],
    { desc = "Hop definitions", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "r",
    [[<Cmd>lua require('hop-extensions').ts.hint_references({})<CR>]],
    { desc = "Hop references", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "s",
    [[<Cmd>lua require('hop-extensions').ts.hint_scopes({})<CR>]],
    { desc = "Hop scopes", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "t",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({})<CR>]],
    { desc = "Hop all textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "x",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@call')<CR>]],
    { desc = "Hop call textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "c",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@class')<CR>]],
    { desc = "Hop class textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "v",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@comment')<CR>]],
    { desc = "Hop comment textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "f",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@function')<CR>]],
    { desc = "Hop function textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "p",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@parameter')<CR>]],
    { desc = "Hop parameter textobjects", remap = true }
  )
  vim.keymap.set(
    "",
    vim.g.text_navigation_leader .. "m",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@statement')<CR>]],
    { desc = "Hop statement textobjects", remap = true }
  )

  -- LSP
  -- TODO: Add key mappings for LSP functions
end

return hop_extensions
