local state = require("telescope.state")

local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")

local utils = require("vimrc.utils")

-- Extensions
local command_palette_config = require("vimrc.plugins.command_palette").config
-- TODO: Disabled as telescope-frecency.nvim loading to slow
-- local frecency_config = require("vimrc.plugins.frecency").config

local telescope = {}

-- Utils
------------------------------
local get_single_multi_selection = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_selection = picker:get_multi_selection()

  if not vim.tbl_isempty(multi_selection) then
    return picker:get_multi_selection()
  else
    return {action_state:get_selected_entry()}
  end
end

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

local open_with_trouble = function(...)
  local has_trouble, trouble = pcall(require, "trouble.providers.telescope")

  if has_trouble then
    return trouble.open_with_trouble(...)
  end
end

local yank_selection = function(prompt_bufnr)
  local selection = get_single_multi_selection(prompt_bufnr)

  local entry_displays = vim.tbl_map(function(entry)
    if entry.display then
      return vim.split(entry:display(), '\n')[1]
    else
      return ''
    end
  end, selection)

  local content = vim.fn.join(entry_displays, '\n')
  vim.fn.setreg('"', content)
end

-- Global remapping
------------------------------
telescope.setup_config = function()
  require("telescope").setup({
    defaults = {
      sorting_strategy = "descending",
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

          -- Use <M-/> to toggle preview
          ["<M-/>"] = action_layout.toggle_preview,

          -- Use <M-y> to yank selection
          ["<M-y>"] = yank_selection,
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
    extensions = {
      command_palette = command_palette_config,
      -- TODO: Disabled as telescope-frecency.nvim loading to slow
      -- frecency = frecency_config,
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                         -- the default case_mode is "smart_case"
      },
      ast_grep = {
          command = {
              "sg",
              "--json=stream",
          }, -- must have --json=stream
          grep_open_files = false, -- search in opened files
          lang = nil, -- string value, specify language for ast-grep `nil` for default
      }
    }
  })
end

