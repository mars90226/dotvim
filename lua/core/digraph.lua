local plugin_utils = require("vimrc.plugin_utils")

local digraph = {}

digraph.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/digraph",
    config = function()
      -- These are already defined
      -- digraphs ,_ 12289 " '、'
      -- digraphs ._ 12290 " '。'
      vim.cmd([[digraphs ,- 65292 " '，']])
      vim.cmd([[digraphs ,: 65306 " '：']])
      vim.cmd([[digraphs ,; 65307 " '；']])
      vim.cmd([[digraphs .! 65281 " '！']])
      vim.cmd([[digraphs .? 65311 " '？']])
    end,
  })
end

return digraph
