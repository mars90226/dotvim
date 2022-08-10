-- TODO: Refactor to other files
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local nvim_treesitter = {}

nvim_treesitter.enable_config = {
  highlight_definitions = false,
  highlight_current_scope = false,
}

nvim_treesitter.line_threshold = {
  base = {
    cpp = 30000,
    javascript = 30000,
  },
  extension = {
    cpp = 10000,
    javascript = 3000,
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

-- Disable check for highlight usage/context
local extension_disable_check = function(lang, bufnr)
  return disable_check("extension", lang, bufnr)
end

-- nvim-ts-hint-textobject
nvim_treesitter.tsht_nodes = function(fallback)
  local tsht = require("tsht")
  local res, nodes = pcall(tsht.nodes)

  if res then
    return nodes
  end

  vim.api.nvim_feedkeys(fallback, "n", false)
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
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
    },
    maintainers = { "@IndianBoy42" },
  }
end

nvim_treesitter.setup_config = function()
  require("nvim-treesitter.configs").setup({
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
      "help",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      plugin_utils.check_condition("norg", plugin_utils.get_os() ~= "mac"),
      "perl",
      "php",
      "proto",
      "python",
      "query",
      "regex",
      "rst",
      "ruby",
      "scss",
      "teal",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vue",
      "yaml",
    }),
    ignore_install = {},
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
    },
    indent = {
      enable = false, -- Currently, nvim-treesitter indent is WIP and not ready for production use
    },
    refactor = {
      highlight_definitions = {
        enable = nvim_treesitter.enable_config.highlight_definitions,
        disable = base_disable_check,
        clear_on_cursor_move = false,
      },
      highlight_current_scope = {
        enable = nvim_treesitter.enable_config.highlight_current_scope,
        disable = extension_disable_check,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "<Space>hr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_next_usage = "<M-*>",
          goto_previous_usage = "<M-#>",
        },
      },
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          -- Override textobj-function
          -- nvim-treesitter is preciser than textobj-function
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
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
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    context_commentstring = {
      enable = true,
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        ["g;"] = "textsubjects-container-outer",
      },
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
  require("treesitter-context").setup({
    enable = utils.ternary(context_default_enable, current_buffer_base_highlight_disable_check(), false), -- Enable this plugin (Can be enabled/disabled later via commands)
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
            vim.cmd([[TSContextDisable]])
          end
          vim.cmd([[NoMatchParen]])
        end)
      else
        vim.schedule(function()
          if context_default_enable then
            vim.cmd([[TSContextEnable]])
          end
          vim.cmd([[DoMatchParen]])
        end)
      end
    end,
  })

  onoremap("m", [[<Cmd>lua require("vimrc.plugins.nvim_treesitter").tsht_nodes("m")<CR>]], "silent")
  vnoremap("m", [[:lua require("vimrc.plugins.nvim_treesitter").tsht_nodes("m")<CR>]], "silent")
end

nvim_treesitter.setup_performance_trick = function()
  local configs_commands = require("nvim-treesitter.configs").commands

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
    plugin_utils.check_enabled_plugin("nvimGPS", "nvim-gps"),
    plugin_utils.check_condition("highlight_current_scope", nvim_treesitter.enable_config.highlight_current_scope),
    plugin_utils.check_condition("highlight_definitions", nvim_treesitter.enable_config.highlight_definitions),
    "navigation",
    "smart_rename",
  })
  local tab_idle_disabled_modules = global_idle_disabled_modules

  vim.api.nvim_create_autocmd({ "FocusGained" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      for _, module in ipairs(global_idle_disabled_modules) do
        configs_commands.TSEnable.run(module)
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
  vim.api.nvim_create_autocmd({ "FocusLost" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      for _, module in ipairs(global_idle_disabled_modules) do
        configs_commands.TSDisable.run(module)
      end
    end,
  })

  local tab_trick_enable = false
  local tab_trick_debounce = 200
  -- FIXME: Open buffer in other tab doesn't have highlight
  -- FIXME: Seems to conflict with true-zen.nvim
  vim.api.nvim_create_autocmd({ "TabEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      tab_trick_enable = true

      vim.defer_fn(function()
        if tab_trick_enable then
          local winids = vim.api.nvim_tabpage_list_wins(0)

          for _, module in ipairs(tab_idle_disabled_modules) do
            for _, winid in ipairs(winids) do
              configs_commands.TSBufEnable.run(module, vim.api.nvim_win_get_buf(winid))
            end
          end

          tab_trick_enable = false
        end
      end, tab_trick_debounce)
    end,
  })
  vim.api.nvim_create_autocmd({ "TabLeave" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        for _, module in ipairs(tab_idle_disabled_modules) do
          configs_commands.TSBufDisable.run(module, vim.api.nvim_win_get_buf(winid))
        end
      end
    end,
  })
end

nvim_treesitter.setup_mapping = function()
  nnoremap("<F6>", function()
    buffer_toggle_force_disable(vim.api.nvim_get_current_buf())
    vim.cmd([[TSBufToggle highlight]])
  end)
end

nvim_treesitter.setup = function()
  nvim_treesitter.setup_parser_config()
  nvim_treesitter.setup_config()
  nvim_treesitter.setup_extensions()
  nvim_treesitter.setup_performance_trick()
  nvim_treesitter.setup_mapping()
end

return nvim_treesitter
