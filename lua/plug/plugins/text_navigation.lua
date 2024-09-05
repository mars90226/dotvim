local utils = require("vimrc.utils")

local text_navigation = {
  -- Match
  {
    "andymass/vim-matchup",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 1000
      vim.g.matchup_matchparen_deferred_hide_delay = 1000
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchparen_insert_timeout = 20
      vim.g.matchup_matchparen_nomode = "i"
      -- we already have nvim-treesitter-context
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_surround_enabled = 1
    end,
    -- NOTE: nvim-treesitter config is in nvim_treesitter.lua
  },

  -- Jump
  {
    "smoka7/hop.nvim",
    keys = {
      -- NOTE: When in diffview.nvim buffer, `HopWord` ignore a few characters as if it's
      -- horizontally scrolled.
      -- NOTE: Use flash.nvim instead
      -- { "<Space>w", mode = { "n", "o", "x" } },
      { "<Space>e",       mode = { "n", "o", "x" } },
      { "<Space>;",       mode = { "n", "o", "x" } },
      { "<LocalLeader>f", mode = { "n", "o", "x" } },
      { "<LocalLeader>l", mode = { "n", "o", "x" } },
      -- { "<Space>j", mode = { "n", "o", "x" } },
      -- { "<Space>k", mode = { "n", "o", "x" } },
      { "<Space>cw",      mode = { "n", "o", "x" } },
    },
    config = function()
      -- vim.keymap.set("", "<Space>w", "<Cmd>HopWord<CR>", { remap = true })
      vim.keymap.set("", "<Space>e", [=[<Cmd>lua require('hop').hint_patterns({}, [[\k\>]])<CR>]=], { remap = true })
      vim.keymap.set("", "<Space>;", "<Cmd>HopPattern<CR>", { remap = true })
      vim.keymap.set("", "<LocalLeader>f", "<Cmd>HopChar1<CR>", { remap = true })
      vim.keymap.set("", "<LocalLeader>l", "<Cmd>HopLine<CR>", { remap = true })
      -- vim.keymap.set("", "<Space>j", "<Cmd>HopLineAC<CR>", { remap = true })
      -- vim.keymap.set("", "<Space>k", "<Cmd>HopLineBC<CR>", { remap = true })
      vim.keymap.set("", "<Space>cw", "<Cmd>HopCamelCase<CR>", { remap = true })

      require("hop").setup({})
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

      vim.keymap.set("", ";", "<Plug>Lightspeed_omni_s", { remap = true })
      -- To avoid 'S' being mapped
      -- TODO: Use better way to avoid 'S' being mapped
     vim.keymap.set(" ", "S", "S")

      -- NOTE: lightspeed.nvim will map 'gs', which may cause a little problem with vim-caser mapping
      -- To avoid 'S' being mapped
      -- TODO: Use better way to avoid 'gs' being mapped
     vim.keymap.set(" ", "gs", "gs")
      nmap("<M-;>", "<Plug>Lightspeed_omni_gs")
    end,
  },
  {
    "rlane/pounce.nvim",
    cmd = { "Pounce" },
    keys = { "<Leader>/" },
    config = function()
      vim.keymap.set("", "<Leader>/", [[<Cmd>Pounce<CR>]], { remap = true })
    end,
  },
  -- TODO: Add more keys & replace above jump plugins
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          -- TODO: When not matched, flash.nvim will make vim exit search mode. Disable it for now.
          -- This seems to be fixed, but a simple test shows that it's still happening.
          -- Ref: https://github.com/folke/flash.nvim/pull/277
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
      {
        "<Space>w",
        mode = { "n", "o", "x" },
        function()
          -- jump to a word
          require("vimrc.plugins.flash").jump_word()
        end,
        desc = "Jump to a word",
      },
    },
  },

  -- Search
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n",   mode = { "n", "o", "x" } },
      { "N",   mode = { "n", "o", "x" } },
      { "*",   mode = { "n", "o", "x" } },
      { "#",   mode = { "n", "o", "x" } },
      { "g*",  mode = { "n", "o", "x" } },
      { "g#",  mode = { "n", "o", "x" } },
      { "z*",  mode = { "n", "o", "x" } },
      { "gz*", mode = { "n", "o", "x" } },
      { "z#",  mode = { "n", "o", "x" } },
      { "gz#", mode = { "n", "o", "x" } },
    },
    dependencies = { "haya14busa/vim-asterisk" },
    config = function()
      require("hlslens").setup({
        float_shadow_blend = 100,
        nearest_float_when = 'never',
      })

       vim.keymap.set("", "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })
       vim.keymap.set("", "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], { silent = true })

      -- vim-asterisk
      vim.keymap.set("", "*", [[<Plug>(asterisk-*)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "#", [[<Plug>(asterisk-#)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "g*", [[<Plug>(asterisk-g*)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "g#", [[<Plug>(asterisk-g#)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "z*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "gz*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "z#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
      vim.keymap.set("", "gz#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], { remap = true })
    end,
  },

  -- Marks
  {
    "chentoast/marks.nvim",
    cond = not utils.is_light_vim_mode(),
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      local marks = require("marks")

      -- NOTE: Increase marks.nvim refresh interval.
      -- Ref: https://github.com/chentoast/marks.nvim/issues/62
      -- Ref: https://github.com/chentoast/marks.nvim/issues/40#issuecomment-992709453
      marks.setup({
        refresh_interval = 1000,
      })
    end,
  },

  -- Motion
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "<M-w>",
        "<Cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "<M-b>",
        "<Cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "<M-e>",
        "<Cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "<M-g><M-e>",
        "<Cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
      },
    },
    config = function()
      require("spider").setup({
        subwordMovement = false,
      })
    end,
  },

  {
    "bkad/CamelCaseMotion",
    keys = {
      { "<Leader>mw",  mode = { "n", "o", "x" }, "<Plug>CamelCaseMotion_w",  desc = "CamelCaseMotion w" },
      { "<Leader>mb",  mode = { "n", "o", "x" }, "<Plug>CamelCaseMotion_b",  desc = "CamelCaseMotion b" },
      { "<Leader>me",  mode = { "n", "o", "x" }, "<Plug>CamelCaseMotion_e",  desc = "CamelCaseMotion e" },
      { "<Leader>mge", mode = { "n", "o", "x" }, "<Plug>CamelCaseMotion_ge", desc = "CamelCaseMotion ge" },
      { "zw",          mode = { "o", "x" },      "<Plug>CamelCaseMotion_iw", desc = "CamelCaseMotion iw", silent = true },
      { "ze",          mode = { "o", "x" },      "<Plug>CamelCaseMotion_ie", desc = "CamelCaseMotion ie", silent = true },
      { "zb",          mode = { "o", "x" },      "<Plug>CamelCaseMotion_ib", desc = "CamelCaseMotion ib", silent = true },
    },
  },

  {
    "haya14busa/vim-edgemotion",
    keys = {
      { "<Space><Space>j", mode = { "n", "o", "x" } },
      { "<Space><Space>k", mode = { "n", "o", "x" } },
    },
    config = function()
      vim.keymap.set("", "<Space><Space>j", "<Plug>(edgemotion-j)", { remap = true })
      vim.keymap.set("", "<Space><Space>k", "<Plug>(edgemotion-k)", { remap = true })
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
