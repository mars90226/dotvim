local state = require("telescope.state")

local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")

local telescope = {}

-- Actions
------------------------------
local exit_insert_mode = function(prompt_bufnr)
  vim.cmd([[stopinsert]])
end

local move_selection_next_page = function(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local distance = vim.api.nvim_win_get_height(status.results_win)

  action_set.shift_selection(prompt_bufnr, distance)
end

local move_selection_previous_page = function(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local distance = vim.api.nvim_win_get_height(status.results_win)

  action_set.shift_selection(prompt_bufnr, -distance)
end

local select_rightbelow_horizontal = function(prompt_bufnr)
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  return action_set.edit(prompt_bufnr, "rightbelow new")
end

local select_rightbelow_vertical = function(prompt_bufnr)
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  return action_set.edit(prompt_bufnr, "rightbelow vnew")
end

local switch_or_select = function(prompt_bufnr)
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  return action_set.edit(prompt_bufnr, "Switch")
end

local switch_or_select_tab = function(prompt_bufnr)
  action_state
    .get_current_history()
    :append(action_state.get_current_line(), action_state.get_current_picker(prompt_bufnr))
  return action_set.edit(prompt_bufnr, "TabSwitch")
end

-- FIXME: Seems trouble.nvim has some problem with telescope
local open_with_trouble = function(...)
  local has_trouble, trouble = pcall(require, "trouble.providers.telescope")

  if has_trouble then
    return trouble.open_with_trouble(...)
  end
end

-- Global remapping
------------------------------
telescope.setup_config = function()
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          -- Use <Esc> to quit
          ["<Esc>"] = actions.close,

          -- Use <C-F> to exit insert mode
          ["<C-F>"] = exit_insert_mode,

          -- Use <C-J>/<C-K> to move next/previous
          ["<C-J>"] = actions.move_selection_next,
          ["<C-K>"] = actions.move_selection_previous,

          -- Use <M-j>/<M-k> to move previous/next page
          -- NOTE: Since telescope prompt is at bottom, previous_page means page down, next_page means page up
          -- We want <M-j> to page down, <M-l> to page up
          ["<M-j>"] = move_selection_previous_page,
          ["<M-k>"] = move_selection_next_page,

          -- Use <C-S> to select horizontal
          ["<C-S>"] = actions.select_horizontal,

          -- Use <M-g>/<M-v> to select rightbelow horizontal/vertical
          ["<M-g>"] = select_rightbelow_horizontal,
          ["<M-v>"] = select_rightbelow_vertical,

          -- Use <M-t> to open in trouble
          ["<M-t>"] = open_with_trouble,

          -- Use <C-A> to go to home
          -- NOTE: <C-b> is used for eraseSubword
          ["<C-A>"] = { "<C-O>gI", type = "command" },

          -- Use <C-E> to go to end
          ["<C-E>"] = { "<C-O>A", type = "command" },

          -- Use <M-o>/<M-l> to switch or select open/tab
          ["<M-o>"] = switch_or_select,
          ["<M-l>"] = switch_or_select_tab,

          -- Use <M-a>/<M-s> to select/drop all
          ["<M-a>"] = actions.select_all,
          ["<M-s>"] = actions.drop_all,
        },
        n = {
          -- Use <C-S> to select horizontal
          ["<C-S>"] = actions.select_horizontal,

          -- Use <M-g>/<M-v> to select rightbelow horizontal/vertical
          ["<M-g>"] = select_rightbelow_horizontal,
          ["<M-v>"] = select_rightbelow_vertical,

          -- Use <M-t> to open in trouble
          ["<M-t>"] = open_with_trouble,
        },
      },
    },
  })
end

