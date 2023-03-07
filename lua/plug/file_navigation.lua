local choose = require("vimrc.choose")

local file_navigation = {}

file_navigation.startup = function(use)
  -- Sources
  -- TODO: Raise neomru limit
  use({
    "Shougo/neomru.vim",
    config = function()
      vim.g["neomru#do_validate"] = 0
      vim.g["neomru#update_interval"] = 60 -- NOTE: 60 seconds
    end,
  })
  -- Yank
  use({
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
  })

  -- Finders
  -- fzf
  -- fzf#install() only install binary
  -- TODO: This install fzf inside packer.nvim plugin folder
  -- Need to change corresponding script that try to use fzf in ~/.fzf
  use({
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
    config = function()
      require("vimrc.plugins.fzf").setup()
    end,
  })
  use("junegunn/fzf.vim")
  use("stsewd/fzf-checkout.vim")

  -- telescope.nvim
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("vimrc.plugins.telescope").setup()
    end,
  })
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  })
  use({
    "nvim-telescope/telescope-project.nvim",
    config = function()
      require("telescope").load_extension("project")
    end,
  })
  use({
    "jvgrootveld/telescope-zoxide",
    config = function()
      require("telescope").load_extension("zoxide")
    end,
  })
  use("sudormrfbin/cheatsheet.nvim")
  use({
    "TC72/telescope-tele-tabby.nvim",
    config = function()
      require("telescope").load_extension("tele_tabby")
    end,
  })
  use({
    "nvim-telescope/telescope-live-grep-args.nvim",
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  })
  use({
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require("telescope").load_extension("frecency")
    end,
    -- NOTE: Require sqlite3, specifically libsqlite3.so
    requires = { "kkharji/sqlite.lua" },
  })
  use({
    "LinArcX/telescope-command-palette.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
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

      if has_secret_command_palette then
        secret_command_palette.setup()
      end

      require("vimrc.plugins.command_palette").setup()

      require("telescope").load_extension("command_palette")
    end,
  })
  use({
    "debugloop/telescope-undo.nvim",
    config = function()
      require("telescope").load_extension("undo")
    end,
  })
  use({
    "molecule-man/telescope-menufacture",
    config = function()
      require("telescope").load_extension("menufacture")
    end,
  })
  use({
    "aaronhallaert/advanced-git-search.nvim",
    config = function()
      require("telescope").load_extension("advanced_git_search")
    end,
    requires = {
      "nvim-telescope/telescope.nvim",
      -- to show diff splits and open commits in browser
      "tpope/vim-fugitive",
    },
  })

  if choose.is_enabled_plugin("telescope-fzf-native.nvim") then
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    })
  end

  -- fzf-lua
  use({
    "ibhagwan/fzf-lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("vimrc.plugins.fzf_lua").setup()
    end,
  })

  -- Bookmarks
  use({
    "ThePrimeagen/harpoon",
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
  })

  -- Goto Definitions
  use({
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
  })

  -- Automatically update tags
  use({
    "ludovicchabant/vim-gutentags",
    config = function()
      -- Don't update cscope, workload is too heavy
      vim.g.gutentags_modules = { "ctags" }
      vim.g.gutentags_ctags_exclude = { ".git", "node_modules", ".ccls-cache" }
    end,
  })

  use({
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    keys = { "<Space>S", "<Space>sw", "<Space>s'" },
    config = function()
      -- TODO: Try replace with nvim-oxi
      nnoremap("<Space>S", [[:lua require('spectre').open()<CR>]])

      -- Search current word
      nnoremap("<Space>sw", [[:lua require('spectre').open_visual({select_word=true})<CR>]])
      vnoremap("<Space>ss", [[:lua require('spectre').open_visual()<CR>]])

      -- Search in current file
      nnoremap("<Space>s'", [[viw:lua require('spectre').open_file_search()<CR>]])
    end,
  })

  -- Window Switching
  use({
    "https://gitlab.com/yorickpeterse/nvim-window.git",
    config = function()
      nnoremap("=-", "<Cmd>lua require('nvim-window').pick()<CR>", "silent")
    end,
  })

  use({
    "rgroli/other.nvim",
    config = function()
      require("vimrc.plugins.other").setup()
    end,
  })
end

return file_navigation
