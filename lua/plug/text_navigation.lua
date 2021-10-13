local text_navigation = {}

text_navigation.startup = function(use)
  -- matchit
  vim.cmd [[runtime macros/matchit.vim]]
  use 'voithos/vim-python-matchit'

  use {
    'easymotion/vim-easymotion',
    config = function()
      vim.g.EasyMotion_leader_key = '<Space>'
      vim.g.EasyMotion_smartcase = 1

      map(';',        '<Plug>(easymotion-s2)')
      map('<Space>;', '<Plug>(easymotion-sn)')

      map([[\w]], '<Plug>(easymotion-bd-wl)')
      map([[\f]], '<Plug>(easymotion-bd-fl)')
      map([[\s]], '<Plug>(easymotion-sl2)')

      map('<Space><Space>f', '<Plug>(easymotion-bd-f)')
      map('<Space><Space>l', '<Plug>(easymotion-bd-jk)')
      map('<Space><Space>t', '<Plug>(easymotion-bd-t)')
      map('<Plug>(easymotion-prefix)s', '<Plug>(easymotion-bd-f2)')
      map('<Plug>(easymotion-prefix)w', '<Plug>(easymotion-bd-w)')
      map('<Plug>(easymotion-prefix)W', '<Plug>(easymotion-bd-W)')
      map('<Plug>(easymotion-prefix)e', '<Plug>(easymotion-bd-e)')
      map('<Plug>(easymotion-prefix)E', '<Plug>(easymotion-bd-E)')

      nmap("<Leader>'", "<Plug>(easymotion-next)")
      nmap("<Leader>;", "<Plug>(easymotion-prev)")
      nmap("<Leader>.", "<Plug>(easymotion-repeat)")

      map('<Plug>(easymotion-prefix)J', '<Plug>(easymotion-eol-j)')
      map('<Plug>(easymotion-prefix)K', '<Plug>(easymotion-eol-k)')

      map('<Plug>(easymotion-prefix);', '<Plug>(easymotion-jumptoanywhere)')
    end
  }
  use {
    'phaazon/hop.nvim',
    config = function()
      map('<Space>w',        '<Cmd>HopWord<CR>')
      map('<Space>;',        '<Cmd>HopPattern<CR>')
      map('<Space><Space>f', '<Cmd>HopChar1<CR>')
      map(';',               '<Cmd>HopChar2<CR>')
      map('<Space><Space>l', '<Cmd>HopLine<CR>')
      map('<Space>j',        '<Cmd>HopLineAC<CR>')
      map('<Space>k',        '<Cmd>HopLineBC<CR>')

      require('hop').setup {}
    end
  }
  use {
    'ggandor/lightspeed.nvim',
    config = function()
      map(';',     '<Plug>Lightspeed_s')
      map('<M-;>', '<Plug>Lightspeed_S')
    end
  }
  use {
    'ripxorip/aerojump.nvim',
    run = function() vim.cmd [[UpdateRemotePlugins]] end,
    config = function()
      vim.g.aerojump_keymaps = {
        ['<Esc>'] = 'AerojumpExit',
        ['<C-C>'] = 'AerojumpExit',
        ['<Tab>'] = 'AerojumpSelNext',
        ['<S-Tab>'] = 'AerojumpSelPrev',
      }

      nmap('<Space>as', '<Plug>(AerojumpSpace)')
      nmap('<Space>ab', '<Plug>(AerojumpBolt)')
      nmap('<Space>aa', '<Plug>(AerojumpFromCursorBolt)')
      nmap('<Space>ad', '<Plug>(AerojumpDefault)')
      nmap('<Space>am', '<Plug>(AerojumpMilk)')
    end
  }

  use {
    'haya14busa/vim-asterisk',
    config = function()
      map('*',   '<Plug>(incsearch-nohl)<Plug>(asterisk-*)')
      map('#',   '<Plug>(incsearch-nohl)<Plug>(asterisk-#)')
      map('g*',  '<Plug>(incsearch-nohl)<Plug>(asterisk-g*)')
      map('g#',  '<Plug>(incsearch-nohl)<Plug>(asterisk-g#)')
      map('z*',  '<Plug>(incsearch-nohl0)<Plug>(asterisk-z*)')
      map('gz*', '<Plug>(incsearch-nohl0)<Plug>(asterisk-gz*)')
      map('z#',  '<Plug>(incsearch-nohl0)<Plug>(asterisk-z#)')
      map('gz#', '<Plug>(incsearch-nohl0)<Plug>(asterisk-gz#)')
    end
  }

  -- incsearch
  use {
    'haya14busa/incsearch.vim',
    config = function()
      -- :h g:incsearch#auto_nohlsearch
      vim.g['incsearch#auto_nohlsearch'] = 1

      map('n', '<Plug>(incsearch-nohl-n)')
      map('N', '<Plug>(incsearch-nohl-N)')

      -- Replace by vim-asterisk
      -- map('*',  '<Plug>(incsearch-nohl-*)')
      -- map('#',  '<Plug>(incsearch-nohl-#)')
      -- map('g*', '<Plug>(incsearch-nohl-g*)')
      -- map('g#', '<Plug>(incsearch-nohl-g#)')

      -- For original search incase need to insert special characters like NULL
      nnoremap('<Leader><Leader>/', '/')
      nnoremap('<Leader><Leader>?', '?')

      map('/',  '<Plug>(incsearch-forward)')
      map('?',  '<Plug>(incsearch-backward)')
      map('g/', '<Plug>(incsearch-stay)')

      -- Search within visual selection
      xmap('<M-/>', [[<Esc><Plug>(incsearch-forward)\%V]])
      xmap('<M-?>', [[<Esc><Plug>(incsearch-backward)\%V]])

      vim.cmd [[augroup incsearch_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd BufWinLeave,WinLeave * call vimrc#incsearch#clear_nohlsearch()]]
      vim.cmd [[augroup END]]

      vim.cmd [[command! ClearIncsearchAutoNohlsearch call vimrc#incsearch#clear_auto_nohlsearch()]]
    end
  }
  use {
    'haya14busa/incsearch-fuzzy.vim',
    config = function()
      map('z/',  '<Plug>(incsearch-fuzzy-/)')
      map('z?',  '<Plug>(incsearch-fuzzy-?)')
      map('zg/', '<Plug>(incsearch-fuzzy-stay)')
    end
  }
  use {
    'haya14busa/incsearch-easymotion.vim',
    config = function()
      map('<Leader>/',  '<Plug>(incsearch-easymotion-/)')
      map('<Leader>?',  '<Plug>(incsearch-easymotion-?)')
      map('<Leader>g/', '<Plug>(incsearch-easymotion-stay)')

    -- incsearch.vim x fuzzy x vim-easymotion
      noremap([[\/]], 'incsearch#go(vimrc#incsearch#config_easyfuzzymotion())', 'silent', 'expr')
      noremap([[Z/]], 'incsearch#go(vimrc#incsearch#config_easyfuzzymotion())', 'silent', 'expr')
    end
  }

  use {
    'bkad/CamelCaseMotion',
    config = function()
      map('<Leader>mw', '<Plug>CamelCaseMotion_w')
      map('<Leader>mb', '<Plug>CamelCaseMotion_b')
      map('<Leader>me', '<Plug>CamelCaseMotion_e')
      map('<Leader>mge', '<Plug>CamelCaseMotion_ge')

      omap('imw', '<Plug>CamelCaseMotion_iw', 'silent')
      xmap('imw', '<Plug>CamelCaseMotion_iw', 'silent')
      omap('imb', '<Plug>CamelCaseMotion_ib', 'silent')
      xmap('imb', '<Plug>CamelCaseMotion_ib', 'silent')
      omap('ime', '<Plug>CamelCaseMotion_ie', 'silent')
      xmap('ime', '<Plug>CamelCaseMotion_ie', 'silent')
    end
  }

  use {
    'haya14busa/vim-edgemotion',
    config = function()
      map('<Space><Space>j', '<Plug>(edgemotion-j)')
      map('<Space><Space>k', '<Plug>(edgemotion-k)')
    end
  }

  use 'jeetsukumaran/vim-indentwise'
end

return text_navigation
