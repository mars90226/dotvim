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
  use("nvim-telescope/telescope-project.nvim")
  use("jvgrootveld/telescope-zoxide")
  use("sudormrfbin/cheatsheet.nvim")
  use("nvim-telescope/telescope-media-files.nvim")
  use("TC72/telescope-tele-tabby.nvim")

  if vim.fn["vimrc#plugin#is_enabled_plugin"]("telescope-fzf-native.nvim") == 1 then
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

  -- Goto Definitions
  use({
    "liuchengxu/vista.vim",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/vista.vim")
    end,
  })
  use({
    "pechorin/any-jump.nvim",
    config = function()
      vim.g.any_jump_window_width_ratio, vim.g.any_jump_window_height_ratio = unpack(
        vim.fn["vimrc#float#get_default_ratio"]()
      )
      vim.g.any_jump_window_top_offset = vim.fn["vimrc#float#calculate_pos_from_ratio"](
        vim.g.any_jump_window_width_ratio,
        vim.g.any_jump_window_height_ratio
      )[2]

      vim.g.any_jump_disable_default_keybindings = 1

      nnoremap("<Leader>aj", ":AnyJump<CR>")
      nnoremap("<Leader>aa", ":AnyJumpArg<Space>")
      xnoremap("<Leader>aj", ":AnyJumpVisual<CR>")
      nnoremap("<Leader>ab", ":AnyJumpBack<CR>")
      nnoremap("<Leader>al", ":AnyJumpLastResults<CR>")

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
    key = { "<Space>S", "<Space>sw", "<Space>ss", "<Space>s'" },
    config = function()
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
