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
      vim.fn["vimrc#source"]("vimrc/plugins/fzf.vim")
    end,
  })
  use("junegunn/fzf.vim")
  use("stsewd/fzf-checkout.vim")

  -- telescope.nvim
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/telescope.vim")
      require("vimrc.plugins.telescope")
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
      vim.fn["vimrc#source"]("vimrc/plugins/fzf_lua.vim")
    end,
  })

  -- Bookmarks
  use({
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({})

      require("telescope").load_extension("harpoon")

      nnoremap("<Leader>hm", [[<Cmd>lua require("harpoon.mark").add_file()<CR>]])
      nnoremap("<Leader>hd", [[<Cmd>lua require("harpoon.mark").rm_file()<CR>]])
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

  use({
    "brooth/far.vim",
    cmd = { "Far", "F", "Farp", "Farr", "Farf" },
    config = function()
      if vim.fn.has("python3") == 1 then
        if vim.fn.executable("rg") == 1 then
          vim.g["far#source"] = "rgnvim"
        elseif vim.fn.executable("ag") == 1 then
          vim.g["far#source"] = "agnvim"
        elseif vim.fn.executable("ack") == 1 then
          vim.g["far#source"] = "acknvim"
        end
      end

      vim.g["far#ignore_files"] = { vim.env.HOME .. "/.gitignore" }

      vim.g["far#mapping"] = {
        replace_do = "S",
      }
    end,
  })

  use({
    "wincent/ferret",
    cmd = { "Ack", "Lack", "Back", "Black", "Quack", "Acks", "Lacks" },
    config = function()
      vim.g.FerretMap = 0
      vim.g.FerretQFCommands = 0

      nmap("<Leader>fa", "<Plug>(FerretAck)")
      nmap("<Leader>fl", "<Plug>(FerretLack)")
      nmap("<Leader>fs", "<Plug>(FerretAckWord)")
      nmap("<Leader>fr", "<Plug>(FerretAcks)")
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
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          -- custom mapping
          -- TODO: Simplify the pattern
          -- Same folder
          {
            pattern = "/(.*).h$",
            target = "/%1\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/(.*).cpp$",
            target = "/%1.h",
          },
          {
            pattern = "/(.*).c$",
            target = "/%1.h",
          },
          -- 3-level folder
          {
            pattern = "/src/include/(.*)/(.*)/(.*).h$",
            target = "/src/%1/lib/%2/%3\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/src/(.*)/lib/(.*)/(.*).cpp$",
            target = "/src/include/%1/%2/%3.h",
          },
          {
            pattern = "/src/(.*)/lib/(.*)/(.*).c$",
            target = "/src/include/%1/%2/%3.h",
          },
          -- 2-level folder
          {
            pattern = "/src/include/.*/(.*)/(.*).h$",
            target = "/src/lib/%1/%2\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/src/lib/(.*)/(.*).cpp$",
            target = "/src/include/*/%1/%2.h",
          },
          {
            pattern = "/src/lib/(.*)/(.*).c$",
            target = "/src/include/*/%1/%2.h",
          },
          -- 1-level folder
          {
            pattern = "/include/.*/(.*).h$",
            target = "/lib/%1\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/lib/(.*).cpp$",
            target = "/include/*/%1.h",
          },
          {
            pattern = "/lib/(.*).c$",
            target = "/include/*/%1.h",
          },
          -- 2-level lib prefix folder
          {
            pattern = "/src/include/.*/(.*)/(.*).h$",
            target = "/src/lib-%1/%2\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/src/lib%-(.*)/(.*).cpp$",
            target = "/src/include/*/%1/%2.h",
          },
          {
            pattern = "/src/lib%-(.*)/(.*).c$",
            target = "/src/include/*/%1/%2.h",
          },
          -- 2-level no src folder
          {
            pattern = "/include/(.*)/(.*).h$",
            target = "/%1/%2\\(.cpp\\|.c\\)",
          },
          {
            pattern = "/(.*)/(.*).cpp$",
            target = "/include/*/%1/%2.h",
          },
          {
            pattern = "/(.*)/(.*).c$",
            target = "/include/*/%1/%2.h",
          },
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function(inputString)
            return inputString:lower()
          end,
        },
      })

      nnoremap("<Leader>oo", "<Cmd>:Other<CR>", "silent")
      nnoremap("<Leader>os", "<Cmd>:OtherSplit<CR>", "silent")
      nnoremap("<Leader>ov", "<Cmd>:OtherVSplit<CR>", "silent")
      nnoremap("<Leader>oc", "<Cmd>:OtherClear<CR>", "silent")
    end,
  })
end

return file_navigation
