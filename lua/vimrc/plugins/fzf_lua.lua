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
    local candidate = cmd

    -- NOTE: Execute command as vim command if starting with `:`
    if string.match(cmd, "^:") then
      candidate = vim.split(vim.api.nvim_exec2(cmd, { output = true }).output, "\n")
    end

    fzf_lua.fzf_exec(candidate, { complete = true })
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
    defaults = {
      actions = my_fzf_lua.global_actions,
    },
    grep = {
      no_esc = true,
    },
    oldfiles = {
      include_current_session = true, -- include bufs from current session
    },
  }

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
  -- TODO: `vim.ui.input()` do not complete, study why
  local fzf_lua_prefix = [[<Space>f]]
  local fzf_lua_lsp_prefix = [[<Space>l]]
  local fzf_lua_diagnostics_prefix = [[<Space>l]]

  -- General
  vim.keymap.set("n", fzf_lua_prefix .. [[a]], [[<Cmd>FzfLua loclist<CR>]], { desc = "FzfLua loclist" })
  vim.keymap.set("n", fzf_lua_prefix .. [[A]], [[<Cmd>FzfLua args<CR>]], { desc = "FzfLua args" })
  vim.keymap.set("n", fzf_lua_prefix .. [[b]], [[<Cmd>FzfLua buffers<CR>]], { desc = "FzfLua buffers" })
  vim.keymap.set("n", fzf_lua_prefix .. [[B]], [[<Cmd>FzfLua git_branches<CR>]], { desc = "FzfLua git_branches" })
  vim.keymap.set("n", fzf_lua_prefix .. [[c]], [[<Cmd>FzfLua git_bcommits<CR>]], { desc = "FzfLua git_bcommits" })
  vim.keymap.set("n", fzf_lua_prefix .. [[C]], [[<Cmd>FzfLua git_commits<CR>]], { desc = "FzfLua git_commits" })
  vim.keymap.set("n", fzf_lua_prefix .. [[f]], [[<Cmd>FzfLua files<CR>]], { desc = "FzfLua files" })
  vim.keymap.set("n", fzf_lua_prefix .. [[g]], [[<Cmd>FzfLua git_files<CR>]], { desc = "FzfLua git_files" })
  vim.keymap.set("n", fzf_lua_prefix .. [[G]], [[<Cmd>FzfLua live_grep_glob<CR>]], { desc = "FzfLua live_grep_glob" })
  vim.keymap.set("n", fzf_lua_prefix .. [[h]], [[<Cmd>FzfLua help_tags<CR>]], { desc = "FzfLua help_tags" })
  vim.keymap.set("n", fzf_lua_prefix .. [[H]], [[<Cmd>FzfLua git_stash<CR>]], { desc = "FzfLua git_stash" })
  vim.keymap.set("n", fzf_lua_prefix .. [[i]], [[<Cmd>FzfLua live_grep<CR>]], { desc = "FzfLua live_grep" })
  vim.keymap.set("n", fzf_lua_prefix .. [[I]], [[<Cmd>FzfLua live_grep_native<CR>]], { desc = "FzfLua live_grep_native" })
  vim.keymap.set("n", fzf_lua_prefix .. [[j]], [[<Cmd>FzfLua jumps<CR>]], { desc = "FzfLua jumps" })
  vim.keymap.set("n", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_cword<CR>]], { desc = "FzfLua grep_cword" })
  vim.keymap.set("x", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_visual<CR>]], { desc = "FzfLua grep_visual" }) -- For muscle memory of grepping visual selection using fzf.vim
  vim.keymap.set("n", fzf_lua_prefix .. [[K]], [[<Cmd>FzfLua grep_cWORD<CR>]], { desc = "FzfLua grep_cWORD" })
  vim.keymap.set("n", fzf_lua_prefix .. [[l]], [[<Cmd>FzfLua blines<CR>]], { desc = "FzfLua blines" })
  vim.keymap.set("n", fzf_lua_prefix .. [[L]], [[<Cmd>FzfLua lines<CR>]], { desc = "FzfLua lines" })
  vim.keymap.set("n", fzf_lua_prefix .. [[m]], [[<Cmd>FzfLua oldfiles<CR>]], { desc = "FzfLua oldfiles" })
  vim.keymap.set("n", fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep<CR>]], { desc = "FzfLua tags_grep" })
  vim.keymap.set("x", fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep_visual<CR>]], { desc = "FzfLua tags_grep_visual" })
  vim.keymap.set("n", fzf_lua_prefix .. [[P]], [[<Cmd>FzfLua tags_grep_cword<CR>]], { desc = "FzfLua tags_grep_cword" })
  vim.keymap.set("n", fzf_lua_prefix .. [[q]], [[<Cmd>FzfLua quickfix<CR>]], { desc = "FzfLua quickfix" })
  vim.keymap.set("n", fzf_lua_prefix .. [[Q]], [[<Cmd>FzfLua grep_quickfix<CR>]], { desc = "FzfLua grep_quickfix" })
  vim.keymap.set("n", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep<CR>]], { desc = "FzfLua grep" })
  vim.keymap.set("x", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep_visual<CR>]], { desc = "FzfLua grep_visual" })
  vim.keymap.set("n", fzf_lua_prefix .. [[R]], [[<Cmd>FzfLua grep_project<CR>]], { desc = "FzfLua grep_project" })
  vim.keymap.set("n", fzf_lua_prefix .. [[s]], [[<Cmd>FzfLua git_status<CR>]], { desc = "FzfLua git_status" })
  vim.keymap.set("n", fzf_lua_prefix .. [[S]], [[<Cmd>FzfLua spell_suggest<CR>]], { desc = "FzfLua spell_suggest" })
  vim.keymap.set("n", fzf_lua_prefix .. [[t]], [[<Cmd>FzfLua btags<CR>]], { desc = "FzfLua btags" })
  vim.keymap.set("n", fzf_lua_prefix .. [[T]], [[<Cmd>FzfLua tags<CR>]], { desc = "FzfLua tags" })
  vim.keymap.set("n", fzf_lua_prefix .. [[u]], [[<Cmd>FzfLua resume<CR>]], { desc = "FzfLua resume" })
  vim.keymap.set("n", fzf_lua_prefix .. [[U]], [[<Cmd>FzfLua live_grep_resume<CR>]], { desc = "FzfLua live_grep_resume" })
  vim.keymap.set("n", fzf_lua_prefix .. [[v]], [[<Cmd>FzfLua colorschemes<CR>]], { desc = "FzfLua colorschemes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[w]], [[<Cmd>FzfLua tabs<CR>]], { desc = "FzfLua tabs" })
  vim.keymap.set("n", fzf_lua_prefix .. [[x]], [[<Cmd>FzfLua changes<CR>]], { desc = "FzfLua changes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[X]], [[<Cmd>FzfLua spell_suggest<CR>]], { desc = "FzfLua spell_suggest" })
  vim.keymap.set("n", fzf_lua_prefix .. [[y]], [[<Cmd>FzfLua filetypes<CR>]], { desc = "FzfLua filetypes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[Y]], [[<Cmd>FzfLua highlights<CR>]], { desc = "FzfLua highlights" })
  vim.keymap.set("n", fzf_lua_prefix .. [[,]], [[<Cmd>FzfLua builtin<CR>]], { desc = "FzfLua builtin" })
  vim.keymap.set("n", fzf_lua_prefix .. [[`]], [[<Cmd>FzfLua marks<CR>]], { desc = "FzfLua marks" })
  vim.keymap.set("n", fzf_lua_prefix .. [[']], [[<Cmd>FzfLua registers<CR>]], { desc = "FzfLua registers" })
  vim.keymap.set("n", fzf_lua_prefix .. [[;]], [[<Cmd>FzfLua commands<CR>]], { desc = "FzfLua commands" })
  vim.keymap.set("n", fzf_lua_prefix .. [[:]], [[<Cmd>FzfLua command_history<CR>]], { desc = "FzfLua command_history" })
  vim.keymap.set("n", fzf_lua_prefix .. [[/]], [[<Cmd>FzfLua search_history<CR>]], { desc = "FzfLua search_history" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<Tab>]], [[<Cmd>FzfLua keymaps<CR>]], { desc = "FzfLua keymaps" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<F1>]], [[<Cmd>FzfLua man_pages<CR>]], { desc = "FzfLua man_pages" })

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
  vim.keymap.set("n", fzf_lua_prefix .. "%", function()
    fzf_lua.files({ query = vim.fn.expand("%:t:r") })
  end, { desc = "Files with current filename" })
  vim.keymap.set("n", fzf_lua_prefix .. "^", function()
    fzf_lua.files({ query = vim.fn.expand("%:t") })
  end, { desc = "Files with current filename with extension" })

  -- Grep
  -- TODO: Add key mapping to grep all files including hidden files
  vim.keymap.set("n", fzf_lua_prefix .. "e", function()
    -- FIXME: fzf_lua.grep() does not correctly parse line & column number
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

  -- Quickfix build error
  vim.keymap.set("n", fzf_lua_prefix .. "E", function()
    -- NOTE: `!:0` to exclude non-error lines
    fzf_lua.quickfix({ query = "!:0" })
  end, { desc = "Quickfix with build error" })

  -- Lsp
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "r", "<Cmd>FzfLua lsp_references<CR>", { desc = "FzfLua lsp_references" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "d", "<Cmd>FzfLua lsp_definitions<CR>", { desc = "FzfLua lsp_definitions" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "D", "<Cmd>FzfLua lsp_declarations<CR>", { desc = "FzfLua lsp_declarations" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "t", "<Cmd>FzfLua lsp_typedefs<CR>", { desc = "FzfLua lsp_typedefs" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "i", "<Cmd>FzfLua lsp_implementations<CR>", { desc = "FzfLua lsp_implementations" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "a", "<Cmd>FzfLua lsp_code_actions<CR>", { desc = "FzfLua lsp_code_actions" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "o", "<Cmd>FzfLua lsp_document_symbols<CR>", { desc = "FzfLua lsp_document_symbols" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "S", "<Cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "FzfLua lsp_workspace_symbols" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "s", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>", { desc = "FzfLua lsp_live_workspace_symbols" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "c", "<Cmd>FzfLua lsp_document_diagnostics<CR>", { desc = "FzfLua lsp_document_diagnostics" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "C", "<Cmd>FzfLua lsp_workspace_diagnostics<CR>", { desc = "FzfLua lsp_workspace_diagnostics" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. ",", "<Cmd>FzfLua lsp_incoming_calls<CR>", { desc = "FzfLua lsp_incoming_calls" })
  vim.keymap.set("n", fzf_lua_lsp_prefix .. ".", "<Cmd>FzfLua lsp_outgoing_calls<CR>", { desc = "FzfLua lsp_outgoing_calls" })

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
  vim.keymap.set(
    "n",
    fzf_lua_diagnostics_prefix .. "x",
    "<Cmd>FzfLua diagnostics_document<CR>",
    { desc = "FzfLua diagnostics_document" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_diagnostics_prefix .. "X",
    "<Cmd>FzfLua diagnostics_workspace<CR>",
    { desc = "FzfLua diagnostics_workspace" }
  )

  -- Complete
  vim.keymap.set(
    "i",
    [[<C-Z><C-D>]],
    [[<Cmd>lua require("fzf-lua").complete_path()<CR>]],
    { desc = "FzfLua complete_path" }
  )
  vim.keymap.set(
    "i",
    [[<C-Z><C-F>]],
    [[<Cmd>lua require("fzf-lua").complete_file()<CR>]],
    { desc = "FzfLua complete_file" }
  )
  vim.keymap.set(
    "i",
    [[<C-Z><C-L>]],
    [[<Cmd>lua require("fzf-lua").complete_bline()<CR>]],
    { desc = "FzfLua complete_bline" }
  )
  vim.keymap.set(
    "i",
    [[<C-Z><M-l>]],
    [[<Cmd>lua require("fzf-lua").complete_line()<CR>]],
    { desc = "FzfLua complete_line" }
  )

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
