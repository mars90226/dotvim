local state = require "telescope.state"

local actions = require('telescope.actions')
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"

-- Actions
------------------------------
local exit_insert_mode = function(prompt_bufnr)
  vim.cmd [[stopinsert]]
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

-- Global remapping
------------------------------
require('telescope').setup{
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

        -- Use <M-j>/<M-k> to move next/previous page
        ["<M-j>"] = move_selection_next_page,
        ["<M-k>"] = move_selection_previous_page,

        -- Use <C-S> to select horizontal
        ["<C-S>"] = actions.select_horizontal,
      },
      n = {
        -- Use <C-S> to select horizontal
        ["<C-S>"] = actions.select_horizontal,
      }
    },
  }
}

-- Extensions
------------------------------

if vim.fn['vimrc#plugin#is_enabled_plugin']('telescope-fzf-native.nvim') == 1 then
  require('telescope').load_extension('fzf')
end
require('telescope').load_extension('project')
require('telescope').load_extension('zoxide')
require('telescope').load_extension('media_files')
require('telescope').load_extension('tele_tabby')
