-- TODO: Refactor to other files
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local configs = require("nvim-treesitter.configs")
local configs_commands = configs.commands
local parsers = require("nvim-treesitter.parsers")

local nvim_treesitter = {}

nvim_treesitter.enable_config = {
  highlight_definitions = false,
  highlight_current_scope = false,
}

nvim_treesitter.filetype_disable = {
  diff = true, -- NOTE: tree-sitter-diff doesn't support `git format-patch` diffs
}

nvim_treesitter.line_threshold = {
  base = {
    cpp = 30000,
    javascript = 30000,
    perl = 10000,
  },
  extension = {
    cpp = 10000,
    javascript = 3000,
    perl = 3000,
  },
}

-- Force disable
local force_disable_var = "nvim_treesitter_force_disable"
local get_force_disable = function(bufnr)
  return utils.get_buffer_variable(bufnr, force_disable_var) or false
end
local buffer_toggle_force_disable = function(bufnr)
  local force_disable = not (utils.get_buffer_variable(bufnr, force_disable_var) or false)
  vim.api.nvim_buf_set_var(bufnr, force_disable_var, force_disable)
end

-- Disable check for highlight, highlight usage, highlight context module
local disable_check = function(type, lang, bufnr)
  if get_force_disable(bufnr) then
    return true
  end
  if nvim_treesitter.filetype_disable[lang] then
    return true
  end

  if type == nil then
    type = "base"
  end

  local line_count = vim.api.nvim_buf_line_count(bufnr or 0)
  local line_threshold_map = vim.F.if_nil(nvim_treesitter.line_threshold[type], {})
  local line_threshold = line_threshold_map[lang]

  if line_threshold ~= nil and line_count > line_threshold then
    return true
  else
    return false
  end
end

-- Disable check for highlight module
local base_disable_check = function(lang, bufnr)
  return disable_check("base", lang, bufnr)
end
local current_buffer_base_highlight_disable_check = function()
  local ft = vim.bo.ft
  local bufnr = vim.fn.bufnr()
  return base_disable_check(ft, bufnr)
end

-- TODO: Remove unused functions

-- Disable check for highlight usage/context
local extension_disable_check = function(lang, bufnr)
  return disable_check("extension", lang, bufnr)
end

-- Disable check for checking not in enable_filetype list
local enable_check = function(enable_filetype)
  return function(lang, bufnr)
    return not vim.tbl_contains(enable_filetype, lang)
  end
end

nvim_treesitter.is_enabled = function(module, buf)
  buf = buf or 0
  local lang = parsers.get_buf_lang(buf)
  return configs.is_enabled(module, lang, buf)
end

nvim_treesitter.buf_is_supported = function(buf)
  return parsers.has_parser(parsers.get_buf_lang(buf or 0))
end

nvim_treesitter.win_is_supported = function(winid)
  local buf = vim.api.nvim_win_get_buf(winid or 0)
  return nvim_treesitter.buf_is_supported(buf)
end

nvim_treesitter.tab_get_supported_bufs = function(tab)
  local winids = vim.api.nvim_tabpage_list_wins(tab or 0)
  local bufs = vim.tbl_map(vim.api.nvim_win_get_buf, winids)
  local supported_bufs = vim.tbl_filter(nvim_treesitter.buf_is_supported, bufs)

  return supported_bufs
end

nvim_treesitter.tab_get_supported_winids = function(tab)
  local winids = vim.api.nvim_tabpage_list_wins(tab or 0)
  local supported_wins = vim.tbl_filter(nvim_treesitter.win_is_supported, winids)

  return supported_wins
end

nvim_treesitter.list_supported_winids = function()
  local winids = vim.api.nvim_list_wins()
  local supported_wins = vim.tbl_filter(nvim_treesitter.win_is_supported, winids)

  return supported_wins
end

-- nvim-treehopper
nvim_treesitter.tsht_nodes = function(fallback)
  local tsht = require("tsht")
  local res, nodes = pcall(tsht.nodes)

  if res then
    return nodes
  end

  vim.api.nvim_feedkeys(fallback, "n", false)
end

