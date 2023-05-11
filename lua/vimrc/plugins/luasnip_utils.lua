local ls = require("luasnip")
local types = require("luasnip.util.types")

local utils = require("vimrc.utils")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

local luasnip_utils = {}

luasnip_utils.same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

-- TODO: Add index
-- TODO: Add dynamic node
luasnip_utils.fzf_tmux_choice = function(choices)
  return f(function()
    return vim.fn["vimrc#fzf#choices_in_commandline"](choices)
  end)
end

luasnip_utils.t_choice = function(choices)
  return vim.tbl_map(function(choice)
    return t(choice)
  end, choices)
end

return luasnip_utils
