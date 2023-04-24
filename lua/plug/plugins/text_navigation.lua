local choose = require("vimrc.choose")

local text_navigation = {
  -- Match
  {
    "andymass/vim-matchup",
    cmd = { "DoMatchParen" },
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 1000
      vim.g.matchup_matchparen_deferred_hide_delay = 1000
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_insert_timeout = 20
      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_offscreen = {
        method = "status_manual", -- we already have nvim-treesitter-context
      }
      vim.g.matchup_surround_enabled = 1
    end,
    -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
  },

  -- Jump
  {
    "phaazon/hop.nvim",
    keys = {
      "<Space>w",
      "<Space>e",
      "<Space>;",
      "<LocalLeader>f",
      "<LocalLeader>l",
      "<Space>j",
      "<Space>k",
    },
    config = function()
      map("<Space>w", "<Cmd>HopWord<CR>")
      map("<Space>e", [=[<Cmd>lua require('hop').hint_patterns({}, [[\k\>]])<CR>]=])
      map("<Space>;", "<Cmd>HopPattern<CR>")
      map("<LocalLeader>f", "<Cmd>HopChar1<CR>")
      map("<LocalLeader>l", "<Cmd>HopLine<CR>")
      map("<Space>j", "<Cmd>HopLineAC<CR>")
      map("<Space>k", "<Cmd>HopLineBC<CR>")

      require("hop").setup({})
    end,
  },
  {
    "indianboy42/hop-extensions",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    -- TODO: Organize this
    keys = {
      "<M-e>l",
      "<M-e>d",
      "<M-e>r",
      "<M-e>s",
      "<M-e>t",
      "<M-e>x",
      "<M-e>c",
      "<M-e>v",
      "<M-e>f",
      "<M-e>p",
      "<M-e>m",
    },
    config = function()
      require("vimrc.plugins.hop_extensions").setup()
    end,
  },
  {
    "ggandor/lightspeed.nvim",
    keys = {
      ";",
      "<M-;>",
    },
    config = function()
      require("lightspeed").setup({
        ignore_case = true,
      })

      map(";", "<Plug>Lightspeed_omni_s")
      -- To avoid 'S' being mapped
      -- TODO: Use better way to avoid 'S' being mapped
      noremap("S", "S")

      -- NOTE: lightspeed.nvim will map 'gs', which may cause a little problem with vim-caser mapping
      -- To avoid 'S' being mapped
      -- TODO: Use better way to avoid 'gs' being mapped
      noremap("gs", "gs")
      nmap("<M-;>", "<Plug>Lightspeed_omni_gs")
    end,
  },
  {
    "rlane/pounce.nvim",
    cmd = { "Pounce" },
    keys = { "<Leader>/" },
    config = function()
      map("<Leader>/", [[<Cmd>Pounce<CR>]])
    end,
  },

  -- Search
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      "n",
      "N",
      "*",
      "#",
      "g*",
      "g#",
      "z*",
      "gz*",
      "z#",
      "gz#",
    },
    dependencies = { "haya14busa/vim-asterisk" },
    config = function()
      require("hlslens").setup()

      noremap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], "silent")
      noremap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], "silent")

      -- vim-asterisk
      map("*", [[<Plug>(asterisk-*)<Cmd>lua require('hlslens').start()<CR>]])
      map("#", [[<Plug>(asterisk-#)<Cmd>lua require('hlslens').start()<CR>]])
      map("g*", [[<Plug>(asterisk-g*)<Cmd>lua require('hlslens').start()<CR>]])
      map("g#", [[<Plug>(asterisk-g#)<Cmd>lua require('hlslens').start()<CR>]])
      map("z*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]])
      map("gz*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]])
      map("z#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]])
      map("gz#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]])
    end,
  },

  -- Marks
  {
    "chentoast/marks.nvim",
    event = { "VeryLazy" },
    config = function()
      require("marks").setup({})
    end,
  },

  -- Motion
  {
    "bkad/CamelCaseMotion",
    event = { "VeryLazy" },
    config = function()
      map("<Leader>mw", "<Plug>CamelCaseMotion_w")
      map("<Leader>mb", "<Plug>CamelCaseMotion_b")
      map("<Leader>me", "<Plug>CamelCaseMotion_e")
      map("<Leader>mge", "<Plug>CamelCaseMotion_ge")

      omap("imw", "<Plug>CamelCaseMotion_iw", "silent")
      xmap("imw", "<Plug>CamelCaseMotion_iw", "silent")
      omap("imb", "<Plug>CamelCaseMotion_ib", "silent")
      xmap("imb", "<Plug>CamelCaseMotion_ib", "silent")
      omap("ime", "<Plug>CamelCaseMotion_ie", "silent")
      xmap("ime", "<Plug>CamelCaseMotion_ie", "silent")
    end,
  },

  {
    "haya14busa/vim-edgemotion",
    event = { "VeryLazy" },
    config = function()
      map("<Space><Space>j", "<Plug>(edgemotion-j)")
      map("<Space><Space>k", "<Plug>(edgemotion-k)")
    end,
  },

  {
    "jeetsukumaran/vim-indentwise",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
  },
}

return text_navigation
