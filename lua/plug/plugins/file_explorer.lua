local choose = require("vimrc.choose")

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
      vim.fn["vimrc#source"]("vimrc/plugins/defx.vim")
      vim.fn["vimrc#defx#setup"](true)
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- TODO: Enable this
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    cmd = { "Neotree" },
    keys = {
      {
        "<F5>",
        [[<Cmd>Neotree toggle left<CR>]],
        desc = "Neotree - toggle on the left",
      },
      {
        "<Space>nn",
        [[<Cmd>Neotree toggle left<CR>]],
        desc = "Neotree - toggle on the left",
      },
      {
        "<Space>nf",
        [[<Cmd>Neotree toggle float<CR>]],
        desc = "Neotree - toggle in the floating window",
      },
      {
        "<Space>n<Space>",
        [[<Cmd>Neotree reveal_force_cwd<CR>]],
        desc = "Neotree - reveal current working directory",
      },
      {
        "<Space>nd",
        function()
          vim.cmd([[Neotree float reveal_file=]] .. vim.fn.expand("<cfile>") .. [[ reveal_force_cwd]])
        end,
        desc = "Neotree - reveal current file",
      },
      {
        "<Space>nb",
        [[<Cmd>Neotree toggle show buffers right<CR>]],
        desc = "Neotree - toggle buffers on the right",
      },
      {
        "<Space>ns",
        [[<Cmd>Neotree float git_status<CR>]],
        desc = "Neotree - show git status in the floating window",
      },
    },
    config = function()
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "diagnostics",
          -- "netman.ui.neo-tree",
          -- ...and any additional source
        },
        window = {
          mappings = {
            ["z"] = function(_) end, -- Do nothing
            ["zm"] = "expand_all_nodes",
            ["zr"] = "close_all_nodes",
            ["zz"] = function(_)
              vim.cmd([[normal! zz]])
            end,
            ["zt"] = function(_)
              vim.cmd([[normal! zt]])
            end,
            ["zb"] = function(_)
              vim.cmd([[normal! zb]])
            end,
            ["z/"] = function(_)
              vim.api.nvim_feedkeys("/", "n", false)
            end,
            ["z?"] = function(_)
              vim.api.nvim_feedkeys("?", "n", false)
            end,
          },
        },
        source_selector = {
          winbar = true,
          statusline = false,
        },
      })
    end,
  },
  {
    "mrbjarksen/neo-tree-diagnostics.nvim",
    requires = "nvim-neo-tree/neo-tree.nvim",
    module = "neo-tree.sources.diagnostics",
    lazy = true,
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

  -- Protocol
  {
    "miversen33/netman.nvim",
    enabled = false,
    config = function()
      require("netman")
    end,
  },
}

return file_explorer
