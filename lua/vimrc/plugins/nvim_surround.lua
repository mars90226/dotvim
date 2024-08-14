local has_surround, surround = pcall(require, "nvim-surround")
if not has_surround then
  return
end

local surround_config = require("nvim-surround.config")

local nvim_surround = {}

nvim_surround.presets = {
  vim_surround = {
    keymaps = {
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "S",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
    },
  },
  vim_sandwich = {
    keymaps = {
      normal = "sa",
      normal_cur = "sas",
      normal_line = "sA",
      normal_cur_line = "sAs",
      visual = "sa",
      visual_line = "sA",
      delete = "sd",
      change = "sr",
    },
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

nvim_surround.buffer_setup_preset = function(preset_name)
  local preset = nvim_surround.presets[preset_name]
  if preset then
    surround.buffer_setup(preset)
  end
end

return nvim_surround