telescope.setup_mapping = function()
  -- TODO: Move extension mapping?
  -- Mappings
  nnoremap([[<Space>ta]], [[<Cmd>Telescope loclist<CR>]])
  nnoremap([[<Space>tb]], [[<Cmd>Telescope buffers<CR>]])
  nnoremap([[<Space>tc]], [[<Cmd>Telescope git_bcommits<CR>]])
  nnoremap([[<Space>tC]], [[<Cmd>Telescope git_commits<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap([[<Space>te]], [[<Cmd>execute 'Telescope grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>]])
  -- NOTE: Use telescope-menufacture find_files
  -- nnoremap([[<Space>tf]], [[<Cmd>Telescope find_files<CR>]])
  nnoremap([[<Space>tF]], [[<Cmd>Telescope find_files hidden=true no_ignore=true<CR>]])
  nnoremap([[<Space>tg]], [[<Cmd>Telescope git_files<CR>]])
  nnoremap([[<Space>th]], [[<Cmd>Telescope help_tags<CR>]])
  -- NOTE: Use telescope-menufacture live_grep
  -- nnoremap([[<Space>ti]], [[<Cmd>Telescope live_grep<CR>]])
  nnoremap([[<Space>tI]], [[<Cmd>Telescope live_grep_args<CR>]])
  nnoremap([[<Space>tj]], [[<Cmd>Telescope jumplist<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap([[<Space>tk]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cword>')<CR>]])
  -- nnoremap([[<Space>tK]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cWORD>')<CR>]])
  -- nnoremap([[<Space>t8]], [[<Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>]])
  -- nnoremap([[<Space>t*]], [[<Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>]])
  -- NOTE: <Cmd> does not leave visual mode and therefore cannot use '<, '>,
  -- which are required by vimrc#utility#get_visual_selection().
  -- There seems no good way to get visual selection in visual mode except yanked
  -- to register and restore it.
  -- NOTE: Use telescope-menufacture grep_string
  -- xnoremap([[<Space>tk]], [[:<C-U>execute]] 'Telescope grep_string use_regex=true search='.vimrc#utility#get_visual_selection()<CR>)
  -- xnoremap([[<Space>t8]], [[:<C-U>execute]] 'Telescope grep_string use_regex=true search=\b'.vimrc#utility#get_visual_selection().'\b'<CR>)
  nnoremap([[<Space>tl]], [[<Cmd>Telescope current_buffer_fuzzy_find<CR>]])
  nnoremap([[<Space>tm]], [[<Cmd>Telescope frecency<CR>]])
  nnoremap([[<Space>to]], [[<Cmd>Telescope oldfiles<CR>]])
  nnoremap([[<Space>tO]], [[<Cmd>Telescope vim_options<CR>]])
  nnoremap([[<Space>tp]], [[<Cmd>call vimrc#telescope#project_tags()<CR>]])
  nnoremap([[<Space>tP]], [[<Cmd>Telescope projects<CR>]])
  -- TODO: May need to adjust key mapping as used for project bookmark
  nnoremap([[<Space>t<C-P>]], [[<Cmd>Telescope project<CR>]])
  nnoremap([[<Space>t0]], [[<Cmd>Telescope file_browser<CR>]])
  nnoremap([[<Space>t)]], [[<Cmd>execute 'Telescope file_browser path='.expand('%:h')<CR>]])
  nnoremap([[<Space>tq]], [[<Cmd>Telescope quickfix<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap([[<Space>tr]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.input('Rg: ')<CR>]])
  nnoremap([[<Space>ts]], [[<Cmd>Telescope git_status<CR>]])
  nnoremap([[<Space>tS]], [[<Cmd>Telescope treesitter<CR>]])
  nnoremap([[<Space>tt]], [[<Cmd>Telescope current_buffer_tags<CR>]])
  nnoremap([[<Space>tT]], [[<Cmd>Telescope tags<CR>]])
  nnoremap([[<Space>tu]], [[<Cmd>Telescope resume<CR>]])
  nnoremap([[<Space>tv]], [[<Cmd>Telescope colorscheme<CR>]])
  nnoremap([[<Space>tw]], [[<Cmd>Telescope tele_tabby list<CR>]])
  -- nnoremap([[<Space>tx]], [[<Cmd>Telescope neoclip<CR>]])
  nnoremap([[<Space>ty]], [[<Cmd>Telescope filetypes<CR>]])
  nnoremap([[<Space>tY]], [[<Cmd>Telescope highlights<CR>]])
  nnoremap([[<Space>t,]], [[<Cmd>Telescope builtin<CR>]])
  nnoremap([[<Space>t`]], [[<Cmd>Telescope marks<CR>]])
  nnoremap([[<Space>t']], [[<Cmd>Telescope registers<CR>]])
  nnoremap([[<Space>t;]], [[<Cmd>Telescope commands<CR>]])
  nnoremap([[<Space>t:]], [[<Cmd>Telescope command_history<CR>]])
  nnoremap([[<Space>t/]], [[<Cmd>Telescope search_history<CR>]])
  nnoremap([[<Space>t<Tab>]], [[<Cmd>Telescope keymaps<CR>]])
  nnoremap([[<Space>t<F1>]], [[<Cmd>Telescope man_pages sections=["ALL"]<CR>]])
  nnoremap([[<Space>t<F5>]], [[<Cmd>Telescope reloader<CR>]])

  -- Lsp
  nnoremap([[<Space>lr]], [[<Cmd>Telescope lsp_references<CR>]])
  nnoremap([[<Space>ld]], [[<Cmd>Telescope lsp_definitions<CR>]])
  nnoremap([[<Space>lt]], [[<Cmd>Telescope lsp_type_definitions<CR>]])
  nnoremap([[<Space>li]], [[<Cmd>Telescope lsp_implementations<CR>]])
  nnoremap([[<Space>lx]], [[<Cmd>Telescope lsp_code_actions<CR>]])
  xnoremap([[<Space>lx]], [[<Cmd>Telescope lsp_range_code_actions<CR>]])
  nnoremap([[<Space>lo]], [[<Cmd>Telescope lsp_document_symbols<CR>]])
  nnoremap([[<Space>ls]], [[<Cmd>Telescope lsp_workspace_symbols<CR>]])
  nnoremap([[<Space>lS]], [[<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>]])

  -- Diagnostic
  nnoremap([[<Space>lc]], [[<Cmd>Telescope diagnostics bufnr=0<CR>]])
  nnoremap([[<Space>lC]], [[<Cmd>Telescope diagnostics<CR>]])

  -- Cheatsheet Mappings
  nnoremap([[<Leader><Tab>]], [[<Cmd>Cheatsheet<CR>]])

  -- Harpoon
  nnoremap([[<Space>tM]], [[<Cmd>Telescope harpoon marks<CR>]])

  -- Zoxide
  nnoremap([[<Space>tz]], [[<Cmd>Telescope zoxide list<CR>]])

  -- Yanky
  nnoremap([[<Space>tn]], [[<Cmd>Telescope yank_history<CR>]])

  -- Command palette
  nnoremap([[<Space>m]], [[<Cmd>Telescope command_palette<CR>]])

  -- Menufacture
  nnoremap([[<Space>tf]], [[<Cmd>Telescope menufacture find_files<CR>]])
  nnoremap([[<Space>ti]], [[<Cmd>Telescope menufacture live_grep<CR>]])
  nnoremap(
    [[<Space>te]],
    [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>]]
  )
  nnoremap(
    [[<Space>tk]],
    [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.expand('<cword>')<CR>]]
  )
  nnoremap(
    [[<Space>tK]],
    [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.expand('<cWORD>')<CR>]]
  )
  nnoremap(
    [[<Space>t8]],
    [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>]]
  )
  nnoremap(
    [[<Space>t*]],
    [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>]]
  )
  nnoremap([[<Space>tr]], [[<Cmd>execute 'Telescope menufacture grep_string use_regex=true search='.input('Rg: ')<CR>]])
  xnoremap(
    [[<Space>tk]],
    [[:<C-U>execute 'Telescope menufacture grep_string use_regex=true search='.vimrc#utility#get_visual_selection()<CR>]]
  )
  xnoremap(
    [[<Space>t8]],
    [[:<C-U>execute 'Telescope menufacture grep_string use_regex=true search=\b'.vimrc#utility#get_visual_selection().'\b'<CR>]]
  )

  -- Undo
  nnoremap([[<Space>tU]], [[<Cmd>Telescope undo<CR>]])
end

telescope.setup = function()
  telescope.setup_config()
  telescope.setup_mapping()
end

return telescope
