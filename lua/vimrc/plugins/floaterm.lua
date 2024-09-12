local floaterm = {}

floaterm.setup = function()
  -- Config
  vim.g.floaterm_position = 'center'
  vim.g.floaterm_width = vim.g.float_width_ratio
  vim.g.floaterm_height = vim.g.float_height_ratio
  vim.g.floaterm_winblend = 0
  vim.g.floaterm_autoclose = false

  -- For nested nested neovim
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-2>", ":FloatermToggle<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-3>", ":FloatermPrev<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-4>", ":FloatermNext<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-5>", ":FloatermNew!<CR>")
end

return floaterm
