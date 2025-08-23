local sts = require("syntax-tree-surfer")

local syntax_tree_surfer = {}

syntax_tree_surfer.default_targeted_jump = function()
  -- Default desired types according to syntax-tree-surfer with little addition
  -- Ref: https://github.com/ziontee113/syntax-tree-surfer/blob/master/lua/syntax-tree-surfer/init.lua#L371-L380
  sts.targeted_jump({"function", "if_statement", "else_clause", "else_statement", "elseif_statement", "for_statement", "while_statement", "switch_statement", "call_expression"})
end

syntax_tree_surfer.literal_targeted_jump = function ()
  sts.targeted_jump({"string", "string_literal","number", "number_literal","true","false"})
end

syntax_tree_surfer.setup = function()
  sts.setup({})

  -- Normal Mode Swapping:
  -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
  vim.keymap.set("n", "vU", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true, desc = "STS swap up" })
  vim.keymap.set("n", "vD", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true, desc = "STS swap down" })

  -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
  vim.keymap.set("n", "vd", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true, desc = "STS swap current node to next" })
  vim.keymap.set("n", "vu", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
    return "g@l"
  end, { silent = true, expr = true, desc = "STS swap current node to previous" })

  -- Visual Selection from Normal Mode
  vim.keymap.set("n", "vx", [[<Cmd>STSSelectMasterNode<CR>]], { silent = true, desc = "STS select master node" })
  vim.keymap.set("n", "vn", [[<Cmd>STSSelectCurrentNode<CR>]], { silent = true, desc = "STS select current node" })

  -- Select Nodes in Visual Mode
  vim.keymap.set("x", "<M-j>", [[<Cmd>STSSelectNextSiblingNode<CR>]], { silent = true, desc = "STS select next sibling node" })
  vim.keymap.set("x", "<M-k>", [[<Cmd>STSSelectPrevSiblingNode<CR>]], { silent = true, desc = "STS select previous sibling node" })
  vim.keymap.set("x", "<M-h>", [[<Cmd>STSSelectParentNode<CR>]], { silent = true, desc = "STS select parent node" })
  vim.keymap.set("x", "<M-l>", [[<Cmd>STSSelectChildNode<CR>]], { silent = true, desc = "STS select child node" })

  -- Swapping Nodes in Visual Mode
  vim.keymap.set("x", "<M-S-j>", [[<Cmd>STSSwapNextVisual<CR>]], { silent = true, desc = "STS swap to next" })
  vim.keymap.set("x", "<M-S-k>", [[<Cmd>STSSwapPrevVisual<CR>]], { silent = true, desc = "STS swap to previous" })

  -- Targeted jump
  vim.keymap.set("n", 
    vim.g.text_navigation_leader .. "r",
    function()
      syntax_tree_surfer.default_targeted_jump()
    end, { desc = "STS default targeted jump" }
  )
  vim.keymap.set("n", 
    vim.g.text_navigation_leader .. vim.g.text_navigation_leader,
    function()
      syntax_tree_surfer.default_targeted_jump()
    end, { desc = "STS default targeted jump" }
  )
  vim.keymap.set("n", 
    vim.g.text_navigation_leader .. "i",
    function()
      syntax_tree_surfer.literal_targeted_jump()
    end, { desc = "STS literal targeted jump" }
  )

  -- filtered jump
  vim.keymap.set("n", "<M-s>n", function() require("syntax-tree-surfer").filtered_jump("default", true) end, { silent = true, desc = "STS filtered jump forward" })
  vim.keymap.set("n", "<M-s>p", function() require("syntax-tree-surfer").filtered_jump("default", false) end, { silent = true, desc = "STS filtered jump backward" })

  -- TODO: Add more jump
end

return syntax_tree_surfer
