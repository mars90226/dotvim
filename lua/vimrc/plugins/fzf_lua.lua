local fzf_lua = require("fzf-lua")

local my_fzf_lua = {}

my_fzf_lua.setup_config = function()
  fzf_lua.setup({
    winopts = {
      width = 0.9,
      height = 0.9,
    }
  })

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
  nnoremap([[<Space>zlr]], [[<Cmd>FzfLua lsp_references<CR>]])
  nnoremap([[<Space>zld]], [[<Cmd>FzfLua lsp_definitions<CR>]])
  nnoremap([[<Space>zlD]], [[<Cmd>FzfLua lsp_declarations<CR>]])
  nnoremap([[<Space>zlt]], [[<Cmd>FzfLua lsp_typedefs<CR>]])
  nnoremap([[<Space>zli]], [[<Cmd>FzfLua lsp_implementations<CR>]])
  nnoremap([[<Space>zlx]], [[<Cmd>FzfLua lsp_code_actions<CR>]])
  nnoremap([[<Space>zlo]], [[<Cmd>FzfLua lsp_document_symbols<CR>]])
  nnoremap([[<Space>zls]], [[<Cmd>FzfLua lsp_workspace_symbols<CR>]])
  nnoremap([[<Space>zlS]], [[<Cmd>FzfLua lsp_live_workspace_symbols<CR>]])
  nnoremap([[<Space>zlc]], [[<Cmd>FzfLua lsp_document_diagnostics<CR>]])
  nnoremap([[<Space>zlC]], [[<Cmd>FzfLua lsp_workspace_diagnostics<CR>]])
  nnoremap([[<Space>zl,]], [[<Cmd>FzfLua lsp_incoming_calls<CR>]])
  nnoremap([[<Space>zl.]], [[<Cmd>FzfLua lsp_outgoing_calls<CR>]])

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
