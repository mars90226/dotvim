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
    cond = not utils.is_light_vim_mode(),
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
      nnoremap([[<Space>tn]], [[<Cmd>Telescope yank_history<CR>]], { desc = "Telescope yank_history" })
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
      {
        "<Space>t0",
        [[<Cmd>Telescope file_browser<CR>]],
        desc = "Telescope file_browser",
      },
      {
        "<Space>t)",
        [[<Cmd>execute 'Telescope file_browser path='.expand('%:h')<CR>]],
        desc = "Telescope file_browser in current file folder",
      },
    },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    -- TODO: May need to adjust key mapping as used for project bookmark
    keys = {
      { "<Space>t<C-P>", [[<Cmd>Telescope project<CR>]], desc = "Telescope project" },
    },
    config = function()
      require("telescope").load_extension("project")
    end,
  },
  {
    "jvgrootveld/telescope-zoxide",
    keys = {
      { "<Space>tz", [[<Cmd>Telescope zoxide list<CR>]], desc = "Telescope zoxide list" },
    },
    config = function()
      require("telescope").load_extension("zoxide")
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    cmd = { "Cheatsheet", "CheatsheetEdit" },
    keys = {
      { "<Leader><Tab><Tab>", [[<Cmd>Cheatsheet<CR>]], desc = "Cheatsheet" },
    },
  },
  {
    "TC72/telescope-tele-tabby.nvim",
    keys = {
      { "<Space>tw", [[<Cmd>Telescope tele_tabby list<CR>]], desc = "Telescope tele-tabby list" },
    },
    config = function()
      require("telescope").load_extension("tele_tabby")
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    keys = {
      { "<Space>tI", [[<Cmd>Telescope live_grep_args<CR>]], desc = "Telescope live_grep_args" },
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
  -- TODO: This plugin is archived, author suggest using which-key.nvim instead
  {
    "LinArcX/telescope-command-palette.nvim",
    keys = {
      -- Normal mode
      { "<Space>mm",  [[<Cmd>Telescope command_palette<CR>]], desc = "Telescope command_palette" },

      -- Command-line mode
      { "<C-X><C-Z>", mode = { "c" },                         [[<C-C><Cmd>Telescope command_palette<CR>]],       desc = "Telescope command_palette" },
      { "<C-X><C-S>", mode = { "c" },                         [[<C-C><Cmd>CommandPalette<CR>]],                  desc = "Telescope command palette" },

      -- Terminal mode
      { "<M-m><M-m>", mode = { "t" },                         [[<C-\><C-N>:Telescope command_palette<CR>]],      desc = "Telescope command_palette" },
      { "<M-m><M-M>", mode = { "t" },                         [[<C-\><C-N>:CommandPalette<CR>]],                 desc = "CommandPalette" },

      -- Terminal mode in nested neovim
      { "<M-q><M-m>", mode = { "t" },                         [[<C-\><C-\><C-N>:Telescope command_palette<CR>]], desc = "Telescope command_palette in nested neovim" },
      { "<M-q><M-M>", mode = { "t" },                         [[<C-\><C-\><C-N>:CommandPalette<CR>]],            desc = "CommandPalette in nested neovim" },
    },
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
      { "<Space>tU", [[<Cmd>Telescope undo<CR>]], desc = "Telescope undo" },
    },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
  {
    "molecule-man/telescope-menufacture",
    event = { "VeryLazy" },
    keys = {
      {
        [[<Space>tf]],
        [[<Cmd>Telescope menufacture find_files<CR>]],
        desc = "Telescope menufacture find_files",
      },
      {
        [[<Space>ti]],
        [[<Cmd>Telescope menufacture live_grep<CR>]],
        desc = "Telescope menufacture live_grep",
      },
      {
        [[<Space>te]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>]],
        desc = "Telescope menufacture grep_string with folder & pattern",
      },
      {
        [[<Space>tk]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.expand('<cword>')<CR>]],
        desc = "Telescope menufacture grep_string with cword or visual selection",
      },
      {
        [[<Space>tk]],
        mode = { "x" },
        [[:<C-U>execute 'Telescope menufacture grep_string use_regex=true search='.vimrc#utility#get_visual_selection()<CR>]],
        desc = "Telescope menufacture grep_string with cword or visual selection",
      },
      {
        [[<Space>tK]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.expand('<cWORD>')<CR>]],
        desc = "Telescope menufacture grep_string with cWORD",
      },
      {
        [[<Space>t8]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>]],
        desc = "Telescope menufacture grep_string with cword or visual selection with word boundary",
      },
      {
        [[<Space>t8]],
        mode = { "x" },
        [[:<C-U>execute 'Telescope menufacture grep_string use_regex=true search=\b'.vimrc#utility#get_visual_selection().'\b'<CR>]],
        desc = "Telescope menufacture grep_string with cword or visual selection with word boundary",
      },
      {
        [[<Space>t*]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>]],
        desc = "Telescope menufacture grep_string with cWORD with word boundary",
      },
      {
        [[<Space>tr]],
        [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.input('Rg: ')<CR>]],
        desc = "Telescope menufacture grep_string with pattern",
      },
    },
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    cmd = { "AdvancedGitSearch" },
    keys = {
      {
        [[<Space>ab]],
        [[<Cmd>AdvancedGitSearch diff_branch_file<CR>]],
        desc = "AdvancedGitSearch diff_branch_file",
      },
      {
        [[<Space>al]],
        [[<Cmd>AdvancedGitSearch diff_commit_line<CR>]],
        desc = "AdvancedGitSearch diff_commit_line",
      },
      {
        [[<Space>al]],
        mode = { "x" },
        [[:<C-U>AdvancedGitSearch diff_commit_line<CR>]],
        desc = "AdvancedGitSearch diff_commit_line",
      },
      {
        [[<Space>af]],
        [[<Cmd>AdvancedGitSearch diff_commit_file<CR>]],
        desc = "AdvancedGitSearch diff_commit_file",
      },
      {
        [[<Space>as]],
        [[<Cmd>AdvancedGitSearch search_log_content<CR>]],
        desc = "AdvancedGitSearch search_log_content",
      },
      {
        [[<Space>aS]],
        [[<Cmd>AdvancedGitSearch search_log_content_file<CR>]],
        desc = "AdvancedGitSearch search_log_content_file",
      },
      {
        [[<Space>ar]],
        [[<Cmd>AdvancedGitSearch checkout_reflog<CR>]],
        desc = "AdvancedGitSearch checkout_reflog",
      },
      {
        [[<Space>aa]],
        [[<Cmd>AdvancedGitSearch show_custom_functions<CR>]],
        desc = "AdvancedGitSearch show_custom_functions",
      },
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
      { "<Space>ag", [[<Cmd>Telescope ast_grep<CR>]], desc = "Telescope ast_grep" },
    },
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
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = {
      scope = "git_branch",
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      { "<Leader>mm", "<cmd>Grapple toggle<cr>",          desc = "Grapple toggle tag" },
      { "<Leader>mt", "<cmd>Grapple toggle_tags<cr>",     desc = "Grapple open tags window" },
      { "<Leader>ms", "<cmd>Telescope grapple tags<cr>",  desc = "Grapple select tags by Telescope" },
      { "]h",         "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "[h",         "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
    },
    config = function(_, opts)
      require("grapple").setup(opts)

      require("telescope").load_extension("grapple")
    end
  },

  -- Goto Definitions
  {
    "pechorin/any-jump.nvim",
    cmd = { "AnyJump", "AnyJumpArg", "AnyJumpVisual" },
    keys = {
      { "<Leader>aj", "<Cmd>AnyJump<CR>",            desc = "AnyJump" },
      { "<Leader>aa", "<Cmd>AnyJumpArg<Space>",      desc = "AnyJump with args" },
      { "<Leader>aj", ":AnyJumpVisual<CR>",          mode = { "x" },               desc = "AnyJump visual" }, -- NOTE: Need to use `:` to make it work in visual mode
      { "<Leader>ab", "<Cmd>AnyJumpBack<CR>",        desc = "AnyJump back" },
      { "<Leader>al", "<Cmd>AnyJumpLastResults<CR>", desc = "AnyJump last results" },
    },
    config = function()
      vim.g.any_jump_window_width_ratio, vim.g.any_jump_window_height_ratio =
          unpack(vim.fn["vimrc#float#get_default_ratio"]())
      vim.g.any_jump_window_top_offset = vim.fn["vimrc#float#calculate_pos_from_ratio"](
        vim.g.any_jump_window_width_ratio,
        vim.g.any_jump_window_height_ratio
      )[2]

      vim.g.any_jump_disable_default_keybindings = 1
    end,
  },

  -- Automatically update tags
  {
    "ludovicchabant/vim-gutentags",
    cond = choose.is_enabled_plugin("vim-gutentags"),
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
      {
        "<Space>S",
        [[<Cmd>lua require('spectre').toggle()<CR>]],
        desc = "Spectre - toggle",
      },
      {
        "<Space>sw",
        [[<Cmd>lua require('spectre').open_visual({select_word=true})<CR>]],
        desc = "Spectre - search current word",
      },
      {
        "<Space>sw",
        [[<Esc><Cmd>lua require('spectre').open_visual()<CR>]],
        mode = { "v" },
        desc = "Spectre - search current word",
      },
      {
        "<Space>s'",
        [[<Cmd>lua require('spectre').open_file_search({select_word=true})<CR>]],
        desc = "Spectre - search on current file",
      },
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
    end,
  },
  -- TODO: Update key mapping to use new flags
  {
    'MagicDuck/grug-far.nvim',
    keys = {
      { "<Space>go", [[<Cmd>GrugFar<CR>]],                                                                                       desc = "grug-far - open" },
      {
        "<Space>gw",
        function()
          require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "grug-far - search current word"
      },
      {
        "<Space>g5",
        function()
          require('grug-far').grug_far({ prefills = { flags = vim.fn.expand("%") } })
        end,
        desc = "grug-far - search in current file"
      },
      {
        "<Space>g'",
        function()
          require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>"), flags = vim.fn.expand("%") } })
        end,
        desc = "grug-far - search on current file"
      },
      -- NOTE: It seems to use '< and '> to get visual selection, so cannot use lua function as it will use the last visual selection.
      { "<Space>g'", [[:<C-U>lua require('grug-far').with_visual_selection({ prefills = { flags = vim.fn.expand("%") } })<CR>]], mode = { "v" },          desc = "grug-far - search on current file" },
    },
    config = function()
      require('grug-far').setup({})
    end
  },

  -- Window Switching
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    version = "2.*",
    keys = { "=-" },
    config = function()
      -- TODO: Check config example in neo-tree.nvim README.md
      -- Ref: https://github.com/nvim-neo-tree/neo-tree.nvim
      require("window-picker").setup({
        hint = "floating-big-letter",
      })
      nnoremap("=-", function()
        local window_id = require("window-picker").pick_window()
        vim.api.nvim_set_current_win(window_id)
      end, { silent = true, desc = "Switch to window by window-picker" })
    end,
  },

  -- Alternative buffer
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
