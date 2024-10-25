local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")
local utils = require("fzf-lua.utils")

local my_fzf_lua = {}

my_fzf_lua.config = {
  fzf_lua_opts = {
    -- NOTE: This is the default option in fzf-lua
    -- TODO: Customize this
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
  },
  project_word = {
    loaded = false,
  },
}

my_fzf_lua.sources = {
  project_word = {},
}

my_fzf_lua.commands = {
  output = function(cmd)
    fzf_lua.fzf_exec(cmd, { complete = true })
  end,
  project_word = function()
    my_fzf_lua.load_project_words()
    fzf_lua.fzf_exec(my_fzf_lua.sources.project_word, { complete = true })
  end,
}

my_fzf_lua.global_actions = {
  -- TODO: Escape unwanted filename
  ["alt-g"] = function(selected, opts)
    actions.vimcmd_entry("rightbelow split", selected, opts)
  end,
  ["alt-v"] = function(selected, opts)
    actions.vimcmd_entry("rightbelow vsplit", selected, opts)
  end,
}

-- Refactor this
my_fzf_lua.load_project_words = function()
  if my_fzf_lua.config.project_word.loaded then
    return
  end

  my_fzf_lua.add_project_words(vim.g.project_words)
  my_fzf_lua.config.project_word.loaded = true
end

my_fzf_lua.add_project_words = function(words)
  vim.list_extend(my_fzf_lua.sources.project_word, words)
end

my_fzf_lua.wrap_opts = function(opts)
  return vim.tbl_deep_extend("force", my_fzf_lua.config.fzf_lua_opts, opts)
end

my_fzf_lua.setup_config = function()
  local opts = {
    winopts = {
      width = 0.9,
      height = 0.9,
    },
  }
  local providers = {
    "files",
    "grep",
    "args",
    "oldfiles",
    "buffers",
    "tabs",
    "lines",
    "blines",
    "tags",
    "btags",
    "diagnostics",
  }
  for _, provider in ipairs(providers) do
    opts[provider] = {
      actions = my_fzf_lua.global_actions,
    }
  end
  -- TODO: Refactor this
  opts.git = {
    files = {
      actions = my_fzf_lua.global_actions,
    },
  }
  opts.grep = {
    no_esc = true,
  }
  -- TODO: Add lsp

  fzf_lua.setup(opts)

  -- TODO: Setup code action preview
  -- Ref: https://github.com/ibhagwan/fzf-lua/issues/944#issuecomment-1849104750
end

my_fzf_lua.setup_command = function()
  local fzf_lua_command_prefix = "FzfLua"

  vim.api.nvim_create_user_command(fzf_lua_command_prefix .. "Output", function(opts)
    local cmd = table.concat(opts.fargs, " ")
    my_fzf_lua.commands.output(cmd)
  end, { nargs = "+" })
end

