local choose = require("vimrc.choose")

local file_explorer = {
  -- NOTE: Lazy load doesn't improve much and break the :UpdateRemotePlugins
  -- TODO: Try again after switch to lazy.nvim
  -- FIXME: Seems to conflict with which-key.nvim v3?
  -- It seems that if plugin is lazy loaded and not lua plugin, then whick-key.nvim may override the key mappings.
  {
    "Shougo/defx.nvim",
    cond = choose.is_enabled_plugin("defx.nvim"),
    build = ":UpdateRemotePlugins",
    config = function()
      vim.fn["vimrc#source"]("vimrc/plugins/defx.vim")
    end,
  },
  {
    "kristijanhusak/defx-git",
    cond = choose.is_enabled_plugin("defx.nvim"),
  },
  {
    "kristijanhusak/defx-icons",
    cond = choose.is_enabled_plugin("defx.nvim"),
    event = { "VeryLazy" },
    config = function()
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
        [[<Cmd>Neotree left<CR>]],
        desc = "Neotree - toggle on the left",
      },
      {
        "<Space>nn",
        [[<Cmd>Neotree left<CR>]],
        desc = "Neotree - toggle on the left",
      },
      {
        "<Space>nf",
        [[<Cmd>Neotree float<CR>]],
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

      -- FIXME: Shouldn't be conflicting with other file explorer plugins
      cnoremap("<C-X>d", [[v:lua.require('vimrc.plugins.neotree').get_current_dir('filesystem')]], "expr")
      cnoremap("<C-X>f", [[v:lua.require('vimrc.plugins.neotree').get_current_path('filesystem')]], "expr")
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

  -- TODO: Lazy load for oil:// schema
  -- Ref: https://github.com/stevearc/oil.nvim/issues/75
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Oil" },
    keys = {
      "<Space>o",
      "<Space>O",
      "<Space><C-O>",
      [[\oo]],
      [[\ov]],
      [[\os]],
    },
    init = function()
      -- TODO: Move this to oil.lua and think of a way to avoid loading oil.nvim
      local augroup_id = vim.api.nvim_create_augroup("oil_settings", {})
      -- Do not load netrw
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = augroup_id,
        pattern = "*",
        once = true,
        callback = function()
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          -- If netrw was already loaded, clear this augroup
          if vim.fn.exists("#FileExplorer") then
            vim.api.nvim_create_augroup("FileExplorer", { clear = true })
          end
        end,
      })
      -- Detect directories and open them with oil
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = augroup_id,
        pattern = "*",
        -- NOTE: Use `vim.schedule_wrap` to allow oil.nvim to populate the buffer after the VimEnter autocmd
        -- Ref: https://github.com/stevearc/oil.nvim/issues/268#issuecomment-1880161152
        callback = vim.schedule_wrap(function(args)
          if args.file ~= "" and vim.fn.isdirectory(args.file) == 1 then
            require("oil").open(args.file)
          end
        end),
      })
    end,
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
