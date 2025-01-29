local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local file_explorer = {
  -- TODO: Check if :UpdateRemotePlugins is not called after updating defx.nvim
  {
    "Shougo/defx.nvim",
    cond = choose.is_enabled_plugin("defx.nvim"),
    dependencies = {
      "kristijanhusak/defx-git",
      "kristijanhusak/defx-icons",
    },
    cmd = {
      "Defx",
      "DefxBottomSplitOpenDirSink",
      "DefxBottomSplitOpenSink",
      "DefxFloatOpenDirSink",
      "DefxFloatOpenSink",
      "DefxOpenDirSink",
      "DefxOpenSink",
      "DefxRightVSplitOpenDirSink",
      "DefxRightVSplitOpenSink",
      "DefxSearch",
      "DefxSplitOpenDirSink",
      "DefxSplitOpenSink",
      "DefxSwitch",
      "DefxTabOpenDirSink",
      "DefxTabOpenSink",
      "DefxTabSwitch",
      "DefxVSplitOpenDirSink",
      "DefxVSplitOpenSink",
    },
    keys = {
      -- TODO: Clean up these key mappings

      -- Sidebar
      { [[<F4>]], function()
        vim.cmd([[Defx ]] .. vim.fn["vimrc#defx#get_options"]('sidebar'))
      end, desc = "Defx - open sidebar" },
      { [[<Space><F4>]], function()
        vim.cmd([[Defx ]] .. vim.fn["vimrc#defx#get_options"]('sidebar') .. " " .. vim.fn.expand("%:p:h") .. " -search=" .. vim.fn.expand("%:p"))
      end, desc = "Defx - open sidebar and search current file" },
      -- Currently, it's impossible to type <S-F1> ~ <S-F12> using wezterm + tmux.
      -- wezterm with 'xterm-256color' + tmux with 'screen-256color' will
      -- generate keycode for <S-F1> ~ <S-F12> that recognized by neovim as <F13> ~ <F16>.
      { [[<F16>]], function()
        vim.cmd([[Defx ]] .. vim.fn["vimrc#defx#get_options"]('sidebar') .. " " .. vim.fn.expand("%:p:h") .. " -search=" .. vim.fn.expand("%:p") .. " -no-focus")
      end, desc = "Defx - open sidebar and search current file without focus" },
      -- wezterm can generate correct keycode for <S-F1> ~ <S-F12>
      { [[<S-F4>]], function()
        vim.cmd([[Defx ]] .. vim.fn["vimrc#defx#get_options"]('sidebar') .. " " .. vim.fn.expand("%:p:h") .. " -search=" .. vim.fn.expand("%:p") .. " -no-focus")
      end, desc = "Defx - open sidebar and search current file without focus" },

      -- Buffer directory
      { [[<Space>dd]], function()
        vim.fn["vimrc#defx#opendir"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('win'))
      end, desc = "Defx - open parent folder in defx.nvim"},
      { [[<Space>dh]], function()
        vim.fn["vimrc#defx#opendir"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('horizontal_win'))
      end, desc = "Defx - open parent folder in horizontal split in defx.nvim"},
      { [[<Space>dv]], function()
        vim.fn["vimrc#defx#opendir"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('vertical_win'))
      end, desc = "Defx - open parent folder in vertical split in defx.nvim"},
      { [[<Space>dt]], function()
        vim.fn["vimrc#defx#opendir"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('tab'))
      end, desc = "Defx - open parent folder in tab in defx.nvim"},
      { [[<Space>df]], function()
        vim.fn["vimrc#defx#opendir"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('float'))
      end, desc = "Defx - open parent folder in float in defx.nvim"},

      -- Current working directory
      { [[\xr]], function()
        vim.fn["vimrc#defx#openpwd"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('win'))
      end, desc = "Defx - open current working directoy in defx.nvim"},
      { [[\xs]], function()
        vim.fn["vimrc#defx#openpwd"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('horizontal_win'))
      end, desc = "Defx - open current working directoy in horizontal split in defx.nvim"},
      { [[\xv]], function()
        vim.fn["vimrc#defx#openpwd"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('vertical_win'))
      end, desc = "Defx - open current working directoy in vertical split in defx.nvim"},
      { [[\xt]], function()
        vim.fn["vimrc#defx#openpwd"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('tab'))
      end, desc = "Defx - open current working directoy in tab in defx.nvim"},
      { [[\xf]], function()
        vim.fn["vimrc#defx#openpwd"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('float'))
      end, desc = "Defx - open current working directoy in float in defx.nvim"},

      -- Current git repository
      { [[\gr]], function()
        vim.fn["vimrc#defx#open_worktree"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('win'))
      end, desc = "Defx - open current git repository in defx.nvim"},
      { [[\gs]], function()
        vim.fn["vimrc#defx#open_worktree"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('horizontal_win'))
      end, desc = "Defx - open current git repository in horizontal split in defx.nvim"},
      { [[\gv]], function()
        vim.fn["vimrc#defx#open_worktree"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('vertical_win'))
      end, desc = "Defx - open current git repository in vertical split in defx.nvim"},
      { [[\gt]], function()
        vim.fn["vimrc#defx#open_worktree"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('tab'))
      end, desc = "Defx - open current git repository in tab in defx.nvim"},
      { [[\gf]], function()
        vim.fn["vimrc#defx#open_worktree"]('Defx ' .. vim.g.defx_new_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('float'))
      end, desc = "Defx - open current git repository in float in defx.nvim"},

      -- Resume
      { [[\Xr]], function()
        vim.fn["vimrc#defx#opencmd"]('Defx ' .. vim.g.defx_resume_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('win'))
      end, desc = "Defx - resume in defx.nvim"},
      { [[\Xs]], function()
        vim.fn["vimrc#defx#opencmd"]('Defx ' .. vim.g.defx_resume_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('horizontal_win'))
      end, desc = "Defx - resume in horizontal split in defx.nvim"},
      { [[\Xv]], function()
        vim.fn["vimrc#defx#opencmd"]('Defx ' .. vim.g.defx_resume_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('vertical_win'))
      end, desc = "Defx - resume in vertical split in defx.nvim"},
      { [[\Xt]], function()
        vim.fn["vimrc#defx#opencmd"]('Defx ' .. vim.g.defx_resume_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('tab'))
      end, desc = "Defx - resume in tab in defx.nvim"},
      { [[\Xf]], function()
        vim.fn["vimrc#defx#opencmd"]('Defx ' .. vim.g.defx_resume_options .. ' ' .. vim.fn["vimrc#defx#get_options"]('float'))
      end, desc = "Defx - resume in float in defx.nvim"},
    },
    build = ":UpdateRemotePlugins",
    config = function()
      require("vimrc.plugins.defx").load_defx()
      plugin_utils.source_in_vim_home("vimrc/plugins/defx.vim")
      vim.fn["vimrc#defx#setup"](true)
    end,
  },

  {
    "vifm/vifm.vim",
    cmd = { "EditVifm", "Vifm", "SplitVifm", "VsplitVifm", "TabVifm" },
  },

  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("vimrc.plugins.oil").setup()
    end,
  },

  {
    "mikavilpas/yazi.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = { "VeryLazy" },
    keys = {
      {
        "<Leader>za",
        function()
          require("yazi").yazi()
        end,
        desc = "Open the file manager",
      },
      {
        -- Open in the current working directory
        "<Leader>zw",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = false,
    },
  },
}

return file_explorer
