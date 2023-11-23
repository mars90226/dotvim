local syntax_tree_surfer = {}

syntax_tree_surfer.setup = function()
  require("syntax-tree-surfer").setup({})

  -- Normal Mode Swapping:
  -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
  vim.keymap.set("n", "vU", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })
  vim.keymap.set("n", "vD", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })

  -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
  vim.keymap.set("n", "vd", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })
  vim.keymap.set("n", "vu", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true })

  -- Visual Selection from Normal Mode
  nnoremap("vx", [[<Cmd>STSSelectMasterNode<CR>]], "silent")
  nnoremap("vn", [[<Cmd>STSSelectCurrentNode<CR>]], "silent")

  -- Select Nodes in Visual Mode
  xnoremap("<M-j>", [[<Cmd>STSSelectNextSiblingNode<CR>]], "silent")
  xnoremap("<M-k>", [[<Cmd>STSSelectPrevSiblingNode<CR>]], "silent")
  xnoremap("<M-h>", [[<Cmd>STSSelectParentNode<CR>]], "silent")
  xnoremap("<M-l>", [[<Cmd>STSSelectChildNode<CR>]], "silent")

  -- Swapping Nodes in Visual Mode
  xnoremap("<M-S-j>", [[<Cmd>STSSwapNextVisual<CR>]], "silent")
  xnoremap("<M-S-k>", [[<Cmd>STSSwapPrevVisual<CR>]], "silent")

  -- Targeted jump
  -- Default desired types according to syntax-tree-surfer
  -- Ref: https://github.com/ziontee113/syntax-tree-surfer/blob/master/lua/syntax-tree-surfer/init.lua#L371-L380
  nnoremap(
    vim.g.text_navigation_leader .. "e",
    [[<Cmd>lua require("syntax-tree-surfer").targeted_jump({"function", "if_statement", "else_clause", "else_statement", "elseif_statement", "for_statement", "while_statement", "switch_statement"})<CR>]],
    { desc = "Default targeted jump" }
  )
  nnoremap(
    vim.g.text_navigation_leader .. "i",
    [[<Cmd>lua require("syntax-tree-surfer").targeted_jump({"string", "string_literal","number", "number_literal","true","false"})<CR>]],
    { desc = "literal targeted jump" }
  )

  -- filtered jump
  nnoremap("<M-s>n", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", true)<CR>]], "silent")
  nnoremap("<M-s>p", [[<Cmd>lua require("syntax-tree-surfer").filtered_jump("default", false)<CR>]], "silent")
end

return syntax_tree_surfer
