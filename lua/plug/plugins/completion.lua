local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local completion = {}

completion.setup_mapping = function()
  -- diagraph
  inoremap("<M-K>", [[<C-K>]])
end

completion.startup = function(use)
  completion.setup_mapping()

  -- Completion
  use({
    "hrsh7th/nvim-cmp",
    requires = vim.tbl_filter(function(plugin_spec)
      return plugin_spec ~= nil
    end, {
      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
        module = "luasnip",
        config = function()
          require("vimrc.plugins.luasnip").setup()

          -- FIXME: nvim-cmp doesn't show new snippets, but it actually reloaded
          -- FIXME: Fix ReloadLuaSnip
          -- vim.cmd([[command! ReloadLuaSnip call vimrc#source("after/plugin/luasnip.lua")]])
        end,
      },
      -- Formatting
      "onsails/lspkind-nvim",
      -- Completion Sources
      { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", module = "cmp_nvim_lsp" },
      { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
      { "octaltree/cmp-look", after = "nvim-cmp" },
      { "hrsh7th/cmp-calc", after = "nvim-cmp" },
      plugin_utils.check_enabled_plugin({ "ray-x/cmp-treesitter", after = "nvim-cmp" }, "nvim-treesitter"),
      {
        "petertriho/cmp-git",
        after = "nvim-cmp",
        config = function()
          require("cmp_git").setup()
        end,
      },
      { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
      plugin_utils.check_executable({ "lukas-reineke/cmp-rg", after = "nvim-cmp" }, "rg"),
      { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
    }),
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("vimrc.plugins.nvim_cmp").setup()

      -- Setup lspconfig in mason.nvim config function
    end,
  })

  -- Snippets source
  use("rafamadriz/friendly-snippets")

  -- Auto Pairs
  use({
    "windwp/nvim-autopairs",
    after = "nvim-cmp",
    config = function()
      ---@diagnostic disable-next-line -- packer.nvim will cache config function and cannot use outer local variables
      local choose = require("vimrc.choose")

      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup({
        check_ts = choose.is_enabled_plugin("nvim-treesitter"),
        fast_wrap = {},
      })

      -- nvim-cmp integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

      -- Rules
      -- npairs.add_rule(Rule("%w<", ">", "cpp"):use_regex(true))
      -- npairs.add_rule(Rule("%w<", ">", "rust"):use_regex(true))
      npairs.add_rule(Rule("<", ">", "xml"))
    end,
  })

  if choose.is_enabled_plugin("nvim-treesitter") then
    -- TODO: use 'abecodes/tabout.nvim'
    -- ref: https://github.com/windwp/nvim-autopairs/issues/167
    use({
      "abecodes/tabout.nvim",
      config = function()
        require("tabout").setup({
          tabkey = "<M-n>", -- key to trigger tabout, set to an empty string to disable
          backwards_tabkey = "<M-N>", -- key to trigger backwards tabout, set to an empty string to disable
        })
      end,
      wants = { "nvim-treesitter" }, -- or require if not used so far
      after = { "nvim-cmp" }, -- if a completion plugin is using tabs load it before
    })
  end
end

return completion
