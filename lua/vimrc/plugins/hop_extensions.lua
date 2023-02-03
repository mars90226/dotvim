local hop_extensions = {}

hop_extensions.setup = function()
  -- Treesitter
  map("<M-e>l", [[<Cmd>lua require('hop-extensions').hint_locals()<CR>]], { desc = "Hop locals" })
  map("<M-e>d", [[<Cmd>lua require('hop-extensions').hint_definitions()<CR>]], { desc = "Hop definitions" })
  map("<M-e>r", [[<Cmd>lua require('hop-extensions').hint_references()<CR>]], { desc = "Hop references" })
  map("<M-e>s", [[<Cmd>lua require('hop-extensions').hint_scopes()<CR>]], { desc = "Hop scopes" })
  map("<M-e>t", [[<Cmd>lua require('hop-extensions').hint_textobjects()<CR>]], { desc = "Hop all textobjects" })
  map("<M-e>x", [[<Cmd>lua require('hop-extensions').hint_textobjects('call')<CR>]], { desc = "Hop call textobjects" })
  map(
    "<M-e>c",
    [[<Cmd>lua require('hop-extensions').hint_textobjects('class')<CR>]],
    { desc = "Hop class textobjects" }
  )
  map(
    "<M-e>v",
    [[<Cmd>lua require('hop-extensions').hint_textobjects('comment')<CR>]],
    { desc = "Hop comment textobjects" }
  )
  map(
    "<M-e>f",
    [[<Cmd>lua require('hop-extensions').hint_textobjects('function')<CR>]],
    { desc = "Hop function textobjects" }
  )
  map(
    "<M-e>p",
    [[<Cmd>lua require('hop-extensions').hint_textobjects('parameter')<CR>]],
    { desc = "Hop parameter textobjects" }
  )
  map(
    "<M-e>m",
    [[<Cmd>lua require('hop-extensions').hint_textobjects('statement')<CR>]],
    { desc = "Hop statement textobjects" }
  )

  -- LSP
  -- TODO: LSP functions is incomplete
end

return hop_extensions
