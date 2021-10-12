local completion = {}

completion.setup_mapping = function()
  -- Completion setting
  inoremap('<CR>',       [[pumvisible() ? "\<C-Y>" : "\<CR>"]], 'expr')
  inoremap('<Down>',     [[pumvisible() ? "\<C-N>" : "\<Down>"]], 'expr')
  inoremap('<Up>',       [[pumvisible() ? "\<C-P>" : "\<Up>"]], 'expr')
  inoremap('<PageDown>', [[pumvisible() ? "\<PageDown>\<C-P>\<C-N>" : "\<PageDown>"]], 'expr')
  inoremap('<PageUp>',   [[pumvisible() ? "\<PageUp>\<C-P>\<C-N>" : "\<PageUp>"]], 'expr')
  inoremap('<Tab>',      [[pumvisible() ? "\<C-N>" : "\<Tab>"]], 'expr')
  inoremap('<S-Tab>',    [[pumvisible() ? "\<C-P>" : "\<S-Tab>"]], 'expr')

  -- mapping for decrease number
  nnoremap('<C-X><C-X>', '<C-X>')
end

completion.startup = function(use)
  completion.setup_mapping()

  -- Completion
  use 'Shougo/neco-vim'
  use 'neoclide/coc-neco'
  use {
    'neoclide/coc.nvim',
    branch = 'release',
    run = function() vim.fn['coc#util#install']() end,
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/coc.vim')
      vim.fn['vimrc#source']('vimrc/plugins/coc_after.vim')
    end
  }
  use 'neoclide/coc-denite'
  use 'antoinemadec/coc-fzf'

  -- Completion Source
  -- TODO: Add snippets plugin
  -- neosnippet keeps showing error
  use 'honza/vim-snippets'

  vim.cmd [[packadd tmux-complete.vim]]
  use {
    'wellle/tmux-complete.vim',
    cond = function()
      return vim.fn.executable('tmux') == 1
    end
  }
end

return completion