local ts_context_force_disable_var = "ts_context_force_disable"
local get_context_force_disable = function(bufnr)
  return utils.get_buffer_variable(bufnr, ts_context_force_disable_var) or false
end
local buffer_toggle_context_force_disable = function(bufnr)
  local force_disable = not (utils.get_buffer_variable(bufnr, ts_context_force_disable_var) or false)
  vim.api.nvim_buf_set_var(bufnr, ts_context_force_disable_var, force_disable)
end
nvim_treesitter.toggle_context = function()
  local ts_context = require("treesitter-context")
  ts_context.toggle()
  buffer_toggle_context_force_disable(vim.fn.bufnr())
end

nvim_treesitter.setup_parser_config = function()
  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

  parser_configs.norg = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
    },
  }

  parser_configs.norg_meta = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
      files = { "src/parser.c" },
      branch = "main",
    },
  }

  parser_configs.norg_table = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
      files = { "src/parser.c" },
      branch = "main",
    },
  }

  parser_configs.just = {
    install_info = {
      url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
      files = { "src/parser.c", "src/scanner.c" },
      branch = "main",
    },
    maintainers = { "@IndianBoy42" },
  }

  -- TODO: Use repo in https://github.com/serenadeai/tree-sitter-scss/pull/19
  parser_configs.scss = {
    install_info = {
      url = "https://github.com/goncharov/tree-sitter-scss",
      files = { "src/parser.c", "src/scanner.c" },
      branch = "placeholders",
      revision = "30c9dc19d3292fa8d1134373f0f0abd8547076e8",
    },
    maintainers = { "@goncharov" },
  }
end

nvim_treesitter.setup_config = function()
  configs.setup({
    ensure_installed = vim.tbl_filter(function(language)
      return language ~= nil
    end, {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "css",
      "fennel",
      "go",
      "gomod",
      "gowork",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      plugin_utils.check_condition("norg", not plugin_utils.os_is("mac")),
      "perl",
      "php",
      "proto",
      "python",
      "query",
      "regex",
      "rst",
      "ruby",
      "rust",
      "scss",
      "teal",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    }),
    ignore_install = {},
    -- update_strategy = "github", -- Enable when installing alternative parsers for built-in parsers
    highlight = {
      enable = true,
      disable = base_disable_check,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        scope_incremental = "<CR>",
        node_incremental = "<Tab>",
        node_decremental = "<S-Tab>",
      },
      -- Ignore incremental selection in cmdline mode & cmdline window
      -- Ref: https://github.com/nvim-treesitter/nvim-treesitter/issues/2634#issuecomment-1362479800
      is_supported = function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == "c" then
          return false
        end
        return true
      end
    },
    indent = {
      enable = false, -- Currently, nvim-treesitter indent is WIP and not ready for production use
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- Override textobj-function
          -- nvim-treesitter is preciser than textobj-function
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          -- You can optionally set descriptions to the mappings (used in the desc parameter of
          -- nvim_buf_set_keymap) which plugins like which-key display
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          -- You can also use captures from other query groups like `locals.scm`
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<C-v>", -- blockwise
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["czn"] = "@parameter.inner",
        },
        swap_previous = {
          ["czp"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {
          ["<Space>hf"] = "@function.outer",
          ["<Space>hc"] = "@class.outer",
        },
      },
    },
    context_commentstring = {
      enable = true,
    },
    matchup = {
      enable = current_buffer_base_highlight_disable_check(), -- mandatory, false will disable the whole extension
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    yati = {
      enable = true,
    },
  })
end

