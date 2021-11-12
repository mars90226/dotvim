local text_manipulation = {}

text_manipulation.startup = function(use)
  use {
    'junegunn/vim-easy-align',
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap('ga', '<Plug>(EasyAlign)')

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap('ga', '<Plug>(EasyAlign)')

      nmap('<Leader>ga', '<Plug>(LiveEasyAlign)')
      xmap('<Leader>ga', '<Plug>(LiveEasyAlign)')
    end
  }

  use {
    'jiangmiao/auto-pairs',
    config = function()
      vim.fn['vimrc#source']('vimrc/plugins/auto_pairs.vim')
    end
  }

  use {
    'vim-scripts/eraseSubword',
    config = function()
      vim.g.EraseSubword_insertMap = '<C-B>'
    end
  }

  use {
    'tomtom/tcomment_vim',
    event = 'VimEnter',
    config = function()
      vim.g.tcomment_textobject_inlinecomment = 'ilc'
    end
  }

  use {
    'svermeulen/vim-subversive',
    config = function()
      nmap('ss', '<Plug>(SubversiveSubstitute)')
      nmap('sS', '<Plug>(SubversiveSubstituteLine)')
      nmap('sl', '<Plug>(SubversiveSubstituteToEndOfLine)')

      nmap('<Leader>s', '<Plug>(SubversiveSubstituteRange)')
      xmap('<Leader>s', '<Plug>(SubversiveSubstituteRange)')
      nmap('<Leader>ss', '<Plug>(SubversiveSubstituteWordRange)')

      nmap('scr', '<Plug>(SubversiveSubstituteRangeConfirm)')
      xmap('scr', '<Plug>(SubversiveSubstituteRangeConfirm)')
      nmap('scrr', '<Plug>(SubversiveSubstituteWordRangeConfirm)')

      nmap('<Leader><Leader>s', '<Plug>(SubversiveSubvertRange)')
      xmap('<Leader><Leader>s', '<Plug>(SubversiveSubvertRange)')
      nmap('<Leader><Leader>ss', '<Plug>(SubversiveSubvertWordRange)')

      -- ie = inner entire buffer
      onoremap('ie', ':exec "normal! ggVG"<CR>')
      xnoremap('ie', ':<C-U>exec "normal! ggVG"<CR>')

      -- iV = current viewable text in the buffer
      onoremap('iV', ':exec "normal! HVL"<CR>')
      xnoremap('iV', ':<C-U>exec "normal! HVL"<CR>')

      -- Quick substitute from system clipboard
      nmap('=ss', '"+<Plug>(SubversiveSubstitute)')
      nmap('=sS', '"+<Plug>(SubversiveSubstituteLine)')
      nmap('=sl', '"+<Plug>(SubversiveSubstituteToEndOfLine)')
    end
  }

  use {
    'machakann/vim-sandwich',
    config = function()
      xmap('iss', '<Plug>(textobj-sandwich-auto-i)')
      xmap('ass', '<Plug>(textobj-sandwich-auto-a)')
      omap('iss', '<Plug>(textobj-sandwich-auto-i)')
      omap('ass', '<Plug>(textobj-sandwich-auto-a)')

      xmap('iy', '<Plug>(textobj-sandwich-literal-query-i)')
      xmap('ay', '<Plug>(textobj-sandwich-literal-query-a)')
      omap('iy', '<Plug>(textobj-sandwich-literal-query-i)')
      omap('ay', '<Plug>(textobj-sandwich-literal-query-a)')

      -- Seems bundled vim-textobj-functioncall does not work
      -- xmap ad <Plug>(textobject-sandwich-function-a)
      -- xmap id <Plug>(textobject-sandwich-function-i)
      -- omap ad <Plug>(textobject-sandwich-function-a)
      -- omap id <Plug>(textobject-sandwich-function-i)

      -- Add vim-surround key mapping for vim-visual-multi
      -- Borrowed from vim-sandwich/macros/sandwich/keymap/surround.vim
      nmap('ys', '<Plug>(operator-sandwich-add)')
      onoremap('<SID>line', ':normal! ^vg_<CR>')
      nmap('yss', '<Plug>(operator-sandwich-add)<SID>line', 'silent')
      onoremap('<SID>gul', 'g_')
      nmap('yS', 'ys<SID>gul')

      nmap('ds', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)')
      nmap('dss', '<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)')
      nmap('cs', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)')
      nmap('css', '<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)')

      -- To avoid mis-deleting character when cancelling sandwich operator
      nnoremap('s<Esc>', '<NOP>')

      vim.fn['vimrc#source']('vimrc/plugins/sandwich_after.vim')
    end
  }

  -- FIXME Due to usage of clipboard, it's slow in neovim in WSL
  use 'tommcdo/vim-exchange'

  use {
    'brooth/far.vim',
    config = function()
      if vim.fn.has('python3') == 1 then
        if vim.fn.executable('rg') == 1 then
          vim.g['far#source'] = 'rgnvim'
        elseif vim.fn.executable('ag') == 1 then
          vim.g['far#source'] = 'agnvim'
        elseif vim.fn.executable('ack') == 1 then
          vim.g['far#source'] = 'acknvim'
        end
      end

      vim.g['far#ignore_files'] = {vim.env.HOME..'/.gitignore'}

      vim.g['far#mapping'] = {
        replace_do = 'S'
      }
    end
  }

  use {
    'wincent/ferret',
    config = function()
      vim.g.FerretMap = 0
      vim.g.FerretQFCommands = 0

      nmap('<Leader>fa', '<Plug>(FerretAck)')
      nmap('<Leader>fl', '<Plug>(FerretLack)')
      nmap('<Leader>fs', '<Plug>(FerretAckWord)')
      nmap('<Leader>fr', '<Plug>(FerretAcks)')
    end
  }

  -- imap <BS> & <CR> is overwritten, need to be careful of bugs
  use {
    'mg979/vim-visual-multi',
    config = function()
      -- nvim-hlslens integration
      vim.cmd [[augroup vmlens_settings]]
      vim.cmd [[autocmd!]]
      vim.cmd [[autocmd User visual_multi_start lua require('vimrc.plugins.vmlens').start()]]
      vim.cmd [[autocmd User visual_multi_exit lua require('vimrc.plugins.vmlens').exit()]]
      vim.cmd [[augroup END]]
    end
  }

  -- For vim-markdown :TableFormat
  use {
    'godlygeek/tabular',
    cmd = 'Tabularize',
  }

  use 'editorconfig/editorconfig-vim'
  use 'AndrewRadev/splitjoin.vim'
  use 'tpope/vim-repeat'
end

return text_manipulation
