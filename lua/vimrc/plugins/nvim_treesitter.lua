-- TODO: Refactor to other files
local choose = require("vimrc.choose")
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

nvim_treesitter.is_enabled = function(buf)
  buf = buf or 0
  return vim.treesitter.highlighter.active[buf] ~= nil
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

nvim_treesitter.get_ensure_installed = function()
  return vim.tbl_filter(function(language)
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
end

nvim_treesitter.setup_config = function()
  -- NOTE: On nvim-treesitter main branch, TS.setup() only accepts TSConfig (install_dir).
  -- highlight/indent/incremental_selection/matchup/yati are no longer module options.
  TS.setup({
    -- update_strategy = "github", -- Enable when installing alternative parsers for built-in parsers
  })
  TS.install(nvim_treesitter.get_ensure_installed())
end

nvim_treesitter.setup_filetype_autocmd = function()
  local augroup_id = vim.api.nvim_create_augroup("nvim_treesitter_filetype", {})

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup_id,
    callback = function(args)
      local buf = args.buf
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft)

      -- Skip if no treesitter parser for this filetype
      if not lang then
        return
      end

      -- Skip if parser is not installed
      if not vim.treesitter.get_parser(buf, nil, { error = false }) then
        return
      end

      -- Skip if force-disabled or filetype-disabled
      if base_disable_check(ft, buf) then
        return
      end

      -- Syntax highlighting
      vim.treesitter.start(buf)

      -- Indentation
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
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
        -- ["@class.outer"] = "<c-v>", -- blockwise
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

nvim_treesitter.setup_mapping = function()
  -- Incremental Selection
  -- Ref: https://github.com/neovim/neovim/pull/36993/changes#diff-fcb32cf99107c4b71f964a0949cf50edcf3965c1191152e3d8db1256f5513ba7R450-R472
  vim.keymap.set({ "x" }, "[`", function()
    require("vim.treesitter._select").select_prev(vim.v.count1)
  end, { desc = "Select previous treesitter node" })

  vim.keymap.set({ "x" }, "]`", function()
    require("vim.treesitter._select").select_next(vim.v.count1)
  end, { desc = "Select next treesitter node" })

  vim.keymap.set({ "x", "o" }, "<Tab>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
      require("vim.treesitter._select").select_parent(vim.v.count1)
    else
      vim.lsp.buf.selection_range(vim.v.count1)
    end
  end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

  vim.keymap.set({ "x", "o" }, "<S-Tab>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
      require("vim.treesitter._select").select_child(vim.v.count1)
    else
      vim.lsp.buf.selection_range(-vim.v.count1)
    end
  end, { desc = "Select child treesitter node or inner incremental lsp selections" })

  -- Context
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
  nvim_treesitter.setup_filetype_autocmd()
  nvim_treesitter.setup_textobjects()
  nvim_treesitter.setup_extensions()
  nvim_treesitter.setup_mapping()
end

return nvim_treesitter
