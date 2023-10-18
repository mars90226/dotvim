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
    commit = "098ef4d7cfb5465e15b29fc087f9db0b81733eec",
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
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.telescope").setup()
    end,
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("project")
    end,
  },
  {
    "jvgrootveld/telescope-zoxide",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("zoxide")
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    event = { "VeryLazy" },
  },
  {
    "TC72/telescope-tele-tabby.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("tele_tabby")
    end,
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").setup({
        extensions = {
          frecency = {
            -- Ref: https://github.com/nvim-telescope/telescope-frecency.nvim#remove-dependency-for-sqlitelua
            use_sqlite = false,
          }
        }
      })
      require("telescope").load_extension("frecency")
    end,
    -- NOTE: Require sqlite3, specifically libsqlite3.so
    -- TODO: Check if use_sqlite is enabled before requiring sqlite.lua
    dependencies = { "kkharji/sqlite.lua" },
  },
  {
    "LinArcX/telescope-command-palette.nvim",
    event = { "VeryLazy" },
    config = function()
      local has_secret_command_palette, secret_command_palette = pcall(require, "secret.command_palette")

      -- NOTE: Command second part is executed by `vim.api.nvim_exec()`
      -- Command third part is 1 means it will execute `:startinsert!` after second part is executed
      require("telescope").setup({
        extensions = {
          command_palette = {
            {
              "File",
              { "entire selection (C-a)", ':call feedkeys("GVgg")' },
              { "save current file (C-s)", ":w" },
              { "save all files (C-A-s)", ":wa" },
              { "quit (C-q)", ":qa" },
              { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
              { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
              { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
              { "files (C-f)", ":lua require('telescope.builtin').find_files()", 1 },
            },
            {
              "Help",
              { "tips", ":help tips" },
              { "cheatsheet", ":help index" },
              { "tutorial", ":help tutor" },
              { "summary", ":help summary" },
              { "quick reference", ":help quickref" },
              { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
            },
            {
              "Vim",
              { "reload vimrc", ":source $MYVIMRC" },
              { "check health", ":checkhealth" },
              { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
              { "commands", ":lua require('telescope.builtin').commands()" },
              { "command history", ":lua require('telescope.builtin').command_history()" },
              { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
              { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
              { "vim options", ":lua require('telescope.builtin').vim_options()" },
              { "keymaps", ":lua require('telescope.builtin').keymaps()" },
              { "buffers", ":Telescope buffers" },
              { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
              { "windows", ":Telescope tele_tabby list" },
              { "paste mode", ":set paste!" },
              { "cursor line", ":set cursorline!" },
              { "cursor column", ":set cursorcolumn!" },
              { "spell checker", ":set spell!" },
              { "relative number", ":set relativenumber!" },
              { "search highlighting (F12)", ":set hlsearch!" },
              { "toggle fold", ":ToggleFold" },
              { "toggle indent", ":ToggleIndent" },
              { "terminal in split", ":new | terminal" },
              { "terminal in tab", ":tabedit | terminal" },
              { "terminal in vertical split", ":vnew | terminal" },
            },
          },
        },
      })

      require("telescope").load_extension("command_palette")

      if has_secret_command_palette then
        secret_command_palette.setup()
      end

      require("vimrc.plugins.command_palette").setup()
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("undo")
    end,
  },
  {
    "molecule-man/telescope-menufacture",
    event = { "VeryLazy" },
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  },
  {
    "aaronhallaert/advanced-git-search.nvim",
    event = { "VeryLazy" },
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
    event = { "VeryLazy" },
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
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('vimrc.plugins.mini').setup()
    end,
  },

  -- Bookmarks
  {
    "ThePrimeagen/harpoon",
    event = { "VeryLazy" },
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
      vim.g.gutentags_ctags_exclude = { ".git", "node_modules", ".ccls-cache", "*.mypy_cache*", ".venv", "*.min.js", "*.min.css" }

      if vim.g.gutentags_secret_ctags_exclude ~= nil then
        vim.g.gutentags_ctags_exclude = utils.table_concat(vim.g.gutentags_ctags_exclude, vim.g.gutentags_secret_ctags_exclude)
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
    event = { "VeryLazy" },
    config = function()
      nnoremap("=-", "<Cmd>lua require('nvim-window').pick()<CR>", "silent")
    end,
  },

  {
    "rgroli/other.nvim",
    event = { "VeryLazy" },
    config = function()
      require("vimrc.plugins.other").setup()
    end,
  },
}

return file_navigation