nvim_treesitter.setup_extensions = function()
  -- nvim-treesitter-context
  local context_default_enable = choose.is_enabled_plugin("nvim-treesitter-context")
  local context_enable = utils.ternary(context_default_enable, current_buffer_base_highlight_disable_check(), false)
  require("treesitter-context").setup({
    enable = context_enable, -- Enable this plugin (Can be enabled/disabled later via commands)
  })

  local ts_highlight_check_augroup_id = vim.api.nvim_create_augroup("nvim_treesitter_highlight_check", {})
  -- FIXME: Currently this doesn't disable the modules as they are enabled in
  -- nvim-treesitter attach callback, which is executed after this autocmd.
  -- But this can fix the error that highlight is disabled on startup and also
  -- enables modules after startup.
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = ts_highlight_check_augroup_id,
    pattern = "*",
    callback = function()
      if current_buffer_base_highlight_disable_check() then
        vim.schedule(function()
          if context_default_enable then
            require("treesitter-context").disable()
          end
          vim.cmd([[silent! NoMatchParen]])
        end)
      else
        vim.schedule(function()
          local ts_context = require("treesitter-context")
          if context_default_enable and not get_context_force_disable(vim.fn.bufnr()) and not ts_context.enabled() then
            ts_context.enable()
          end
          vim.cmd([[silent! DoMatchParen]])
        end)
      end
    end,
  })
end

