local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local file_navigation = {
  -- Sources
  -- TODO: Raise neomru limit
  {
    "Shougo/neomru.vim",
    config = function()
      vim.g["neomru#do_validate"] = 0
      vim.g["neomru#update_interval"] = 60 -- NOTE: 60 seconds
    end,
  },
  -- Yank
  {
    "gbprod/yanky.nvim",
    -- TODO: Only lazy load in WSL
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      local mapping = require("yanky.telescope.mapping")
      local slow_system_clipboard = vim.fn.has("wsl") == 1

      require("yanky").setup({
        picker = {
          telescope = {
            mappings = {
              default = mapping.put("p"),
              i = {
                ["<C-X>"] = mapping.delete(),
              },
              n = {
                d = mapping.delete(),
              },
            },
          },
        },
        system_clipboard = {
          sync_with_ring = not slow_system_clipboard,
        },
        highlight = {
          on_put = false,
          on_yank = false,
        },
      })

      require("telescope").load_extension("yank_history")
    end,
  },

  -- Finders
  -- fzf
  -- fzf#install() only install binary
  -- TODO: This install fzf inside lazy.nvim plugin folder
  -- Need to change corresponding script that try to use fzf in ~/.fzf
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
    config = function()
      require("vimrc.plugins.fzf").setup()
    end,
  },
  "junegunn/fzf.vim",
  "stsewd/fzf-checkout.vim",

  -- telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    config = function()
      require("vimrc.plugins.telescope").setup()
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
      { "<Space>t0", desc = "Telescope file_browser" },
      { "<Space>t)", desc = "Telescope file_browser in current file folder" },
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    keys = {
      { "<Space>t<C-P>", desc = "Telescope project" },
    },
    config = function()
      require("telescope").load_extension("project")
    end,
  },
  {
    "jvgrootveld/telescope-zoxide",
    keys = {
      { "<Space>tz", desc = "Telescope zoxide list" },
    },
    config = function()
      require("telescope").load_extension("zoxide")
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    cmd = { "Cheatsheet", "CheatsheetEdit" },
    keys = {
      { "<Leader><Tab>", desc = "Cheatsheet" },
    },
  },
  {
    "TC72/telescope-tele-tabby.nvim",
    keys = {
      { "<Space>tw", desc = "Telescope tele-tabby list" },
    },
    config = function()
      require("telescope").load_extension("tele_tabby")
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    keys = {
      { "<Space>tI", desc = "Telescope live_grep_args" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    -- TODO: Disabled as telescope-frecency.nvim loading to slow
    enabled = false,
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("frecency")

      vim.api.nvim_create_user_command("FrecencyRemovePattern", function(opts)
        require("vimrc.plugins.frecency").remove_pattern(opts.fargs[1])
      end, { nargs = 1 })
    end,
  },
  -- FIXME: Seems not working now
  -- This plugin is archived, author suggest using which-key.nvim instead
  -- FIXME: Cannot lazy load on keys as the key mapping disappear when first command_palette is called
  {
    "LinArcX/telescope-command-palette.nvim",
    event = { "VeryLazy" },
    -- keys = {
    --   { "<Space>mm", desc = "Telescope command_palette" },
    --   { "<C-X><C-Z>", mode = { "c" }, desc = "Telescope command_palette" },
    --   { "<M-m><M-m>", mode = { "t" }, desc = "Telescope command_palette" },
    --   { "<M-q><M-m>", mode = { "t" }, desc = "Telescope command_palette in nested neovim" },
    --   { "<M-m><M-M>", mode = { "t" }, desc = "CommandPalette" },
    --   { "<M-q><M-M>", mode = { "t" }, desc = "CommandPalette in nested neovim" },
    -- },
    config = function()
      local has_secret_command_palette, secret_command_palette = pcall(require, "secret.command_palette")

      require("telescope").load_extension("command_palette")

      if has_secret_command_palette then
        secret_command_palette.setup()
      end

      require("vimrc.plugins.command_palette").setup()
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    keys = {
      { "<Space>tU", desc = "Telescope undo" },
    },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
  -- TODO: Lazy load on keys
  -- FIXME: Lazy load on keys conflict with wihch-key.nvim?
  {
    "molecule-man/telescope-menufacture",
    event = { "VeryLazy" },
    -- keys = {
    --   { "<Space>tf", desc = "Telescope menufacture find_files" },
    --   { "<Space>ti", desc = "Telescope menufacture live_grep" },
    --   { "<Space>te", desc = "Telescope menufacture grep_string with folder & pattern" },
    --   { "<Space>tk", mode = { "n", "x" }, desc = "Telescope menufacture grep_string with cword or visual selection" },
    --   { "<Space>tK", desc = "Telescope menufacture grep_string with cWORD" },
    --   { "<Space>t8", mode = { "n", "x" }, desc = "Telescope menufacture grep_string with cword or visual selection with word boundary" },
    --   { "<Space>t*", desc = "Telescope menufacture grep_string with cWORD with word boundary" },
    --   { "<Space>tr", desc = "Telescope menufacture grep_string with pattern" },
    -- },
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = { "AdvancedGitSearch" },
    keys = {
      { "<Space>ab", desc = "AdvancedGitSearch diff_branch_file" },
      { "<Space>al", mode = { "n", "x" }, desc = "AdvancedGitSearch diff_commit_line" },
      { "<Space>af", desc = "AdvancedGitSearch diff_commit_file" },
      { "<Space>as", desc = "AdvancedGitSearch search_log_content" },
      { "<Space>aS", desc = "AdvancedGitSearch search_log_content_file" },
      { "<Space>ar", desc = "AdvancedGitSearch checkout_reflog" },
      { "<Space>aa", desc = "AdvancedGitSearch show_custom_functions" },
    },
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    cond = choose.is_enabled_plugin("telescope-fzf-native.nvim"),
    event = { "VeryLazy" },
    build = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "Marskey/telescope-sg",
    cond = plugin_utils.is_executable("sg"),
    keys = {
      { "<Space>ag", desc = "Telescope ast_grep" },
    },
    config = function()
      require("telescope").load_extension("ast_grep")
    end,
  },

  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    event = { "VeryLazy" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("vimrc.plugins.fzf_lua").setup()
    end,
  },

  -- mini.nvim
  -- NOTE: mini.nvim has many modules, currently the most used is mini.pick, so place it here.
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("vimrc.plugins.mini").setup()
    end,
  },

  -- Bookmarks
  -- TODO: Switch to harpoon2
  -- Ref: https://github.com/ThePrimeagen/harpoon/tree/harpoon2
  {
    "ThePrimeagen/harpoon",
    keys = { "<Leader>hm", "<Leader>hM", "<Leader>h`", "<Leader>hh", "<Leader>h]", "<Leader>h[" },
    config = function()
      require("harpoon").setup({})

      require("telescope").load_extension("harpoon")

      nnoremap("<Leader>hm", [[<Cmd>lua require("harpoon.mark").add_file()<CR>]])
      nnoremap("<Leader>hM", [[<Cmd>lua require("harpoon.mark").rm_file()<CR>]])
      nnoremap("<Leader>h`", [[<Cmd>lua require("harpoon.mark").toggle_file()<CR>]])
      nnoremap("<Leader>hh", [[<Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]])
      nnoremap("<Leader>h]", [[<Cmd>lua require("harpoon.ui").nav_next()<CR>]])
      nnoremap("<Leader>h[", [[<Cmd>lua require("harpoon.ui").nav_prev()<CR>]])
    end,
  },

  -- Goto Definitions
  {
    "pechorin/any-jump.nvim",
    cmd = { "AnyJump", "AnyJumpArg", "AnyJumpVisual" },
    keys = { "<Leader>aj", "<Leader>aa" },
    config = function()
      vim.g.any_jump_window_width_ratio, vim.g.any_jump_window_height_ratio =
        unpack(vim.fn["vimrc#float#get_default_ratio"]())
      vim.g.any_jump_window_top_offset = vim.fn["vimrc#float#calculate_pos_from_ratio"](
        vim.g.any_jump_window_width_ratio,
        vim.g.any_jump_window_height_ratio
      )[2]

      vim.g.any_jump_disable_default_keybindings = 1

      nnoremap("<Leader>aj", "<Cmd>AnyJump<CR>")
      nnoremap("<Leader>aa", "<Cmd>AnyJumpArg<Space>")
      xnoremap("<Leader>aj", "<Cmd>AnyJumpVisual<CR>")
      nnoremap("<Leader>ab", "<Cmd>AnyJumpBack<CR>")
      nnoremap("<Leader>al", "<Cmd>AnyJumpLastResults<CR>")
    end,
  },

  -- Automatically update tags
  {
    "ludovicchabant/vim-gutentags",
    event = { "VeryLazy" },
    init = function()
      -- Don't update cscope, workload is too heavy
      vim.g.gutentags_modules = { "ctags" }
      vim.g.gutentags_ctags_exclude =
        { ".git", "node_modules", ".ccls-cache", "*.mypy_cache*", ".venv", "*.min.js", "*.min.css" }

      if vim.g.gutentags_secret_ctags_exclude ~= nil then
        vim.g.gutentags_ctags_exclude =
          utils.table_concat(vim.g.gutentags_ctags_exclude, vim.g.gutentags_secret_ctags_exclude)
      end
    end,
  },

  -- Search/Replace
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    keys = {
      "<Space>S",
      { "<Space>sw", mode = { "n", "v" } },
      "<Space>s'",
    },
    config = function()
      -- Ref: https://github.com/nvim-pack/nvim-spectre/issues/131
      require("spectre").setup({
        highlight = {
          ui = "String",
          search = "SpectreSearch",
          replace = "DiffAdd", -- NOTE: default it DiffDelete, which is almost always red
        },
      })

      nnoremap("<Space>S", [[:lua require('spectre').open()<CR>]])

      -- Search current word
      nnoremap("<Space>sw", [[:lua require('spectre').open_visual({select_word=true})<CR>]])
      vnoremap("<Space>sw", [[:lua require('spectre').open_visual()<CR>]])

      -- Search in current file
      nnoremap("<Space>s'", [[viw:lua require('spectre').open_file_search()<CR>]])
    end,
  },

  -- Window Switching
  {
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    keys = { "=-" },
    config = function()
      nnoremap("=-", "<Cmd>lua require('nvim-window').pick()<CR>", "silent")
    end,
  },

  {
    "rgroli/other.nvim",
    cmd = { "Other", "OtherTabNew", "OtherSplit", "OtherVSplit", "OtherClose" },
    keys = { "<Leader>oo", "<Leader>os", "<Leader>ov", "<Leader>oc" },
    config = function()
      require("vimrc.plugins.other").setup()
    end,
  },
}

return file_navigation