telescope.setup_mapping = function()
  -- TODO: Add key mapping description
  local telescope_prefix = [[<Space>t]]
  local telescope_lsp_prefix = [[<Space>tl]]

  -- Mappings
  nnoremap(telescope_prefix .. [[a]], [[<Cmd>Telescope loclist<CR>]])
  nnoremap(telescope_prefix .. [[A]], [[<Cmd>Telescope autocommands<CR>]])
  nnoremap(telescope_prefix .. [[b]], [[<Cmd>Telescope buffers<CR>]])
  nnoremap(telescope_prefix .. [[B]], [[<Cmd>Telescope git_branches<CR>]])
  nnoremap(telescope_prefix .. [[c]], [[<Cmd>Telescope git_bcommits<CR>]])
  xnoremap(telescope_prefix .. [[c]], [[<Cmd>Telescope git_bcommits_range<CR>]])
  nnoremap(telescope_prefix .. [[C]], [[<Cmd>Telescope git_commits<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap(telescope_prefix .. [[e]], [[<Cmd>execute 'Telescope grep_string use_regex=true search_dirs='.input('Folder: ').' search='.input('Rg: ')<CR>]])
  -- NOTE: Use telescope-menufacture find_files
  -- nnoremap(telescope_prefix .. [[f]], [[<Cmd>Telescope find_files<CR>]])
  nnoremap(telescope_prefix .. [[F]], [[<Cmd>Telescope find_files hidden=true no_ignore=true<CR>]])
  nnoremap(telescope_prefix .. [[g]], [[<Cmd>Telescope git_files<CR>]])
  nnoremap(telescope_prefix .. [[h]], [[<Cmd>Telescope help_tags<CR>]])
  nnoremap(telescope_prefix .. [[H]], [[<Cmd>Telescope git_stash<CR>]])
  -- NOTE: Use telescope-menufacture live_grep
  -- nnoremap(telescope_prefix .. [[i]], [[<Cmd>Telescope live_grep<CR>]])
  nnoremap(telescope_prefix .. [[j]], [[<Cmd>Telescope jumplist<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap(telescope_prefix .. [[k]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cword>')<CR>]])
  -- nnoremap(telescope_prefix .. [[K]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.expand('<cWORD>')<CR>]])
  -- nnoremap(telescope_prefix .. [[8]], [[<Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cword>').'\b'<CR>]])
  -- nnoremap(telescope_prefix .. [[*]], [[<Cmd>execute 'Telescope grep_string use_regex=true search=\b'.expand('<cWORD>').'\b'<CR>]])
  -- NOTE: <Cmd> does not leave visual mode and therefore cannot use '<, '>,
  -- which are required by vimrc#utility#get_visual_selection().
  -- There seems no good way to get visual selection in visual mode except yanked
  -- to register and restore it.
  -- NOTE: Use telescope-menufacture grep_string
  -- xnoremap(telescope_prefix .. [[k]], [[:<C-U>execute]] 'Telescope grep_string use_regex=true search='.vimrc#utility#get_visual_selection()<CR>)
  -- xnoremap(telescope_prefix .. [[8]], [[:<C-U>execute]] 'Telescope grep_string use_regex=true search=\b'.vimrc#utility#get_visual_selection().'\b'<CR>)
  nnoremap(telescope_prefix .. [[l]], [[<Cmd>Telescope current_buffer_fuzzy_find<CR>]])
  -- TODO: Disabled as telescope-frecency.nvim loading to slow
  -- nnoremap(telescope_prefix .. [[m]], [[<Cmd>Telescope frecency<CR>]])
  nnoremap(telescope_prefix .. [[<CR>]], [[<Cmd>Telescope frecency workspace=CWD<CR>]])
  nnoremap(telescope_prefix .. [[o]], [[<Cmd>Telescope oldfiles<CR>]])
  nnoremap(telescope_prefix .. [[O]], [[<Cmd>Telescope vim_options<CR>]])
  nnoremap(telescope_prefix .. [[p]], [[<Cmd>call vimrc#telescope#project_tags()<CR>]])
  nnoremap(telescope_prefix .. [[P]], [[<Cmd>Telescope projects<CR>]])
  nnoremap(telescope_prefix .. [[q]], [[<Cmd>Telescope quickfix<CR>]])
  nnoremap(telescope_prefix .. [[Q]], [[<Cmd>Telescope quickfixhistory<CR>]])
  -- NOTE: Use telescope-menufacture grep_string
  -- nnoremap(telescope_prefix .. [[r]], [[<Cmd>execute 'Telescope grep_string use_regex=true search='.input('Rg: ')<CR>]])
  nnoremap(telescope_prefix .. [[s]], [[<Cmd>Telescope git_status<CR>]])
  nnoremap(telescope_prefix .. [[S]], [[<Cmd>Telescope treesitter<CR>]])
  nnoremap(telescope_prefix .. [[t]], [[<Cmd>Telescope current_buffer_tags<CR>]])
  nnoremap(telescope_prefix .. [[T]], [[<Cmd>Telescope tags<CR>]])
  nnoremap(telescope_prefix .. [[<C-T>]], [[<Cmd>Telescope tagstack<CR>]])
  nnoremap(telescope_prefix .. [[u]], [[<Cmd>Telescope resume<CR>]])
  nnoremap(telescope_prefix .. [[v]], [[<Cmd>Telescope colorscheme<CR>]])
  nnoremap(telescope_prefix .. [[x]], [[<Cmd>Telescope spell_suggest<CR>]])
  -- nnoremap(telescope_prefix .. [[x]], [[<Cmd>Telescope neoclip<CR>]])
  nnoremap(telescope_prefix .. [[y]], [[<Cmd>Telescope filetypes<CR>]])
  nnoremap(telescope_prefix .. [[Y]], [[<Cmd>Telescope highlights<CR>]])
  nnoremap(telescope_prefix .. [[,]], [[<Cmd>Telescope builtin<CR>]])
  nnoremap(telescope_prefix .. [[`]], [[<Cmd>Telescope marks<CR>]])
  nnoremap(telescope_prefix .. [[']], [[<Cmd>Telescope registers<CR>]])
  nnoremap(telescope_prefix .. [[;]], [[<Cmd>Telescope commands<CR>]])
  nnoremap(telescope_prefix .. [[:]], [[<Cmd>Telescope command_history<CR>]])
  nnoremap(telescope_prefix .. [[/]], [[<Cmd>Telescope search_history<CR>]])
  nnoremap(telescope_prefix .. [[<Tab>]], [[<Cmd>Telescope keymaps<CR>]])
  nnoremap(telescope_prefix .. [[<F1>]], [[<Cmd>Telescope man_pages sections=["ALL"]<CR>]])
  nnoremap(telescope_prefix .. [[<F2>]], [[<Cmd>Telescope symbols<CR>]])
  nnoremap(telescope_prefix .. [[<F5>]], [[<Cmd>Telescope reloader<CR>]])

  -- Lsp
  nnoremap(telescope_lsp_prefix .. "r", "<Cmd>Telescope lsp_references<CR>")
  nnoremap(telescope_lsp_prefix .. "d", "<Cmd>Telescope lsp_definitions<CR>")
  nnoremap(telescope_lsp_prefix .. "t", "<Cmd>Telescope lsp_type_definitions<CR>")
  nnoremap(telescope_lsp_prefix .. "i", "<Cmd>Telescope lsp_implementations<CR>")
  nnoremap(telescope_lsp_prefix .. "x", "<Cmd>Telescope lsp_code_actions<CR>")
  xnoremap(telescope_lsp_prefix .. "x", "<Cmd>Telescope lsp_range_code_actions<CR>")
  nnoremap(telescope_lsp_prefix .. "o", "<Cmd>Telescope lsp_document_symbols<CR>")
  nnoremap(telescope_lsp_prefix .. "s", "<Cmd>Telescope lsp_workspace_symbols<CR>")
  nnoremap(telescope_lsp_prefix .. "S", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>")
  nnoremap(telescope_lsp_prefix .. ",", "<Cmd>Telescope lsp_incoming_calls<CR>")
  nnoremap(telescope_lsp_prefix .. ".", "<Cmd>Telescope lsp_outgoing_calls<CR>")
end

telescope.setup = function()
  telescope.setup_config()
  telescope.setup_mapping()
end

return telescope
