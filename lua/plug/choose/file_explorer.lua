local file_explorer = {}

file_explorer.setup = function()
  -- Choose file explorer
  -- defx.nvim
  vim.fn["vimrc#plugin#disable_plugins"]({ "defx.nvim" })
  if vim.fn["vimrc#plugin#check#python_version"]() >= "3.6.1" then
    vim.fn["vimrc#plugin#enable_plugin"]("defx.nvim")
  end

  -- NOTE: Always use neo-tree.nvim
  -- TODO: Remove others
end

return file_explorer
