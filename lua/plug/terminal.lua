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

  use({
    "hkupty/iron.nvim",
    -- TODO: Seems broken in neovim 0.7? May retry it later.
    disable = true,
    config = function()
      require("iron.core").setup({
        config = {
          -- If iron should expose `<plug>(...)` mappings for the plugins
          should_map_plug = false,
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {},
        },
        -- Iron doesn't set keymaps by default anymore. Set them here
        -- or use `should_map_plug = true` and map from you vim files
        keymaps = {
          send_motion = "<Leader>ic",
          visual_send = "<Leader>ic",
          send_line = "<Leader>il",
          repeat_cmd = "<Leader>i.",
          cr = "<Leader>i<CR>",
          interrupt = "<Leader>i,",
          exit = "<Leader>iq",
          clear = "<Leader>i<C-L>",
        },
      })
    end,
  })
end

return terminal
