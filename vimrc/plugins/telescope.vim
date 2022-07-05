" TODO: Move extension mapping?
" Mappings
nnoremap <Space>ta <Cmd>Telescope loclist<CR>
nnoremap <Space>tb <Cmd>Telescope buffers<CR>
nnoremap <Space>tc <Cmd>Telescope git_bcommits<CR>
nnoremap <Space>tC <Cmd>Telescope git_commits<CR>
nnoremap <Space>te <Cmd>execute 'Telescope grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>
nnoremap <Space>tf <Cmd>Telescope find_files<CR>
nnoremap <Space>tF <Cmd>Telescope find_files hidden=true no_ignore=true<CR>
nnoremap <Space>tg <Cmd>Telescope git_files<CR>
nnoremap <Space>th <Cmd>Telescope help_tags<CR>
nnoremap <Space>ti <Cmd>Telescope live_grep<CR>
nnoremap <Space>tj <Cmd>Telescope jumplist<CR>
nnoremap <Space>tk <Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cword>')<CR>
nnoremap <Space>tK <Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cWORD>')<CR>
nnoremap <Space>t8 <Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>
nnoremap <Space>t* <Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>
" NOTE: <Cmd> does not leave visual mode and therefore cannot use '<, '>,
" which are required by vimrc#utility#get_visual_selection().
" There seems no good way to get visual selection in visual mode except yanked
" to register and restore it.
xnoremap <Space>tk :<C-U>execute 'Telescope grep_string use_regex=true search='.vimrc#utility#get_visual_selection()<CR>
xnoremap <Space>t8 :<C-U>execute 'Telescope grep_string use_regex=true search=\b'.vimrc#utility#get_visual_selection().'\b'<CR>
nnoremap <Space>tl <Cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <Space>tm <Cmd>Telescope oldfiles<CR>
nnoremap <Space>to <Cmd>Telescope vim_options<CR>
nnoremap <Space>tp <Cmd>call vimrc#telescope#project_tags()<CR>
nnoremap <Space>tP <Cmd>Telescope projects<CR>
nnoremap <Space>t<C-P> <Cmd>Telescope project<CR>
nnoremap <Space>t0 <Cmd>Telescope file_browser<CR>
nnoremap <Space>tq <Cmd>Telescope quickfix<CR>
nnoremap <Space>tr <Cmd>execute 'Telescope grep_string use_regex=true search='.input('Rg: ')<CR>
nnoremap <Space>ts <Cmd>Telescope git_status<CR>
nnoremap <Space>tS <Cmd>Telescope treesitter<CR>
nnoremap <Space>tt <Cmd>Telescope current_buffer_tags<CR>
nnoremap <Space>tT <Cmd>Telescope tags<CR>
nnoremap <Space>tu <Cmd>Telescope resume<CR>
nnoremap <Space>tv <Cmd>Telescope colorscheme<CR>
nnoremap <Space>tw <Cmd>Telescope tele_tabby list<CR>
" nnoremap <Space>tx <Cmd>Telescope neoclip<CR>
nnoremap <Space>ty <Cmd>Telescope filetypes<CR>
nnoremap <Space>tY <Cmd>Telescope highlights<CR>
nnoremap <Space>t, <Cmd>Telescope builtin<CR>
nnoremap <Space>t` <Cmd>Telescope marks<CR>
nnoremap <Space>t' <Cmd>Telescope registers<CR>
nnoremap <Space>t; <Cmd>Telescope commands<CR>
nnoremap <Space>t: <Cmd>Telescope command_history<CR>
nnoremap <Space>t/ <Cmd>Telescope search_history<CR>
nnoremap <Space>t<Tab> <Cmd>Telescope keymaps<CR>
nnoremap <Space>t<F1> <Cmd>Telescope man_pages sections=["ALL"]<CR>
nnoremap <Space>t<F5> <Cmd>Telescope reloader<CR>

" Lsp
nnoremap <Space>lr <Cmd>Telescope lsp_references<CR>
nnoremap <Space>ld <Cmd>Telescope lsp_definitions<CR>
nnoremap <Space>lt <Cmd>Telescope lsp_type_definitions<CR>
nnoremap <Space>li <Cmd>Telescope lsp_implementations<CR>
nnoremap <Space>lx <Cmd>Telescope lsp_code_actions<CR>
xnoremap <Space>lx <Cmd>Telescope lsp_range_code_actions<CR>
nnoremap <Space>lo <Cmd>Telescope lsp_document_symbols<CR>
nnoremap <Space>ls <Cmd>Telescope lsp_workspace_symbols<CR>
nnoremap <Space>lS <Cmd>Telescope lsp_dynamic_workspace_symbols<CR>

" Diagnostic
nnoremap <Space>lc <Cmd>Telescope diagnostics bufnr=0<CR>
nnoremap <Space>lC <Cmd>Telescope diagnostics<CR>

" Aerial
nnoremap <Space>tA <Cmd>Telescope aerial<CR>

" Cheatsheet Mappings
nnoremap <Leader><Tab> <Cmd>Cheatsheet<CR>

" Harpoon
nnoremap <Space>tM <Cmd>Telescope harpoon marks<CR>

" Zoxide
nnoremap <Space>tz <Cmd>Telescope zoxide list<CR>

" Urlview
nnoremap <Space>tU <Cmd>Telescope urlview<CR>

" Yanky
nnoremap <Space>tn <Cmd>Telescope yank_history<CR>
