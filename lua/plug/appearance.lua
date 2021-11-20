local appearance = {}

appearance.startup = function(use)
  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    config = function() require('vimrc.plugins.lualine') end
  }

  -- Tabline
  use {
    'nanozuki/tabby.nvim',
    config = function() require('vimrc.plugins.tabby') end
  }

  -- Devicons
  use {'kyazdani42/nvim-web-devicons', module = 'nvim-web-devicons'}

  -- Colors
  use 'rktjmp/lush.nvim'
  use 'ellisonleao/gruvbox.nvim'

  -- Which key
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}

      vim.go.timeoutlen = 500
    end
  }
end

return appearance
