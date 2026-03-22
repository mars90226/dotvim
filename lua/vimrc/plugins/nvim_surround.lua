local surround_config = require("nvim-surround.config")

local nvim_surround = {}

nvim_surround.vim_sandwich_keymaps = {
  {
    mode = "n",
    lhs = "sa",
    rhs = "<Plug>(nvim-surround-normal)",
    desc = "Add a surrounding pair around a motion (vim-sandwich)",
  },
  {
    mode = "n",
    lhs = "sas",
    rhs = "<Plug>(nvim-surround-normal-cur)",
    desc = "Add a surrounding pair around the current line (vim-sandwich)",
  },
  {
    mode = "n",
    lhs = "sA",
    rhs = "<Plug>(nvim-surround-normal-line)",
    desc = "Add a surrounding pair around a motion, on new lines (vim-sandwich)",
  },
  {
    mode = "n",
    lhs = "sAs",
    rhs = "<Plug>(nvim-surround-normal-cur-line)",
    desc = "Add a surrounding pair around the current line, on new lines (vim-sandwich)",
  },
  {
    mode = "x",
    lhs = "sa",
    rhs = "<Plug>(nvim-surround-visual)",
    desc = "Add a surrounding pair around a visual selection (vim-sandwich)",
  },
  {
    mode = "x",
    lhs = "sA",
    rhs = "<Plug>(nvim-surround-visual-line)",
    desc = "Add a surrounding pair around a visual selection, on new lines (vim-sandwich)",
  },
  {
    mode = "n",
    lhs = "sd",
    rhs = "<Plug>(nvim-surround-delete)",
    desc = "Delete a surrounding pair (vim-sandwich)",
  },
  {
    mode = "n",
    lhs = "sr",
    rhs = "<Plug>(nvim-surround-change)",
    desc = "Change a surrounding pair (vim-sandwich)",
  },
}

-- Ref: nvim-surround invalid_key_behavior in nvim_surround/lua/config.lua
nvim_surround.create = {
  add = function(left, right)
    return function(char)
      return { { left }, { right } }
    end
  end,
  find = function(left, right)
    return function(char)
      return surround_config.get_selection({
        pattern = vim.pesc(left) .. ".-" .. vim.pesc(right),
      })
    end
  end,
  delete = function(left, right)
    return function(char)
      return surround_config.get_selections({
        char = char,
        pattern = "^(" .. string.rep(".", #left) .. ")().-(" .. string.rep(".", #right) .. ")()$",
      })
    end
  end,
  change = function(left, right)
    return {
      target = function(char)
        return surround_config.get_selections({
          char = char,
          pattern = "^(" .. string.rep(".", #left) .. ")().-(" .. string.rep(".", #right) .. ")()$",
        })
      end,
    }
  end,
}

nvim_surround.create_all = function(left, right)
  return {
    add = nvim_surround.create.add(left, right),
    find = nvim_surround.create.find(left, right),
    delete = nvim_surround.create.delete(left, right),
    change = nvim_surround.create.change(left, right),
  }
end

nvim_surround.same = {
  add = function(chars)
    return nvim_surround.create.add(chars, chars)
  end,
  find = function(chars)
    return nvim_surround.create.find(chars, chars)
  end,
  delete = function(chars)
    return nvim_surround.create.delete(chars, chars)
  end,
  change = function(chars)
    return nvim_surround.create.change(chars, chars)
  end,
}

nvim_surround.same_all = function(chars)
  return {
    add = nvim_surround.same.add(chars),
    find = nvim_surround.same.find(chars),
    delete = nvim_surround.same.delete(chars),
    change = nvim_surround.same.change(chars),
  }
end

nvim_surround.setup_vim_sandwich_keymaps = function()
  for _, keymap in ipairs(nvim_surround.vim_sandwich_keymaps) do
    vim.keymap.set(keymap.mode, keymap.lhs, keymap.rhs, {
      remap = true,
      silent = true,
      desc = keymap.desc,
    })
  end
end

return nvim_surround
