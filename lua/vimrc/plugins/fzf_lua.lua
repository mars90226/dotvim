local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")
local utils = require("fzf-lua.utils")

local plugin_utils = require("vimrc.plugin_utils")

local my_fzf_lua = {}

my_fzf_lua.config = {
  grep = {
    rg_defaults = "--color=always --smart-case",
    rg_max_columns = "--max-columns=4096",
    -- fzf-lua parses each result as filename:line:column:match.
    rg_location = "--with-filename --no-heading --line-number --column",
    rg_string_options = {
      ["--replace"] = true,
      ["--glob"] = true,
      ["--iglob"] = true,
      ["--regexp"] = true,
      ["--file"] = true,
      ["--ignore-file"] = true,
      ["--pre"] = true,
      ["--pre-glob"] = true,
      ["--hostname-bin"] = true,
      ["--context-separator"] = true,
      ["--field-context-separator"] = true,
      ["--field-match-separator"] = true,
      ["--path-separator"] = true,
    },
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
  ["alt-g"] = {
    fn = function(selected, opts)
      actions.vimcmd_entry("rightbelow split", selected, opts, true)
    end,
    desc = "file-rightbelow-split",
  },
  ["alt-v"] = {
    fn = function(selected, opts)
      actions.vimcmd_entry("rightbelow vsplit", selected, opts, true)
    end,
    desc = "file-rightbelow-vsplit",
  },
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

local function split_grep_separator(extra, rg_string_options)
  local lpeg = vim.lpeg
  local P, S, C, Cp, Cs = lpeg.P, lpeg.S, lpeg.C, lpeg.Cp, lpeg.Cs
  local space = S(" \t\r\n")
  local continuation = P("\\\n") / ""
  local escaped = continuation + (P("\\") / "") * P(1)
  local single_quote = P("'") / ""
  local single_quoted = single_quote * (1 - P("'")) ^ 0 * single_quote
  local double_quote = P('"') / ""
  local double_escape = continuation + (P("\\") / "") * S('\\"$`')
  local double_quoted = double_quote * (double_escape + (1 - P('"'))) ^ 0 * double_quote
  local plain = 1 - S(" \t\r\n\\'\"")
  local word = Cp() * space ^ 0 * Cp() * Cs((escaped + single_quoted + double_quoted + plain) ^ 1) * Cp()
  local end_of_options = space ^ 0 * -P(1)

  -- Break textual " -e " matches without changing literal shell arguments.
  local protect_single = C(single_quoted) / function(raw)
    return (raw:gsub("(%s)%-e%f[%s]", "%1''-e"))
  end
  local nested_expansion = P("$(") + P("${") + P("`")
  local has_nested_expansion = (P("\\") * P(1) + (1 - nested_expansion)) ^ 0 * nested_expansion
  local protect_double = C(double_quoted)
    / function(raw)
      -- Splitting a nested shell expansion would change the argument.
      if has_nested_expansion:match(raw) then
        return raw
      end
      return (raw:gsub("(%s)%-e%f[%s]", '%1""-e'))
    end
  local protect_escape = P("\\") * space * (P("-") / "\\-") * P("e")
  local protect_word = Cs((protect_single + protect_double + protect_escape + P("\\") * P(1) + P(1)) ^ 0)

  local position = 1
  local pending = 1
  local parts = {}
  local takes_value = false
  while true do
    local start, arg_start, arg, next_position = word:match(extra, position)
    if not start then
      parts[#parts + 1] = extra:sub(pending)
      return table.concat(parts), "-e"
    end

    local terminal = end_of_options:match(extra, next_position)
    local is_separator = arg == "--" or arg == "-e" or arg == "--regexp"
    if not takes_value and is_separator and terminal then
      parts[#parts + 1] = extra:sub(pending, start - 1)
      return table.concat(parts), arg == "--" and "--" or "-e"
    end
    local raw = extra:sub(arg_start, next_position - 1)
    local protected = raw
    if (arg == "-e" or arg == "--") and raw == arg then
      -- fzf-lua inserts filename/glob flags using textual separator matches.
      protected = vim.fn.shellescape(arg)
    elseif raw:find("%s%-e") then
      protected = protect_word:match(raw)
    end
    if protected ~= raw then
      parts[#parts + 1] = extra:sub(pending, arg_start - 1) .. protected
      pending = next_position
    end

    if takes_value then
      takes_value = false
    elseif arg:match("^%-[%a%d.]") then
      -- The first short flag taking a value consumes the rest of the cluster.
      local value_flag = arg:find("[ABCEMTdefgjmrt]", 2)
      takes_value = value_flag == #arg
      if takes_value and terminal and arg:sub(value_flag) == "e" then
        parts[#parts + 1] = extra:sub(pending, arg_start - 1) .. arg:sub(1, -2)
        return table.concat(parts), "-e"
      end
    else
      takes_value = rg_string_options[arg] == true
    end
    position = next_position
  end
end

my_fzf_lua.wrap_opts = function(opts)
  local grep = my_fzf_lua.config.grep
  local extra, separator = split_grep_separator(opts.rg_opts or "", grep.rg_string_options)
  local rg_opts = grep.rg_defaults
  if opts.rg_opts == nil then
    rg_opts = rg_opts .. " " .. grep.rg_max_columns
  elseif vim.trim(extra) ~= "" then
    rg_opts = rg_opts .. " " .. extra
  end
  -- fzf-lua appends the query after the trailing separator.
  opts.rg_opts = rg_opts .. " " .. grep.rg_location .. " " .. separator
  return opts
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
    grep = my_fzf_lua.wrap_opts({
      no_esc = true,
    }),
    oldfiles = {
      include_current_session = true, -- include bufs from current session
    },
  }

  -- TODO: Disabled due to sk process not closed when fzf-lua closed
  -- if plugin_utils.is_executable("sk") then
  --   opts = vim.tbl_extend("force", opts, {
  --     fzf_bin = "sk",
  --     fzf_opts = { ["--algo"] = "frizbee" },
  --   })
  -- end

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
  vim.keymap.set(
    "n",
    fzf_lua_prefix .. [[I]],
    [[<Cmd>FzfLua live_grep_native<CR>]],
    { desc = "FzfLua live_grep_native" }
  )
  vim.keymap.set("n", fzf_lua_prefix .. [[j]], [[<Cmd>FzfLua jumps<CR>]], { desc = "FzfLua jumps" })
  vim.keymap.set("n", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_cword<CR>]], { desc = "FzfLua grep_cword" })
  vim.keymap.set("x", fzf_lua_prefix .. [[k]], [[<Cmd>FzfLua grep_visual<CR>]], { desc = "FzfLua grep_visual" }) -- For muscle memory of grepping visual selection using fzf.vim
  vim.keymap.set("n", fzf_lua_prefix .. [[K]], [[<Cmd>FzfLua grep_cWORD<CR>]], { desc = "FzfLua grep_cWORD" })
  vim.keymap.set("n", fzf_lua_prefix .. [[l]], [[<Cmd>FzfLua blines<CR>]], { desc = "FzfLua blines" })
  vim.keymap.set("n", fzf_lua_prefix .. [[L]], [[<Cmd>FzfLua lines<CR>]], { desc = "FzfLua lines" })
  vim.keymap.set("n", fzf_lua_prefix .. [[m]], [[<Cmd>FzfLua oldfiles<CR>]], { desc = "FzfLua oldfiles" })
  vim.keymap.set("n", fzf_lua_prefix .. [[M]], [[<Cmd>FzfLua tmux_buffers<CR>]], { desc = "FzfLua tmux_buffers" })
  vim.keymap.set("n", fzf_lua_prefix .. [[p]], [[<Cmd>FzfLua tags_grep<CR>]], { desc = "FzfLua tags_grep" })
  vim.keymap.set(
    "x",
    fzf_lua_prefix .. [[p]],
    [[<Cmd>FzfLua tags_grep_visual<CR>]],
    { desc = "FzfLua tags_grep_visual" }
  )
  vim.keymap.set("n", fzf_lua_prefix .. [[P]], [[<Cmd>FzfLua tags_grep_cword<CR>]], { desc = "FzfLua tags_grep_cword" })
  vim.keymap.set("n", fzf_lua_prefix .. [[q]], [[<Cmd>FzfLua quickfix<CR>]], { desc = "FzfLua quickfix" })
  vim.keymap.set("n", fzf_lua_prefix .. [[Q]], [[<Cmd>FzfLua grep_quickfix<CR>]], { desc = "FzfLua grep_quickfix" })
  vim.keymap.set("n", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep<CR>]], { desc = "FzfLua grep" })
  vim.keymap.set("x", fzf_lua_prefix .. [[r]], [[<Cmd>FzfLua grep_visual<CR>]], { desc = "FzfLua grep_visual" })
  vim.keymap.set("n", fzf_lua_prefix .. [[R]], function()
    fzf_lua.grep(my_fzf_lua.wrap_opts({ rg_opts = my_fzf_lua.config.grep.rg_max_columns .. " --no-ignore --hidden" }))
  end, { desc = "FzfLua grep all" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<C-R>]], [[<Cmd>FzfLua grep_project<CR>]], { desc = "FzfLua grep_project" })
  vim.keymap.set("n", fzf_lua_prefix .. [[s]], [[<Cmd>FzfLua git_status<CR>]], { desc = "FzfLua git_status" })
  vim.keymap.set("n", fzf_lua_prefix .. [[S]], [[<Cmd>FzfLua spell_suggest<CR>]], { desc = "FzfLua spell_suggest" })
  vim.keymap.set("n", fzf_lua_prefix .. [[t]], [[<Cmd>FzfLua btags<CR>]], { desc = "FzfLua btags" })
  vim.keymap.set("n", fzf_lua_prefix .. [[T]], [[<Cmd>FzfLua tags<CR>]], { desc = "FzfLua tags" })
  vim.keymap.set("n", fzf_lua_prefix .. [[u]], [[<Cmd>FzfLua resume<CR>]], { desc = "FzfLua resume" })
  vim.keymap.set(
    "n",
    fzf_lua_prefix .. [[U]],
    [[<Cmd>FzfLua live_grep_resume<CR>]],
    { desc = "FzfLua live_grep_resume" }
  )
  vim.keymap.set("n", fzf_lua_prefix .. [[v]], [[<Cmd>FzfLua colorschemes<CR>]], { desc = "FzfLua colorschemes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[w]], [[<Cmd>FzfLua tabs<CR>]], { desc = "FzfLua tabs" })
  vim.keymap.set("n", fzf_lua_prefix .. [[x]], [[<Cmd>FzfLua changes<CR>]], { desc = "FzfLua changes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[X]], [[<Cmd>FzfLua spell_suggest<CR>]], { desc = "FzfLua spell_suggest" })
  vim.keymap.set("n", fzf_lua_prefix .. [[y]], [[<Cmd>FzfLua filetypes<CR>]], { desc = "FzfLua filetypes" })
  vim.keymap.set("n", fzf_lua_prefix .. [[Y]], [[<Cmd>FzfLua highlights<CR>]], { desc = "FzfLua highlights" })
  vim.keymap.set("n", fzf_lua_prefix .. [[z]], [[<Cmd>FzfLua zoxide<CR>]], { desc = "FzfLua zoxide" })
  vim.keymap.set("n", fzf_lua_prefix .. [[,]], [[<Cmd>FzfLua builtin<CR>]], { desc = "FzfLua builtin" })
  vim.keymap.set("n", fzf_lua_prefix .. [[`]], [[<Cmd>FzfLua marks<CR>]], { desc = "FzfLua marks" })
  vim.keymap.set("n", fzf_lua_prefix .. [[']], [[<Cmd>FzfLua registers<CR>]], { desc = "FzfLua registers" })
  vim.keymap.set("n", fzf_lua_prefix .. [["]], function()
    fzf_lua.grep({ search = vim.fn.expand("<cword>"), search_paths = { vim.fn.expand("%") } })
  end, { desc = "FzfLua grep cursor word in current file" })
  vim.keymap.set("x", fzf_lua_prefix .. [["]], function()
    fzf_lua.grep({ search = utils.get_visual_selection(), search_paths = { vim.fn.expand("%") } })
  end, { desc = "FzfLua grep visual selection in current file" })
  vim.keymap.set("n", fzf_lua_prefix .. [[;]], [[<Cmd>FzfLua commands<CR>]], { desc = "FzfLua commands" })
  vim.keymap.set("n", fzf_lua_prefix .. [[:]], [[<Cmd>FzfLua command_history<CR>]], { desc = "FzfLua command_history" })
  vim.keymap.set("n", fzf_lua_prefix .. [[/]], [[<Cmd>FzfLua search_history<CR>]], { desc = "FzfLua search_history" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<Tab>]], [[<Cmd>FzfLua keymaps<CR>]], { desc = "FzfLua keymaps" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<F1>]], [[<Cmd>FzfLua man_pages<CR>]], { desc = "FzfLua man_pages" })
  vim.keymap.set("n", fzf_lua_prefix .. [[<F9>]], [[<Cmd>FzfLua undotree<CR>]], { desc = "FzfLua undotree" })

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
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "D",
    "<Cmd>FzfLua lsp_declarations<CR>",
    { desc = "FzfLua lsp_declarations" }
  )
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "t", "<Cmd>FzfLua lsp_typedefs<CR>", { desc = "FzfLua lsp_typedefs" })
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "i",
    "<Cmd>FzfLua lsp_implementations<CR>",
    { desc = "FzfLua lsp_implementations" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "a",
    "<Cmd>FzfLua lsp_code_actions<CR>",
    { desc = "FzfLua lsp_code_actions" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "o",
    "<Cmd>FzfLua lsp_document_symbols<CR>",
    { desc = "FzfLua lsp_document_symbols" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "S",
    "<Cmd>FzfLua lsp_workspace_symbols<CR>",
    { desc = "FzfLua lsp_workspace_symbols" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "s",
    "<Cmd>FzfLua lsp_live_workspace_symbols<CR>",
    { desc = "FzfLua lsp_live_workspace_symbols" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "c",
    "<Cmd>FzfLua lsp_document_diagnostics<CR>",
    { desc = "FzfLua lsp_document_diagnostics" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. "C",
    "<Cmd>FzfLua lsp_workspace_diagnostics<CR>",
    { desc = "FzfLua lsp_workspace_diagnostics" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. ",",
    "<Cmd>FzfLua lsp_incoming_calls<CR>",
    { desc = "FzfLua lsp_incoming_calls" }
  )
  vim.keymap.set(
    "n",
    fzf_lua_lsp_prefix .. ".",
    "<Cmd>FzfLua lsp_outgoing_calls<CR>",
    { desc = "FzfLua lsp_outgoing_calls" }
  )
  vim.keymap.set("n", fzf_lua_lsp_prefix .. "g", "<Cmd>FzfLua lsp_finder<CR>", { desc = "FzfLua lsp_finder" })

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
  vim.keymap.set("i", [[<C-Z><C-D>]], function()
    require("fzf-lua").complete_path()
  end, { desc = "FzfLua complete_path" })
  vim.keymap.set("i", [[<C-Z><C-F>]], function()
    require("fzf-lua").complete_file()
  end, { desc = "FzfLua complete_file" })
  vim.keymap.set("i", [[<C-Z><C-L>]], function()
    require("fzf-lua").complete_bline()
  end, { desc = "FzfLua complete_bline" })
  vim.keymap.set("i", [[<C-Z><M-l>]], function()
    require("fzf-lua").complete_line()
  end, { desc = "FzfLua complete_line" })

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