nvim_treesitter.setup_performance_trick = function()
  -- TODO: Check if these actually help performance, initial test reveals that these may reduce highlighter time, but increase "[string]:0" time which is probably the time spent on autocmd & syntax enable/disable.
  -- TODO: These config help reduce memory usage, see if there's other way to fix high memory usage.
  -- TODO: Change to tab based toggling
  local augroup_id = vim.api.nvim_create_augroup("nvim_treesitter_settings", {})

  local global_idle_disabled_modules = vim.tbl_filter(function(module)
    return module ~= nil
  end, {
    "highlight",
    "context_commentstring",
    "matchup",
  })
  local tab_idle_disabled_modules = global_idle_disabled_modules

  ---Run callback on treesitter supported window to avoid highlight missing
  ---@param supported_winids table<number> window ids that will run treesitter command
  ---@param callback fun(): nil callback to run
  -- FIXME: Some special float buffers will close itself once leave the buffer, like Mason buffer.
  local run_callback_on_supported_win = function(supported_winids, callback)
    if not vim.tbl_isempty(supported_winids) then
      local current_win = vim.api.nvim_get_current_win()
      local current_win_supported = nvim_treesitter.win_is_supported(current_win)
      local view = nil

      if not current_win_supported then
        current_win = vim.api.nvim_get_current_win()
        view = vim.fn.winsaveview()

        -- NOTE: Switch to supported window to avoid highlight missing
        -- TODO: Check if neovim fix this bug on 0.9.0 release
        -- HACK: Use `:noautocmd` to ignore telescope-frecency.nvim autocmd to update database. As
        -- it often run into "failed to get lock" error.
        vim.cmd(string.format([[noautocmd lua vim.api.nvim_set_current_win(%d)]], supported_winids[1]))
      end

      callback()

      if not current_win_supported then
        -- NOTE: Avoid invalid window id
        -- HACK: Use `:noautocmd` to ignore telescope-frecency.nvim autocmd to update database. As
        -- it often run into "failed to get lock" error.
        pcall(function()
          vim.cmd(string.format([[noautocmd lua vim.api.nvim_set_current_win(%d)]], current_win))
        end)
        pcall(vim.fn.winrestview, view)

        -- Restore terminal insert mode
        -- mode "nt" means Normal in terminal-emulator, `:help mode()`
        if vim.bo.buftype == "terminal" and vim.api.nvim_get_mode().mode == "nt" then
          vim.cmd([[startinsert]])
        end
      end
    end
  end
  ---Global run callback on supported window to avoid highlight missing
  ---@param callback fun(): nil callback to run
  local global_run_callback = function(callback)
    local supported_winids = nvim_treesitter.list_supported_winids()
    run_callback_on_supported_win(supported_winids, callback)
  end
  ---Run callback on each supported window in current tab to avoid highlight missing
  ---@param callback fun(winid: number): nil callback to run
  local tab_loop_supported_wins = function(callback)
    local supported_winids = nvim_treesitter.tab_get_supported_winids(0)
    run_callback_on_supported_win(supported_winids, function()
      for _, supported_winid in ipairs(supported_winids) do
        callback(supported_winid)
      end
    end)
  end

  local global_trick_delay_enable = false
  local global_trick_delay = 60 * 1000 -- 60 seconds
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      if global_trick_delay_enable then
        global_trick_delay_enable = false
      else
        global_run_callback(function()
          for _, module in ipairs(global_idle_disabled_modules) do
            configs_commands.TSEnable.run(module)
          end
        end)
      end
    end,
  })
  -- NOTE: We want to disable highlight if FocusLost is caused by following reasons:
  -- 1. neovim goes to background
  -- 2. tmux switch window, client
  -- 3. Terminal emulator switch tab
  -- We don't want to disable highlight if FocusLost is caused by following reasons:
  -- 1. tmux switch pane
  -- 2. Terminal emulator switch pane
  -- 3. OS switch application
  -- In other words, we want treesitter highlight if the buffer is actually displayed on the screen.
  -- TODO: Check if VimResume/VimSuspend helps
  vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      global_trick_delay_enable = true

      vim.defer_fn(function()
        if global_trick_delay_enable then
          global_run_callback(function()
            for _, module in ipairs(global_idle_disabled_modules) do
              configs_commands.TSDisable.run(module)
            end
          end)

          global_trick_delay_enable = false
        end
      end, global_trick_delay)
    end,
  })

  local tab_trick_enable = {}
  local tab_trick_debounce = 200
  -- FIXME: Seems to conflict with true-zen.nvim
  vim.api.nvim_create_autocmd({ "TabEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      tab_trick_enable[vim.api.nvim_get_current_tabpage()] = true

      vim.defer_fn(function()
        if tab_trick_enable then
          tab_loop_supported_wins(function(winid)
            for _, module in ipairs(tab_idle_disabled_modules) do
              configs_commands.TSBufEnable.run(module, vim.api.nvim_win_get_buf(winid))
            end
          end)

          tab_trick_enable[vim.api.nvim_get_current_tabpage()] = false
        end
      end, tab_trick_debounce)
    end,
  })

  -- NOTE: Disabled performance trick for WinBufEnter/TabLeave for now. Due to the following reasons:
  -- 1. Treesitter highlight is faster now.
  -- 2. Disabled it also benefits the performance on tab switch.

  -- vim.api.nvim_create_autocmd({ "TabLeave" }, {
  --   group = augroup_id,
  --   pattern = "*",
  --   callback = function()
  --     tab_trick_enable[vim.api.nvim_get_current_tabpage()] = false
  --
  --     tab_loop_supported_wins(function(winid)
  --       for _, module in ipairs(tab_idle_disabled_modules) do
  --         configs_commands.TSBufDisable.run(module, vim.api.nvim_win_get_buf(winid))
  --       end
  --     end)
  --   end,
  -- })
  -- -- NOTE: Open buffer in other tab doesn't have highlight, enable highlight on BufWinEnter
  -- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  --   group = augroup_id,
  --   pattern = "*",
  --   callback = function()
  --     if nvim_treesitter.win_is_supported() then
  --       for _, module in ipairs(tab_idle_disabled_modules) do
  --         configs_commands.TSBufEnable.run(module, vim.api.nvim_get_current_buf())
  --       end
  --     end
  --   end,
  -- })
end

nvim_treesitter.setup_mapping = function()
  vim.keymap.set("n", "<Space><F6>", function()
    buffer_toggle_force_disable(vim.api.nvim_get_current_buf())
    vim.cmd([[TSBufToggle highlight]])
  end, { desc = "Toggle treesitter highlight" })
  -- Currently, it's impossible to type <C-F1> ~ <C-F12> using wezterm + tmux.
  -- wezterm with 'xterm-256color' + tmux with 'screen-256color' will
  -- generate keycode for <C-F1> ~ <C-F12> that recognized by neovim as <F25> ~ <F36>.
  vim.keymap.set("n", "<C-F6>", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { silent = true, desc = "Go to treesitter context" })
  vim.keymap.set("n", "<F30>", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { silent = true, desc = "Go to treesitter context" })
end

nvim_treesitter.setup = function()
  nvim_treesitter.setup_parser_config()
  nvim_treesitter.setup_config()
  nvim_treesitter.setup_extensions()
  nvim_treesitter.setup_performance_trick()
  nvim_treesitter.setup_mapping()
end

return nvim_treesitter
