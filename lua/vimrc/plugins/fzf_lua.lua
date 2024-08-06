local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")

local my_fzf_lua = {}

my_fzf_lua.config = {
  -- NOTE: This is the default option in fzf-lua
  -- TODO: Customize this
  rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
}

my_fzf_lua.commands = {
  output = function(cmd)
    fzf_lua.fzf_exec(cmd, { complete = true })
  end,
}

my_fzf_lua.global_actions = {
  -- TODO: Escape unwanted filename
  ["alt-g"] = function(selected, opts)
    actions.vimcmd_file("rightbelow split", selected, opts)
  end,
  ["alt-v"] = function(selected, opts)
    actions.vimcmd_file("rightbelow vsplit", selected, opts)
  end,
}

my_fzf_lua.wrap_opts = function(opts)
  return vim.tbl_deep_extend("force", my_fzf_lua.config, opts)
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
  nnoremap(fzf_lua_prefix .. [[a]], [[<Cmd>FzfLua loclist<CR>]])
  nnoremap(fzf_lua_prefix .. [[A]], [[<Cmd>FzfLua args<CR>]])
  nnoremap(fzf_lua_prefix .. [[b]], [[<Cmd>FzfLua buffers<CR>]])
  nnoremap(fzf_lua_prefix .. [[B]], [[<Cmd>FzfLua git_branches<CR>]])
  nnoremap(fzf_lua_prefix .. [[c]], [[<Cmd>FzfLua git_bcommits<CR>]])
  nnoremap(fzf_lua_prefix .. [[C]], [[<Cmd>FzfLua git_commits<CR>]])
  nnoremap(fzf_lua_prefix .. [[f]], [[<Cmd>FzfLua files<CR>]])
  nnoremap(fzf_lua_prefix .. [[g]], [[<Cmd>FzfLua git_files<CR>]])
  nnoremap(fzf_lua_prefix .. [[G]], [[<Cmd>FzfLua live_grep_glob<CR>]])
  nnoremap(fzf_lua_prefix .. [[h]], [[<Cmd>FzfLua help_tags<CR>]])
  nnoremap(fzf_lua_prefix .. [[H]], [[<Cmd>FzfLua git_stash<CR>]])
  nnoremap(fzf_lua_prefix .. [[i]], [[<Cmd>FzfLua live_grep_native<CR>]])
  nnoremap(fzf_lua_prefix .. [[I]], [[<Cmd>FzfLua live_grep_resume<CR>]])
  nnoremap(fzf_lua_prefix .. [[j]], [[<Cmd>FzfLua jumps<CR>]])
  nnoremap(fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_cword<CR>]])
  xnoremap(fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_visual<CR>]]) -- For muscle memory of grepping visual selection using fzf.vim
  nnoremap(fzf_lua_prefix .. [[K]], [[<Cmd>FzfLua grep_cWORD<CR>]])
  nnoremap(fzf_lua_prefix .. [[l]], [[<Cmd>FzfLua blines<CR>]])
  nnoremap(fzf_lua_prefix .. [[L]], [[<Cmd>FzfLua lines<CR>]])
  nnoremap(fzf_lua_prefix .. [[m]], [[<Cmd>FzfLua oldfiles<CR>]])
  nnoremap(fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep<CR>]])
  xnoremap(fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep_visual<CR>]])
  nnoremap(fzf_lua_prefix .. [[P]], [[<Cmd>FzfLua tags_grep_cword<CR>]])
  nnoremap(fzf_lua_prefix .. [[q]], [[<Cmd>FzfLua quickfix<CR>]])
  nnoremap(fzf_lua_prefix .. [[Q]], [[<Cmd>FzfLua quickfix_stack<CR>]])
  nnoremap(fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep<CR>]])
  xnoremap(fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep_visual<CR>]])
  nnoremap(fzf_lua_prefix .. [[R]], [[<Cmd>FzfLua grep_project<CR>]])
  nnoremap(fzf_lua_prefix .. [[s]], [[<Cmd>FzfLua git_status<CR>]])
  nnoremap(fzf_lua_prefix .. [[S]], [[<Cmd>FzfLua spell_suggest<CR>]])
  nnoremap(fzf_lua_prefix .. [[t]], [[<Cmd>FzfLua btags<CR>]])
  nnoremap(fzf_lua_prefix .. [[T]], [[<Cmd>FzfLua tags<CR>]])
  nnoremap(fzf_lua_prefix .. [[u]], [[<Cmd>FzfLua resume<CR>]])
  nnoremap(fzf_lua_prefix .. [[v]], [[<Cmd>FzfLua colorschemes<CR>]])
  nnoremap(fzf_lua_prefix .. [[w]], [[<Cmd>FzfLua tabs<CR>]])
  nnoremap(fzf_lua_prefix .. [[x]], [[<Cmd>FzfLua changes<CR>]])
  nnoremap(fzf_lua_prefix .. [[X]], [[<Cmd>FzfLua spell_suggest<CR>]])
  nnoremap(fzf_lua_prefix .. [[y]], [[<Cmd>FzfLua filetypes<CR>]])
  nnoremap(fzf_lua_prefix .. [[,]], [[<Cmd>FzfLua builtin<CR>]])
  nnoremap(fzf_lua_prefix .. [[`]], [[<Cmd>FzfLua marks<CR>]])
  nnoremap(fzf_lua_prefix .. [[']], [[<Cmd>FzfLua registers<CR>]])
  nnoremap(fzf_lua_prefix .. [[;]], [[<Cmd>FzfLua commands<CR>]])
  nnoremap(fzf_lua_prefix .. [[:]], [[<Cmd>FzfLua command_history<CR>]])
  nnoremap(fzf_lua_prefix .. [[/]], [[<Cmd>FzfLua search_history<CR>]])
  nnoremap(fzf_lua_prefix .. [[<Tab>]], [[<Cmd>FzfLua keymaps<CR>]])
  nnoremap(fzf_lua_prefix .. [[<F1>]], [[<Cmd>FzfLua man_pages<CR>]])

  -- Grep
  -- TODO: Add key mapping to grep all files including hidden files
  nnoremap(fzf_lua_prefix .. "e", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({
      cwd = vim.fn.input("Grep in directory: ", ".", "dir"),
      rg_opts = vim.fn.input("Grep options: "),
    }))
  end, { desc = "Grep in directory" })
  nnoremap(fzf_lua_prefix .. "?", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ rg_opts = vim.fn["vimrc#rg#current_type_option"]() }))
  end, { desc = "Grep with current filetype" })
  xnoremap(fzf_lua_prefix .. "?", function()
    fzf_lua.grep_visual(my_fzf_lua.wrap_opts({ rg_opts = vim.fn["vimrc#rg#current_type_option"]() }))
  end, { desc = "Grep with current filetype with visual selection" })
  nnoremap(fzf_lua_prefix .. "3", function()
    fzf_lua.grep_curbuf(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep current buffer" })
  nnoremap(fzf_lua_prefix .. "4", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep with options" })
  xnoremap(fzf_lua_prefix .. "4", function()
    fzf_lua.grep_visual(my_fzf_lua.wrap_opts({ rg_opts = vim.fn.input("Grep options: ") }))
  end, { desc = "Grep with options with visual selection" })
  nnoremap(fzf_lua_prefix .. "5", function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ cwd = vim.fn.expand("%:h") }))
  end, { desc = "Grep in current buffer folder" })
  nnoremap(fzf_lua_prefix .. "6", function()
    fzf_lua.grep({ cwd = vim.fn.FugitiveWorkTree() })
  end, { desc = "Grep in git worktree" })
  nnoremap(fzf_lua_prefix .. "<C-R>", function()
    fzf_lua.grep({ search = vim.fn.getreg(require("vimrc.utils").get_char_string()) })
  end, { desc = "Grep register content" })

  -- Lsp
  nnoremap(fzf_lua_lsp_prefix .. "r", "<Cmd>FzfLua lsp_references<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "d", "<Cmd>FzfLua lsp_definitions<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "D", "<Cmd>FzfLua lsp_declarations<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "t", "<Cmd>FzfLua lsp_typedefs<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "i", "<Cmd>FzfLua lsp_implementations<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "a", "<Cmd>FzfLua lsp_code_actions<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "o", "<Cmd>FzfLua lsp_document_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "s", "<Cmd>FzfLua lsp_workspace_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "S", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "c", "<Cmd>FzfLua lsp_document_diagnostics<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "C", "<Cmd>FzfLua lsp_workspace_diagnostics<CR>")
  nnoremap(fzf_lua_lsp_prefix .. ",", "<Cmd>FzfLua lsp_incoming_calls<CR>")
  nnoremap(fzf_lua_lsp_prefix .. ".", "<Cmd>FzfLua lsp_outgoing_calls<CR>")

  -- Diagnostics
  nnoremap(fzf_lua_diagnostics_prefix .. "x", "<Cmd>FzfLua diagnostics_document<CR>")
  nnoremap(fzf_lua_diagnostics_prefix .. "X", "<Cmd>FzfLua diagnostics_workspace<CR>")

  -- Complete
  inoremap([[<C-Z><C-D>]], [[<Cmd>lua require("fzf-lua").complete_path()<CR>]])
  inoremap([[<C-Z><C-F>]], [[<Cmd>lua require("fzf-lua").complete_file()<CR>]])
  inoremap([[<C-Z><C-L>]], [[<Cmd>lua require("fzf-lua").complete_bline()<CR>]])
  inoremap([[<C-Z><M-l>]], [[<Cmd>lua require("fzf-lua").complete_line()<CR>]])

  -- Custom command
  nnoremap(fzf_lua_prefix .. "<F2>", function()
    local cmd = vim.fn.input("Command: ")
    my_fzf_lua.commands.output(cmd)
  end, { desc = "FzfLua output" })
end

my_fzf_lua.setup = function()
  my_fzf_lua.setup_config()
  my_fzf_lua.setup_command()
  my_fzf_lua.setup_mapping()
end

return my_fzf_lua
