local plugin_utils = require("vimrc.plugin_utils")

local file_navigation = {}

file_navigation.startup = function(use)
  -- Sources
  use("Shougo/neomru.vim")
  use("Shougo/neoyank.vim")
  use({
    "AckslD/nvim-neoclip.lua",
    disable = true,
    requires = { "tami5/sqlite.lua", module = "sqlite" },
    config = function()
      require("neoclip").setup({
        enable_persistant_history = true,
      })
    end,
  })
  -- TODO: Raise neomru limit

  -- Finders
  -- denite.nvim
  use({
    "Shougo/denite.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      vim.cmd([[silent! UpdateRemotePlugins]])
      vim.fn["vimrc#source"]("vimrc/plugins/denite.vim")
      vim.fn["vimrc#source"]("vimrc/plugins/denite_after.vim")
    end,
  })
  use({ "neoclide/denite-extra", after = "denite.nvim" })
  use({ "kmnk/denite-dirmark", after = "denite.nvim" })

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
      vim.fn["vimrc#source"]("vimrc/plugins/fuzzymenu.vim")
      vim.fn["vimrc#source"]("vimrc/plugins/fuzzymenu_after.vim")
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
  use("nvim-telescope/telescope-file-browser.nvim")
  use("nvim-telescope/telescope-project.nvim")
  use("jvgrootveld/telescope-zoxide")
  use("sudormrfbin/cheatsheet.nvim")
  use("nvim-telescope/telescope-media-files.nvim")
  use("TC72/telescope-tele-tabby.nvim")

  if plugin_utils.is_enabled_plugin("telescope-fzf-native.nvim") then
    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
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
    "liuchengxu/vista.vim",
    disable = true,
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/vista.vim")
    end,
  })
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
end

return file_navigation
