local hop_extensions = {}

hop_extensions.setup = function()
  -- Treesitter
  map(vim.g.text_navigation_leader .. "l", [[<Cmd>lua require('hop-extensions').ts.hint_locals({})<CR>]], { desc = "Hop locals" })
  map(vim.g.text_navigation_leader .. "d", [[<Cmd>lua require('hop-extensions').ts.hint_definitions({})<CR>]], { desc = "Hop definitions" })
  map(vim.g.text_navigation_leader .. "r", [[<Cmd>lua require('hop-extensions').ts.hint_references({})<CR>]], { desc = "Hop references" })
  map(vim.g.text_navigation_leader .. "s", [[<Cmd>lua require('hop-extensions').ts.hint_scopes({})<CR>]], { desc = "Hop scopes" })
  map(vim.g.text_navigation_leader .. "t", [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({})<CR>]], { desc = "Hop all textobjects" })
  map(vim.g.text_navigation_leader .. "x", [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@call')<CR>]], { desc = "Hop call textobjects" })
  map(
    vim.g.text_navigation_leader .. "c",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@class')<CR>]],
    { desc = "Hop class textobjects" }
  )
  map(
    vim.g.text_navigation_leader .. "v",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@comment')<CR>]],
    { desc = "Hop comment textobjects" }
  )
  map(
    vim.g.text_navigation_leader .. "f",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@function')<CR>]],
    { desc = "Hop function textobjects" }
  )
  map(
    vim.g.text_navigation_leader .. "p",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@parameter')<CR>]],
    { desc = "Hop parameter textobjects" }
  )
  map(
    vim.g.text_navigation_leader .. "m",
    [[<Cmd>lua require('hop-extensions').ts.hint_textobjects({}, '@statement')<CR>]],
    { desc = "Hop statement textobjects" }
  )

  -- LSP
  -- TODO: Add key mappings for LSP functions
end

return hop_extensions
