local fzf_lua = require("fzf-lua")
local actions = require("fzf-lua.actions")

local my_fzf_lua = {}

my_fzf_lua.global_actions = {
  -- TODO: Escape unwanted filename
  ["alt-g"] = function(selected, opts)
    actions.vimcmd_file("rightbelow split", selected, opts)
  end,
  ["alt-v"] = function(selected, opts)
    actions.vimcmd_file("rightbelow vsplit", selected, opts)
  end,
}

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
  -- TODO: Add lsp

  fzf_lua.setup(opts)

  -- TODO: Setup code action preview
  -- Ref: https://github.com/ibhagwan/fzf-lua/issues/944#issuecomment-1849104750
end

my_fzf_lua.setup_mapping = function()
  nnoremap([[<Space>za]], [[<Cmd>FzfLua loclist<CR>]])
  nnoremap([[<Space>zA]], [[<Cmd>FzfLua args<CR>]])
  nnoremap([[<Space>zb]], [[<Cmd>FzfLua buffers<CR>]])
  nnoremap([[<Space>zB]], [[<Cmd>FzfLua git_branches<CR>]])
  nnoremap([[<Space>zc]], [[<Cmd>FzfLua git_bcommits<CR>]])
  nnoremap([[<Space>zC]], [[<Cmd>FzfLua git_commits<CR>]])
  nnoremap([[<Space>zf]], [[<Cmd>FzfLua files<CR>]])
  nnoremap([[<Space>zg]], [[<Cmd>FzfLua git_files<CR>]])
  nnoremap([[<Space>zG]], [[<Cmd>FzfLua live_grep_glob<CR>]])
  nnoremap([[<Space>zh]], [[<Cmd>FzfLua help_tags<CR>]])
  nnoremap([[<Space>zH]], [[<Cmd>FzfLua git_stash<CR>]])
  nnoremap([[<Space>zi]], [[<Cmd>FzfLua live_grep_native<CR>]])
  nnoremap([[<Space>zI]], [[<Cmd>FzfLua live_grep_resume<CR>]])
  nnoremap([[<Space>zj]], [[<Cmd>FzfLua jumps<CR>]])
  nnoremap([[<Space>zk]], [[<Cmd>FzfLua grep_cword<CR>]])
  xnoremap([[<Space>zk]], [[<Cmd>FzfLua grep_visual<CR>]]) -- For muscle memory of grepping visual selection using fzf.vim
  nnoremap([[<Space>zK]], [[<Cmd>FzfLua grep_cWORD<CR>]])
  nnoremap([[<Space>zl]], [[<Cmd>FzfLua blines<CR>]])
  nnoremap([[<Space>zL]], [[<Cmd>FzfLua lines<CR>]])
  nnoremap([[<Space>zm]], [[<Cmd>FzfLua oldfiles<CR>]])
  nnoremap([[<Space>zp]], [[<Cmd>FzfLua tags_grep<CR>]])
  xnoremap([[<Space>zp]], [[<Cmd>FzfLua tags_grep_visual<CR>]])
  nnoremap([[<Space>zP]], [[<Cmd>FzfLua tags_grep_cword<CR>]])
  nnoremap([[<Space>zq]], [[<Cmd>FzfLua quickfix<CR>]])
  nnoremap([[<Space>zQ]], [[<Cmd>FzfLua quickfix_stack<CR>]])
  nnoremap([[<Space>zr]], [[<Cmd>FzfLua grep<CR>]])
  xnoremap([[<Space>zr]], [[<Cmd>FzfLua grep_visual<CR>]])
  nnoremap([[<Space>zR]], [[<Cmd>FzfLua grep_project<CR>]])
  nnoremap([[<Space>zs]], [[<Cmd>FzfLua git_status<CR>]])
  nnoremap([[<Space>zS]], [[<Cmd>FzfLua spell_suggest<CR>]])
  nnoremap([[<Space>zt]], [[<Cmd>FzfLua btags<CR>]])
  nnoremap([[<Space>zT]], [[<Cmd>FzfLua tags<CR>]])
  nnoremap([[<Space>zu]], [[<Cmd>FzfLua resume<CR>]])
  nnoremap([[<Space>zv]], [[<Cmd>FzfLua colorschemes<CR>]])
  nnoremap([[<Space>zw]], [[<Cmd>FzfLua tabs<CR>]])
  nnoremap([[<Space>zx]], [[<Cmd>FzfLua changes<CR>]])
  nnoremap([[<Space>zX]], [[<Cmd>FzfLua spell_suggest<CR>]])
  nnoremap([[<Space>zy]], [[<Cmd>FzfLua filetypes<CR>]])
  nnoremap([[<Space>z,]], [[<Cmd>FzfLua builtin<CR>]])
  nnoremap([[<Space>z`]], [[<Cmd>FzfLua marks<CR>]])
  nnoremap([[<Space>z']], [[<Cmd>FzfLua registers<CR>]])
  nnoremap([[<Space>z;]], [[<Cmd>FzfLua commands<CR>]])
  nnoremap([[<Space>z:]], [[<Cmd>FzfLua command_history<CR>]])
  nnoremap([[<Space>z/]], [[<Cmd>FzfLua search_history<CR>]])
  nnoremap([[<Space>z<Tab>]], [[<Cmd>FzfLua keymaps<CR>]])
  nnoremap([[<Space>z<F1>]], [[<Cmd>FzfLua man_pages<CR>]])

  -- Lsp
  local fzf_lua_lsp_prefix = "<Space>l"
  nnoremap(fzf_lua_lsp_prefix .. "r", "<Cmd>FzfLua lsp_references<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "d", "<Cmd>FzfLua lsp_definitions<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "D", "<Cmd>FzfLua lsp_declarations<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "t", "<Cmd>FzfLua lsp_typedefs<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "i", "<Cmd>FzfLua lsp_implementations<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "x", "<Cmd>FzfLua lsp_code_actions<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "o", "<Cmd>FzfLua lsp_document_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "s", "<Cmd>FzfLua lsp_workspace_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "S", "<Cmd>FzfLua lsp_live_workspace_symbols<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "c", "<Cmd>FzfLua lsp_document_diagnostics<CR>")
  nnoremap(fzf_lua_lsp_prefix .. "C", "<Cmd>FzfLua lsp_workspace_diagnostics<CR>")
  nnoremap(fzf_lua_lsp_prefix .. ",", "<Cmd>FzfLua lsp_incoming_calls<CR>")
  nnoremap(fzf_lua_lsp_prefix .. ".", "<Cmd>FzfLua lsp_outgoing_calls<CR>")

  -- Complete
  inoremap([[<C-Z><C-D>]], [[<Cmd>lua require("fzf-lua").complete_path()<CR>]])
  inoremap([[<C-Z><C-F>]], [[<Cmd>lua require("fzf-lua").complete_file()<CR>]])
  inoremap([[<C-Z><C-L>]], [[<Cmd>lua require("fzf-lua").complete_bline()<CR>]])
  inoremap([[<C-Z><M-l>]], [[<Cmd>lua require("fzf-lua").complete_line()<CR>]])
end

my_fzf_lua.setup = function()
  my_fzf_lua.setup_config()
  my_fzf_lua.setup_mapping()
end

return my_fzf_lua
