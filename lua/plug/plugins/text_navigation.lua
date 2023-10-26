local choose = require("vimrc.choose")

local text_navigation = {
  -- Match
  {
    "andymass/vim-matchup",
    -- NOTE: Cannot lazy load, will break `%` function
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
    "smoka7/hop.nvim",
    keys = {
      { "<Space>w", mode = { "n", "o", "x" } },
      { "<Space>e", mode = { "n", "o", "x" } },
      { "<Space>;", mode = { "n", "o", "x" } },
      { "<LocalLeader>f", mode = { "n", "o", "x" } },
      { "<LocalLeader>l", mode = { "n", "o", "x" } },
      -- { "<Space>j", mode = { "n", "o", "x" } },
      -- { "<Space>k", mode = { "n", "o", "x" } },
      { "<Space>cw", mode = { "n", "o", "x" } },
    },
    config = function()
      map("<Space>w", "<Cmd>HopWord<CR>")
      map("<Space>e", [=[<Cmd>lua require('hop').hint_patterns({}, [[\k\>]])<CR>]=])
      map("<Space>;", "<Cmd>HopPattern<CR>")
      map("<LocalLeader>f", "<Cmd>HopChar1<CR>")
      map("<LocalLeader>l", "<Cmd>HopLine<CR>")
      -- map("<Space>j", "<Cmd>HopLineAC<CR>")
      -- map("<Space>k", "<Cmd>HopLineBC<CR>")
      map("<Space>cw", "<Cmd>HopCamelCase<CR>")

      require("hop").setup({})
    end,
  },
  {
    "indianboy42/hop-extensions",
    cond = choose.is_enabled_plugin("nvim-treesitter"),
    -- TODO: Organize this
    keys = {
      { "<M-e>l", mode = { "n", "o", "x" } },
      { "<M-e>d", mode = { "n", "o", "x" } },
      { "<M-e>r", mode = { "n", "o", "x" } },
      { "<M-e>s", mode = { "n", "o", "x" } },
      { "<M-e>t", mode = { "n", "o", "x" } },
      { "<M-e>x", mode = { "n", "o", "x" } },
      { "<M-e>c", mode = { "n", "o", "x" } },
      { "<M-e>v", mode = { "n", "o", "x" } },
      { "<M-e>f", mode = { "n", "o", "x" } },
      { "<M-e>p", mode = { "n", "o", "x" } },
      { "<M-e>m", mode = { "n", "o", "x" } },
    },
    config = function()
      require("vimrc.plugins.hop_extensions").setup()
    end,
  },
  {
    "ggandor/lightspeed.nvim",
    keys = {
      "f",
      "F",
      "t",
      "T",
      ";",
      "<M-;>",
      { "x", mode = "o" },
      { "X", mode = "o" },
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
  -- TODO: Add more keys & replace above jump plugins
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          -- TODO: When not matched, flash.nvim will make vim exit search mode. Disable it for now.
          -- Ref: https://github.com/folke/flash.nvim/issues/85
          enabled = false,
        },
      },
    },
    keys = {
      {
        "<Leader>f",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<Leader>F",
        mode = { "n", "o", "x" },
        function()
          -- show labeled treesitter nodes around the cursor
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          -- jump to a remote location to execute the operator
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "<Leader>R",
        mode = { "n", "o", "x" },
        function()
          -- show labeled treesitter nodes around the search matches
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<Space>j",
        mode = { "n", "o", "x" },
        function()
          -- jump to a line
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          })
        end,
        desc = "Jump to a line",
      },
      {
        -- NOTE: Identical to `<Space>j` for muscle memory
        "<Space>k",
        mode = { "n", "o", "x" },
        function()
          -- jump to a line
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^",
          })
        end,
        desc = "Jump to a line",
      },
    },
  },

  -- Search
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", mode = { "n", "o", "x" } },
      { "N", mode = { "n", "o", "x" } },
      { "*", mode = { "n", "o", "x" } },
      { "#", mode = { "n", "o", "x" } },
      { "g*", mode = { "n", "o", "x" } },
      { "g#", mode = { "n", "o", "x" } },
      { "z*", mode = { "n", "o", "x" } },
      { "gz*", mode = { "n", "o", "x" } },
      { "z#", mode = { "n", "o", "x" } },
      { "gz#", mode = { "n", "o", "x" } },
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
      local marks = require("marks")

      -- NOTE: Do not use marks.nvim refresh due to high CPU usage caused by uv timer with 0
      -- timeout that cause huge amount of epoll_pwait() with 0 timeout.
      -- Instead, use "CursorHold" for refresh.
      -- Ref: https://github.com/chentoast/marks.nvim/issues/62
      -- Ref: https://github.com/chentoast/marks.nvim/issues/40#issuecomment-992709453
      marks.setup({
        refresh_interval = 0,
      })

      -- TODO: Add "WinScrolled" event
      local marks_augroup_id = vim.api.nvim_create_augroup("marks_settings", {})
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = marks_augroup_id,
        pattern = "*",
        callback = function()
          marks.refresh()
        end,
      })
    end,
  },

  -- Motion
  {
    "bkad/CamelCaseMotion",
    keys = {
      { "<Leader>mw", mode = { "n", "o", "x" } },
      { "<Leader>mb", mode = { "n", "o", "x" } },
      { "<Leader>me", mode = { "n", "o", "x" } },
      { "<Leader>mge", mode = { "n", "o", "x" } },
      { "cmw", mode = { "o", "x" } },
      { "cmb", mode = { "o", "x" } },
      { "cme", mode = { "o", "x" } },
    },
    config = function()
      map("<Leader>mw", "<Plug>CamelCaseMotion_w")
      map("<Leader>mb", "<Plug>CamelCaseMotion_b")
      map("<Leader>me", "<Plug>CamelCaseMotion_e")
      map("<Leader>mge", "<Plug>CamelCaseMotion_ge")

      omap("cmw", "<Plug>CamelCaseMotion_iw", "silent")
      xmap("cmw", "<Plug>CamelCaseMotion_iw", "silent")
      omap("cmb", "<Plug>CamelCaseMotion_ib", "silent")
      xmap("cmb", "<Plug>CamelCaseMotion_ib", "silent")
      omap("cme", "<Plug>CamelCaseMotion_ie", "silent")
      xmap("cme", "<Plug>CamelCaseMotion_ie", "silent")
    end,
  },

  {
    "haya14busa/vim-edgemotion",
    keys = {
      { "<Space><Space>j", mode = { "n", "o", "x" } },
      { "<Space><Space>k", mode = { "n", "o", "x" } },
    },
    config = function()
      map("<Space><Space>j", "<Plug>(edgemotion-j)")
      map("<Space><Space>k", "<Plug>(edgemotion-k)")
    end,
  },

  {
    "jeetsukumaran/vim-indentwise",
    keys = {
      { "[-", mode = { "n", "o", "v" } },
      { "[=", mode = { "n", "o", "v" } },
      { "[+", mode = { "n", "o", "v" } },
      { "]-", mode = { "n", "o", "v" } },
      { "]=", mode = { "n", "o", "v" } },
      { "]+", mode = { "n", "o", "v" } },
      { "[_", mode = { "n", "o", "v" } },
      { "]_", mode = { "n", "o", "v" } },
      { "[%", mode = { "n", "o", "v" } },
      { "]%", mode = { "n", "o", "v" } },
    },
  },
}

return text_navigation
