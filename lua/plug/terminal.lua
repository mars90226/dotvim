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

  -- FIXME: Seems broken in neovim 0.9.0? Replace it with other terminal plugin
  use({
    "kassio/neoterm",
    cmd = { "T", "Ttoggle", "Texec" },
    keys = { "<Space>`", "<Leader>`" },
    config = function()
      require("vimrc.plugins.neoterm").setup()
    end,
  })

  use({
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronReplHere", "IronSend" },
    keys = { "<Leader>ic", "<Leader>if", "<Leader>il", "<Leader>mc" },
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
          send_file = "<Leader>if",
          send_line = "<Leader>il",
          send_mark = "<Leader>im",
          mark_motion = "<Leader>mc",
          mark_visual = "<Leader>mc",
          remove_mark = "<Leader>md",
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
