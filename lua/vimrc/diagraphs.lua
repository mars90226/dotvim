local diagraphs = {}

diagraphs.setup = function()
  -- These are already defined
  -- digraphs ,_ 12289 " '、'
  -- digraphs ._ 12290 " '。'
  vim.cmd([[digraphs ,- 65292 " '，']])
  vim.cmd([[digraphs ,: 65306 " '：']])
  vim.cmd([[digraphs ,; 65307 " '；']])
  vim.cmd([[digraphs .! 65281 " '！']])
  vim.cmd([[digraphs .? 65311 " '？']])
end

return diagraphs
