" Mappings
nnoremap <Space>ta <Cmd>Telescope loclist<CR>
nnoremap <Space>tb <Cmd>Telescope buffers<CR>
nnoremap <Space>tc <Cmd>Telescope git_bcommits<CR>
nnoremap <Space>tC <Cmd>Telescope git_commits<CR>
nnoremap <Space>te <Cmd>execute 'Telescope grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>
nnoremap <Space>tf <Cmd>Telescope find_files<CR>
nnoremap <Space>tF <Cmd>Telescope file_browser<CR>
nnoremap <Space>tg <Cmd>Telescope git_files<CR>
nnoremap <Space>th <Cmd>Telescope help_tags<CR>
nnoremap <Space>ti <Cmd>Telescope live_grep<CR>
nnoremap <Space>tj <Cmd>Telescope jumplist<CR>
nnoremap <Space>tk <Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cword>')<CR>
nnoremap <Space>tK <Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cWORD>')<CR>
nnoremap <Space>t8 <Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>
nnoremap <Space>t* <Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>
nnoremap <Space>tl <Cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <Space>tL <Cmd>Telescope builtin<CR>
nnoremap <Space>tm <Cmd>Telescope oldfiles<CR>
nnoremap <Space>to <Cmd>Telescope vim_options<CR>
nnoremap <Space>tp <Cmd>Telescope file_browser<CR>
nnoremap <Space>tP <Cmd>Telescope project<CR>
nnoremap <Space>tq <Cmd>Telescope quickfix<CR>
nnoremap <Space>tr <Cmd>execute 'Telescope grep_string use_regex=true search='.input('Rg: ')<CR>
nnoremap <Space>ts <Cmd>Telescope git_status<CR>
nnoremap <Space>tS <Cmd>Telescope treesitter<CR>
nnoremap <Space>tt <Cmd>Telescope current_buffer_tags<CR>
nnoremap <Space>tT <Cmd>Telescope tags<CR>
nnoremap <Space>tv <Cmd>Telescope colorscheme<CR>
nnoremap <Space>ty <Cmd>Telescope filetypes<CR>
nnoremap <Space>tY <Cmd>Telescope highlights<CR>
nnoremap <Space>t` <Cmd>Telescope marks<CR>
nnoremap <Space>t' <Cmd>Telescope registers<CR>
nnoremap <Space>t; <Cmd>Telescope commands<CR>
nnoremap <Space>t: <Cmd>Telescope command_history<CR>
nnoremap <Space>t/ <Cmd>Telescope search_history<CR>
nnoremap <Space>t<Tab> <Cmd>Telescope keymaps<CR>
nnoremap <Space>t<F1> <Cmd>Telescope man_pages<CR>
nnoremap <Space>t<F5> <Cmd>Telescope reloader<CR>

" Cheatsheet Mappings
nnoremap <Leader><Tab> :Cheatsheet<CR>
