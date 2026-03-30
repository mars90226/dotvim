-- TODO: Refactor to other files
local check = require("vimrc.check")
local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local TS = require("nvim-treesitter")
local parsers = require("nvim-treesitter.parsers")

local nvim_treesitter = {}

nvim_treesitter.filetype_disable = {
  diff = true, -- NOTE: tree-sitter-diff doesn't support `git format-patch` diffs
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
local disable_check = function(lang, bufnr)
  if get_force_disable(bufnr) then
    return true
  end
  if nvim_treesitter.filetype_disable[lang] then
    return true
  end

  return false
end

-- Disable check for highlight module
local base_disable_check = function(lang, bufnr)
  return disable_check(lang, bufnr)
end
local current_buffer_base_highlight_disable_check = function()
  local ft = vim.bo.ft
  local bufnr = vim.fn.bufnr()
  return base_disable_check(ft, bufnr)
end

nvim_treesitter.is_enabled = function(module, buf)
  buf = buf or 0
  local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
  return TS.is_enabled(module, lang, buf)
end

nvim_treesitter.buf_is_supported = function(buf)
  return vim.treesitter.get_parser(buf or 0, nil, { error = false }) ~= nil
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
  parsers.norg = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg",
      files = { "src/parser.c", "src/scanner.cc" },
      branch = "main",
    },
  }

  parsers.norg_meta = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
      files = { "src/parser.c" },
      branch = "main",
    },
  }

  parsers.norg_table = {
    install_info = {
      url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
      files = { "src/parser.c" },
      branch = "main",
    },
  }

  -- TODO: Use repo in https://github.com/serenadeai/tree-sitter-scss/pull/19
  parsers.scss = {
    install_info = {
      url = "https://github.com/goncharov/tree-sitter-scss",
      files = { "src/parser.c", "src/scanner.c" },
      branch = "placeholders",
      revision = "30c9dc19d3292fa8d1134373f0f0abd8547076e8",
    },
    maintainers = { "@goncharov" },
  }

  -- For patterns.nvim
  parsers.lua_patterns = {
    install_info = {
      url = "https://github.com/OXY2DEV/tree-sitter-lua_patterns",
      files = { "src/parser.c" },
      branch = "main",
    },
  }

  parsers.qf = {
    install_info = {
      url = "https://github.com/OXY2DEV/tree-sitter-qf",
      files = { "src/parser.c" },
      branch = "main",
    },
  }
end

nvim_treesitter.setup_config = function()
  TS.setup({
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
      end,
    },
    indent = {
      enable = false, -- Currently, nvim-treesitter indent is WIP and not ready for production use
    },
    -- NOTE: textobjects config moved to nvim_treesitter.setup_textobjects() for main branch
    matchup = {
      enable = not current_buffer_base_highlight_disable_check(), -- enable unless our disable check says otherwise
      -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
    },
    -- TODO: Disabled as nvim-yati not migrating to main branch yet. (maybe never)
    -- yati = {
    --   enable = true,
    -- },
  })
  TS.install(
    vim.tbl_filter(function(language)
      return language ~= nil
    end, {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "css",
      "csv",
      "diff",
      "doxygen",
      "editorconfig",
      "fennel",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "html",
      "http",
      "hurl",
      "ini",
      "javascript",
      "jq",
      "jsdoc",
      "json",
      "just",
      "lua",
      "luadoc",
      "luap",
      "make",
      "markdown",
      "markdown_inline",
      -- TODO: Disabled as "skipped unsupported language: norg" nvim-treesitter warning
      -- plugin_utils.check_condition("norg", not check.os_is("mac")),
      "nu",
      "perl",
      "php",
      "powershell",
      "printf",
      "proto",
      "python",
      "query",
      "regex",
      "requirements",
      "rst",
      "ruby",
      "rust",
      "scss",
      "sql",
      "ssh_config",
      "teal",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "xml",
      "yaml",
    })
  )
end