my_fzf_lua.setup_mapping = function()
  -- TODO: Add key mapping description
  -- TODO: `vim.ui.input()` do not complete, study why
  local fzf_lua_prefix = [[<Space>f]]
  local fzf_lua_lsp_prefix = [[<Space>l]]
  local fzf_lua_diagnostics_prefix = [[<Space>l]]

  -- General
  vim.keymap.set("n", fzf_lua_prefix .. [[a]], [[<Cmd>FzfLua loclist<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[A]], [[<Cmd>FzfLua args<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[b]], [[<Cmd>FzfLua buffers<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[B]], [[<Cmd>FzfLua git_branches<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[c]], [[<Cmd>FzfLua git_bcommits<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[C]], [[<Cmd>FzfLua git_commits<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[f]], [[<Cmd>FzfLua files<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[g]], [[<Cmd>FzfLua git_files<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[G]], [[<Cmd>FzfLua live_grep_glob<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[h]], [[<Cmd>FzfLua help_tags<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[H]], [[<Cmd>FzfLua git_stash<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[i]], [[<Cmd>FzfLua live_grep_native<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[I]], [[<Cmd>FzfLua live_grep_resume<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[j]], [[<Cmd>FzfLua jumps<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_cword<CR>]])
  vim.keymap.set("x", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_visual<CR>]]) -- For muscle memory of grepping visual selection using fzf.vim
  vim.keymap.set("n", fzf_lua_prefix .. [[K]], [[<Cmd>FzfLua grep_cWORD<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[l]], [[<Cmd>FzfLua blines<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[L]], [[<Cmd>FzfLua lines<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[m]], [[<Cmd>FzfLua oldfiles<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep<CR>]])
  vim.keymap.set("x", fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep_visual<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[P]], [[<Cmd>FzfLua tags_grep_cword<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[q]], [[<Cmd>FzfLua quickfix<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[Q]], [[<Cmd>FzfLua grep_quickfix<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep<CR>]])
  vim.keymap.set("x", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep_visual<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[R]], [[<Cmd>FzfLua grep_project<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[s]], [[<Cmd>FzfLua git_status<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[S]], [[<Cmd>FzfLua spell_suggest<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[t]], [[<Cmd>FzfLua btags<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[T]], [[<Cmd>FzfLua tags<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[u]], [[<Cmd>FzfLua resume<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[v]], [[<Cmd>FzfLua colorschemes<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[w]], [[<Cmd>FzfLua tabs<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[x]], [[<Cmd>FzfLua changes<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[X]], [[<Cmd>FzfLua spell_suggest<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[y]], [[<Cmd>FzfLua filetypes<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[Y]], [[<Cmd>FzfLua highlights<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[,]], [[<Cmd>FzfLua builtin<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[`]], [[<Cmd>FzfLua marks<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[']], [[<Cmd>FzfLua registers<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[;]], [[<Cmd>FzfLua commands<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[:]], [[<Cmd>FzfLua command_history<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[/]], [[<Cmd>FzfLua search_history<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[<Tab>]], [[<Cmd>FzfLua keymaps<CR>]])
  vim.keymap.set("n", fzf_lua_prefix .. [[<F1>]], [[<Cmd>FzfLua man_pages<CR>]])

  -- Files
  vim.keymap.set("n", fzf_lua_prefix .. "n", function()
    fzf_lua.files({ query = vim.fn.expand("<cword>") })
  end, { desc = "Files with cursor word" })
  vim.keymap.set("n", fzf_lua_prefix .. "N", function()
    fzf_lua.files({ query = vim.fn.expand("<cWORD>") })
  end, { desc = "Files with cursor WORD" })
  vim.keymap.set("x", fzf_lua_prefix .. "n", function()
    fzf_lua.files({ query = utils.get_visual_selection() })
  end, { desc = "Files with visual selection" })

  -- Grep
  -- TODO: Add key mapping to grep all files including hidden files
  vim.keymap.set("n", fzf_lua_prefix .. "e", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({
      cwd = vim.fn.input("Grep in directory: ", ".", "dir"),
      rg_opts = vim.fn.input("Grep options: "),
    }))
  end, { desc = "Grep in directory" })
  vim.keymap.set("n", fzf_lua_prefix .. "?", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ rg_opts = vim.fn["vimrc#rg#current_type_option"]() }))
  end, { desc = "Grep with current filetype" })
  vim.keymap.set("x", fzf_lua_prefix .. "?", function()
    fzf_lua.grep_visual(my_fzf_lua.wrap_opts({ rg_opts = vim.fn["vimrc#rg#current_type_option"]() }))
  end, { desc = "Grep with current filetype with visual selection" })
  vim.keymap.set("n", fzf_lua_prefix .. "2", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ no_esc = false }))
  end, { desc = "Grep fixed string" })
  vim.keymap.set("x", fzf_lua_prefix .. "2", function()
    fzf_lua.grep_visual(my_fzf_lua.wrap_opts({ no_esc = false }))
  end, { desc = "Grep fixed string with visual selection" })
  vim.keymap.set("n", fzf_lua_prefix .. "3", function()
    fzf_lua.grep_curbuf(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep current buffer" })
  vim.keymap.set("x", fzf_lua_prefix .. "3", function()
    fzf_lua.grep_curbuf(
      my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: "), search = utils.get_visual_selection() })
    )
  end, { desc = "Grep current buffer with visual selection" })
  vim.keymap.set("n", fzf_lua_prefix .. "4", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep with options" })
  vim.keymap.set("x", fzf_lua_prefix .. "4", function()
    fzf_lua.grep_visual(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep with options with visual selection" })
  vim.keymap.set("n", fzf_lua_prefix .. "5", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ cwd = vim.fn.expand("%:h") }))
  end, { desc = "Grep in current buffer folder" })
  vim.keymap.set("n", fzf_lua_prefix .. "6", function()
    fzf_lua.grep({ cwd = vim.fn.FugitiveWorkTree() })
  end, { desc = "Grep in git worktree" })
  vim.keymap.set("n", fzf_lua_prefix .. "<C-R>", function()
    fzf_lua.grep({ search = vim.fn.getreg(require("vimrc.utils").get_char_string()) })
  end, { desc = "Grep register content" })

  -- Lsp
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "r", "<Cmd>FzfLua lsp_references<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "d", "<Cmd>FzfLua lsp_definitions<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "D", "<Cmd>FzfLua lsp_declarations<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "t", "<Cmd>FzfLua lsp_typedefs<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "i", "<Cmd>FzfLua lsp_implementations<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "a", "<Cmd>FzfLua lsp_code_actions<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "o", "<Cmd>FzfLua lsp_document_symbols<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "S", "<Cmd>FzfLua lsp_workspace_symbols<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "s", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "c", "<Cmd>FzfLua lsp_document_diagnostics<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "C", "<Cmd>FzfLua lsp_workspace_diagnostics<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. ",", "<Cmd>FzfLua lsp_incoming_calls<CR>")
  vim.keymap.set("n", fzf_lua_lsp_prefix .. ".", "<Cmd>FzfLua lsp_outgoing_calls<CR>")

  vim.keymap.set("n", fzf_lua_lsp_prefix .. "Q", function()
    fzf_lua.lsp_workspace_symbols({ query = vim.fn.input("Query: ") })
  end, { desc = "Lsp workspace symbols with query" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "q", function()
    fzf_lua.lsp_live_workspace_symbols({ query = vim.fn.input("Query: ") })
  end, { desc = "Lsp live workspace symbols with query" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "K", function()
    fzf_lua.lsp_workspace_symbols({ query = vim.fn.expand("<cword>") })
  end, { desc = "Lsp workspace symbols with cword" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "k", function()
    fzf_lua.lsp_live_workspace_symbols({ query = vim.fn.expand("<cword>") })
  end, { desc = "Lsp live workspace symbols with cword" })

  -- Diagnostics
  vim.keymap.set("n", fzf_lua_diagnostics_prefix .. "x", "<Cmd>FzfLua diagnostics_document<CR>")
  vim.keymap.set("n", fzf_lua_diagnostics_prefix .. "X", "<Cmd>FzfLua diagnostics_workspace<CR>")

  -- Complete
  vim.keymap.set("i", [[<C-Z><C-D>]], [[<Cmd>lua require("fzf-lua").complete_path()<CR>]])
  vim.keymap.set("i", [[<C-Z><C-F>]], [[<Cmd>lua require("fzf-lua").complete_file()<CR>]])
  vim.keymap.set("i", [[<C-Z><C-L>]], [[<Cmd>lua require("fzf-lua").complete_bline()<CR>]])
  vim.keymap.set("i", [[<C-Z><M-l>]], [[<Cmd>lua require("fzf-lua").complete_line()<CR>]])

  -- Custom command
  vim.keymap.set("n", fzf_lua_prefix .. "<F2>", function()
    local cmd = vim.fn.input("Command: ")
    my_fzf_lua.commands.output(cmd)
  end, { desc = "FzfLua output" })

  -- Custom complete
  vim.keymap.set("i", [[<C-Z><C-G>]], function()
    my_fzf_lua.commands.project_word()
  end, { desc = "FzfLua project word" })
end

my_fzf_lua.setup = function()
  my_fzf_lua.setup_config()
  my_fzf_lua.setup_command()
  my_fzf_lua.setup_mapping()
end

return my_fzf_lua
