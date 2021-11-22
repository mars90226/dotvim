local utils = require("vimrc.utils")

local terminal = {}

terminal.startup = function(use)
  -- vim-floaterm
  use({
    "voldikss/vim-floaterm",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/floaterm.vim")
    end,
  })
  use("voldikss/fzf-floaterm")

  use({
    "kassio/neoterm",
    cmd = { "T", "Ttoggle", "Texec" },
    keys = { "<Space>`", "<Leader>`" },
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/neoterm.vim")
    end,
  })
end

return terminal
