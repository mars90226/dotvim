-- TODO: Refactor to other files
local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local enable_config = {
  highlight_definitions = false,
  highlight_current_scope = false,
}

-- Disable check for highlight module
local base_highlight_disable_check = function(lang, bufnr)
  -- Disable in large C++ buffers & JavaScript buffers
  local LINE_THRESHOLDS = {
    cpp = 30000,
    javascript = 30000,
  }
  local line_count = vim.api.nvim_buf_line_count(bufnr or 0)

  if LINE_THRESHOLDS[lang] ~= nil and line_count > LINE_THRESHOLDS[lang] then
    return true
  else
    return false
  end
end
local current_buffer_base_highlight_disable_check = function()
  local ft = vim.bo.ft
  local bufnr = vim.fn.bufnr()
  return base_highlight_disable_check(ft, bufnr)
end

-- Disable check for highlight usage/context
local highlight_disable_check = function(lang, bufnr)
  -- Disable in large C++ buffers & JavaScript buffers
  local LINE_THRESHOLDS = {
    cpp = 10000,
    javascript = 3000,
  }
  local line_count = vim.api.nvim_buf_line_count(bufnr or 0)

  if LINE_THRESHOLDS[lang] ~= nil and line_count > LINE_THRESHOLDS[lang] then
    return true
  else
    return false
  end
end

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
    plugin_utils.check_condition("norg", plugin_utils.get_os() ~= "mac"),
    "perl",
    "php",
    "python",
    "query",
    "regex",
    "rst",
    "scss",
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
    disable = base_highlight_disable_check,
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
      enable = enable_config.highlight_definitions,
      disable = base_highlight_disable_check,
      clear_on_cursor_move = false,
    },
    highlight_current_scope = {
      enable = enable_config.highlight_current_scope,
      disable = highlight_disable_check,
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

-- nvim-treesitter-context
local context_default_enable = not plugin_utils.is_enabled_plugin("nvim-navic")
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

-- Settings
-- nvim-ts-hint-textobject
local tsht_nodes = function(fallback)
  local tsht = require('tsht')
  local res, nodes = pcall(tsht.nodes)

  if res then
    return nodes
  end

  vim.api.nvim_feedkeys(fallback, 'n', false)
end
onoremap("m", function() tsht_nodes("m") end, "silent")
vnoremap("m", function() tsht_nodes("m") end, "silent")

-- Performance
-- TODO: Check if these actually help performance, initial test reveals that these may reduce highlighter time, but increase "[string]:0" time which is probably the time spent on autocmd & syntax enable/disable.
-- TODO: These config help reduce memory usage, see if there's other way to fix high memory usage.
-- TODO: Change to tab based toggling
local augroup_id = vim.api.nvim_create_augroup("nvim_treesitter_settings", {})

local global_idle_disabled_modules = vim.tbl_filter(function(module)
  return module ~= nil
end, {
  "context_commentstring",
  "matchup",
  plugin_utils.check_enabled_plugin("nvimGPS", "nvim-gps"),
  plugin_utils.check_condition("highlight_current_scope", enable_config.highlight_current_scope),
  plugin_utils.check_condition("highlight_definitions", enable_config.highlight_definitions),
  "navigation",
  "smart_rename",
})

vim.api.nvim_create_autocmd({ "FocusGained" }, {
  group = augroup_id,
  pattern = "*",
  callback = function()
    for _, module in ipairs(global_idle_disabled_modules) do
      vim.cmd([[TSEnable ]] .. module)
    end
  end,
})
vim.api.nvim_create_autocmd({ "FocusLost" }, {
  group = augroup_id,
  pattern = "*",
  callback = function()
    for _, module in ipairs(global_idle_disabled_modules) do
      vim.cmd([[TSDisable ]] .. module)
    end
  end,
})
