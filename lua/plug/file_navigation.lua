local plugin_utils = require("vimrc.plugin_utils")

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
  use("Shougo/neoyank.vim")
  -- Yank
  use({
    "gbprod/yanky.nvim",
    -- TODO: Only lazy load in WSL
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      local mapping = require("yanky.telescope.mapping")
      local actions = require("telescope.actions")

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
  use({
    "laher/fuzzymenu.vim",
    config = function()
      -- Utility
      vim.fn['vimrc#fuzzymenu#try_add']('ToggleFold', { exec = 'ToggleFold' })
      vim.fn['vimrc#fuzzymenu#try_add']('ToggleIndent', { exec = 'ToggleIndent' })

      -- Terminal
      vim.fn['vimrc#fuzzymenu#try_add']('SplitTerm', { exec = 'new | terminal' })
      vim.fn['vimrc#fuzzymenu#try_add']('TabTerm', { exec = 'tabe | terminal' })
      vim.fn['vimrc#fuzzymenu#try_add']('VerticalTerm', { exec = 'vnew | terminal' })

      -- Mappings
      nmap("<Space>m", [[<Plug>(Fzm)]])
      xmap("<Space>m", [[<Plug>(FzmVisual)]])
    end,
  })

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
    "nvim-telescope/telescope-media-files.nvim",
    config = function()
      require("telescope").load_extension("media_files")
    end,
  })
  use({
    "TC72/telescope-tele-tabby.nvim",
    config = function()
      require("telescope").load_extension("tele_tabby")
    end,
  })

  if plugin_utils.is_enabled_plugin("telescope-fzf-native.nvim") then
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
    keys = { "<Leader>aj" },
    config = function()
      vim.g.any_jump_window_width_ratio, vim.g.any_jump_window_height_ratio = unpack(
        vim.fn["vimrc#float#get_default_ratio"]()
      )
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

      vim.cmd([[augroup any_jump_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd FileType any-jump call vimrc#any_jump#settings()]])
      vim.cmd([[augroup END]])
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
    "windwp/nvim-spectre",
    keys = { "<Space>S", "<Space>sw", "<Space>s'" },
    config = function()
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
    "pchynoweth/a.vim",
    config = function()
      vim.cmd([[augroup alternate_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd VimEnter * call vimrc#alternative#settings()]])
      vim.cmd([[augroup END]])
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
