local plugin_utils = require("vimrc.plugin_utils")

local state = require("telescope.state")

local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")

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
