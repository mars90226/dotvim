local floaterm = {}

floaterm.setup = function()
  -- Config
  vim.g.floaterm_position = 'center'
  vim.g.floaterm_width = vim.g.float_width_ratio
  vim.g.floaterm_height = vim.g.float_height_ratio
  vim.g.floaterm_winblend = 0
  vim.g.floaterm_autoclose = false

  -- Mappings
  vim.keymap.set("n", [[<M-2>]],      [[:FloatermToggle<CR>]], { silent = true })
  vim.keymap.set("n", [[<M-3>]],      [[:FloatermPrev<CR>]],   { silent = true })
  vim.keymap.set("n", [[<M-4>]],      [[:FloatermNext<CR>]],   { silent = true })
  vim.keymap.set("n", [[<M-5>]],      [[:FloatermNew!<CR>]],   { silent = true })
  vim.keymap.set("n", [[<Leader>xh]], [[:FloatermHide<CR>]],   { silent = true })
  vim.keymap.set("n", [[<Leader>xs]], [[:execute 'FloatermSend '.input('Command: ', '', 'shellcmd')<CR>]])
  vim.keymap.set("n", [[<Leader>xc]], [[:execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>]])
  vim.keymap.set("x", [[<Leader>xc]], [[:<C-U>execute 'FloatermNew '.input('Command: ', '', 'shellcmd')<CR>]])
  -- For inserting selection in input() using cmap
  vim.keymap.set("n", [[<Leader>xC]], [[:execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>]])
  -- For inserting selection in input() using cmap
  vim.keymap.set("x", [[<Leader>xC]], [[:<C-U>execute 'FloatermNew! '.input('Command: ', '', 'shellcmd')<CR>]])
  vim.keymap.set("n", [[<Leader>xw]], [[:execute 'FloatermNew! cd '.shellescape(getcwd())<CR>]])

  -- For terminal
  vim.keymap.set("t", [[<M-2>]], [[<C-\><C-N>:FloatermToggle<CR>]])
  vim.keymap.set("t", [[<M-3>]], [[<C-\><C-N>:FloatermPrev<CR>]])
  vim.keymap.set("t", [[<M-4>]], [[<C-\><C-N>:FloatermNext<CR>]])
  vim.keymap.set("t", [[<M-5>]], [[<C-\><C-N>:FloatermNew<CR>]])

  -- For nested neovim
  vim.keymap.set("t", [[<M-q><M-2>]], [[<C-\><C-\><C-N>:FloatermToggle<CR>]])
  vim.keymap.set("t", [[<M-q><M-3>]], [[<C-\><C-\><C-N>:FloatermPrev<CR>]])
  vim.keymap.set("t", [[<M-q><M-4>]], [[<C-\><C-\><C-N>:FloatermNext<CR>]])
  vim.keymap.set("t", [[<M-q><M-5>]], [[<C-\><C-\><C-N>:FloatermNew!<CR>]])

  -- For nested nested neovim
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-2>", ":FloatermToggle<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-3>", ":FloatermPrev<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-4>", ":FloatermNext<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-5>", ":FloatermNew!<CR>")
end

return floaterm