nvim_treesitter.setup_textobjects = function()
  local ts_textobjects = require("nvim-treesitter-textobjects")
  local ts_select = require("nvim-treesitter-textobjects.select")
  local ts_swap = require("nvim-treesitter-textobjects.swap")
  local ts_move = require("nvim-treesitter-textobjects.move")

  ts_textobjects.setup({
    select = {
      lookahead = true,
      selection_modes = {
        ["@parameter.outer"] = "v", -- charwise
        ["@function.outer"] = "V", -- linewise
        ["@class.outer"] = "<C-v>", -- blockwise
      },
    },
    move = {
      set_jumps = true,
    },
  })

  -- Select
  -- FIXME: The keymaps are not working, due to mini.nvim ai module?
  local select_maps = {
    ["af"] = { "@function.outer", "textobjects", desc = "Select outer function" },
    ["if"] = { "@function.inner", "textobjects", desc = "Select inner function" },
    ["ac"] = { "@class.outer", "textobjects", desc = "Select outer class" },
    ["ic"] = { "@class.inner", "textobjects", desc = "Select inner part of a class region" },
    ["as"] = { "@scope", "locals", desc = "Select language scope" },
  }
  for lhs, map in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, lhs, function()
      ts_select.select_textobject(map[1], map[2])
    end, { silent = true, desc = map.desc })
  end

  -- Swap
  vim.keymap.set("n", "czn", function()
    ts_swap.swap_next("@parameter.inner")
  end, { silent = true, desc = "Swap next parameter" })
  vim.keymap.set("n", "czp", function()
    ts_swap.swap_previous("@parameter.inner")
  end, { silent = true, desc = "Swap previous parameter" })

  -- Move
  local move_maps = {
    { "]m", "goto_next_start", "@function.outer", "Go to next function start" },
    { "]]", "goto_next_start", "@class.outer", "Go to next class start" },
    { "]M", "goto_next_end", "@function.outer", "Go to next function end" },
    { "][", "goto_next_end", "@class.outer", "Go to next class end" },
    { "[m", "goto_previous_start", "@function.outer", "Go to previous function start" },
    { "[[", "goto_previous_start", "@class.outer", "Go to previous class start" },
    { "[M", "goto_previous_end", "@function.outer", "Go to previous function end" },
    { "[]", "goto_previous_end", "@class.outer", "Go to previous class end" },
  }
  for _, map in ipairs(move_maps) do
    vim.keymap.set({ "n", "x", "o" }, map[1], function()
      ts_move[map[2]](map[3], "textobjects")
    end, { silent = true, desc = map[4] })
  end

  -- NOTE: lsp_interop (peek_definition_code) removed in textobjects main branch
end

nvim_treesitter.setup_extensions = function()
  -- nvim-treesitter-context
  local context_default_enable = choose.is_enabled_plugin("nvim-treesitter-context")
  local context_enable = utils.ternary(context_default_enable, not current_buffer_base_highlight_disable_check(), false)
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
          -- FIXME: Should check if current buffer is supported by treesitter
          -- || Error detected while processing DiagnosticChanged Autocommands for "*":
          -- || Error executing lua callback: ...vim-treesitter-context/lua/treesitter-context/render.lua:43: E565: Not allowed to change text or change window
          -- || stack traceback:
          -- || 	[C]: in function 'nvim_open_win'
          -- || 	...vim-treesitter-context/lua/treesitter-context/render.lua:43: in function 'display_window'
          -- || 	...vim-treesitter-context/lua/treesitter-context/render.lua:401: in function 'open'
          -- || 	.../lazy/nvim-treesitter-context/lua/treesitter-context.lua:98: in function 'f'
          -- || 	.../lazy/nvim-treesitter-context/lua/treesitter-context.lua:29: in function 'update_single_context'
          -- || 	.../lazy/nvim-treesitter-context/lua/treesitter-context.lua:116: in function <.../lazy/nvim-treesitter-context/lua/treesitter-context.lua:102>
          -- || 	[C]: in function 'nvim_exec_autocmds'
          -- || 	/usr/local/share/nvim/runtime/lua/vim/diagnostic.lua:2055: in function 'reset'
          -- || 	/usr/local/share/nvim/runtime/lua/vim/lsp.lua:532: in function 'buf_detach_client'
          -- || 	/usr/local/share/nvim/runtime/lua/vim/lsp.lua:611: in function </usr/local/share/nvim/runtime/lua/vim/lsp.lua:608>
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

  -- NOTE: On nvim-treesitter main branch, TSEnable/TSDisable commands are gone.
  -- Only toggle highlight via core vim.treesitter.start()/stop() API.
  -- context_commentstring and matchup are separate plugins now, not treesitter modules.

  ---Enable treesitter highlight on all supported buffers
  local enable_highlight_all = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and nvim_treesitter.buf_is_supported(buf) then
        pcall(vim.treesitter.start, buf)
      end
    end
  end

  ---Disable treesitter highlight on all supported buffers
  local disable_highlight_all = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        pcall(vim.treesitter.stop, buf)
      end
    end
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
        enable_highlight_all()
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
          disable_highlight_all()
          global_trick_delay_enable = false
        end
      end, global_trick_delay)
    end,
  })
end

nvim_treesitter.setup_mapping = function()
  vim.keymap.set("n", "<Space><F6>", function()
    local buf = vim.api.nvim_get_current_buf()
    buffer_toggle_force_disable(buf)
    if get_force_disable(buf) then
      vim.treesitter.stop(buf)
    else
      vim.treesitter.start(buf)
    end
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
  nvim_treesitter.setup_textobjects()
  nvim_treesitter.setup_extensions()
  nvim_treesitter.setup_performance_trick()
  nvim_treesitter.setup_mapping()
end

return nvim_treesitter
