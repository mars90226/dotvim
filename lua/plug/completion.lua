require'mapx'.setup{ global = true }

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

local completion = {}

completion.startup = function(use)
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
  use {
    'Shougo/neosnippet.vim',
    config = function()
      vim.g['neosnippet#snippets_directory'] = {
        vim.fn['vimrc#get_vim_plug_dir']()..'/neosnippet-snippets/neosnippets',
        vim.fn['vimrc#get_vim_plug_dir']()..'/vim-snippets/snippets',
        vim.fn['vimrc#get_vimhome']()..'/my-snippets',
        vim.env.HOME..'/.vim_secret/my-snippets'
      }

      -- Plugin key-mappings.
      -- <C-J>: expand or jump or select completion
      imap('<C-J>',
        [[pumvisible() && !neosnippet#expandable_or_jumpable() ? "\<C-Y>" : "\<Plug>(neosnippet_expand_or_jump)"]],
        'silent',
        'expr')
      smap('<C-J>', [["\<Plug>(neosnippet_expand_or_jump)"]])
      xmap('<C-J>', [["\<Plug>(neosnippet_expand_target)"]])

      -- For snippet_complete marker.
      if vim.fn.has('conceal') == 1 then
        vim.go.conceallevel = 2
        vim.go.concealcursor = 'i'
      end

      -- Enable snipMate compatibility feature.
      vim.g['neosnippet#enable_snipmate_compatibility'] = 1

      vim.cmd [[augroup neosnippet_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd BufNewFile,BufReadPost *.snip setlocal filetype=neosnippet]]
      vim.cmd [[augroup END]]
    end
  }
  use 'Shougo/neosnippet-snippets'
  use 'honza/vim-snippets'

  if vim.fn.executable('tmux') == 1 then
    use 'wellle/tmux-complete.vim'
  end
end

return completion
