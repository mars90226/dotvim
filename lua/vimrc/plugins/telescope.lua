local plugin_utils = require("vimrc.plugin_utils")

local state = require("telescope.state")

local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")

local trouble = require("trouble.providers.telescope")

local yanky_mapping = require("yanky.telescope.mapping")

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
  action_state.get_current_history():append(
    action_state.get_current_line(),
    action_state.get_current_picker(prompt_bufnr)
  )
  return action_set.edit(prompt_bufnr, "rightbelow new")
end

local select_rightbelow_vertical = function(prompt_bufnr)
  action_state.get_current_history():append(
    action_state.get_current_line(),
    action_state.get_current_picker(prompt_bufnr)
  )
  return action_set.edit(prompt_bufnr, "rightbelow vnew")
end

local switch_or_select = function(prompt_bufnr)
  action_state.get_current_history():append(
    action_state.get_current_line(),
    action_state.get_current_picker(prompt_bufnr)
  )
  return action_set.edit(prompt_bufnr, "Switch")
end

local switch_or_select_tab = function(prompt_bufnr)
  action_state.get_current_history():append(
    action_state.get_current_line(),
    action_state.get_current_picker(prompt_bufnr)
  )
  return action_set.edit(prompt_bufnr, "TabSwitch")
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

        -- Use <M-j>/<M-k> to move next/previous page
        ["<M-j>"] = move_selection_next_page,
        ["<M-k>"] = move_selection_previous_page,

        -- Use <C-S> to select horizontal
        ["<C-S>"] = actions.select_horizontal,

        -- Use <M-g>/<M-v> to select rightbelow horizontal/vertical
        ["<M-g>"] = select_rightbelow_horizontal,
        ["<M-v>"] = select_rightbelow_vertical,

        -- Use <M-t> to open in trouble
        ["<M-t>"] = trouble.open_with_trouble,

        -- Use <C-W> to delete word
        -- NOTE: Workaround for <C-W> mapped to window command in prompt buffer
        -- Ref: https://github.com/nvim-telescope/telescope.nvim/issues/1579
        ["<C-W>"] = function()
          vim.cmd([[normal! bcw]])
        end,

        -- Use <C-a> to go to home
        -- NOTE: <C-b> is used for eraseSubword
        ["<C-a>"] = function()
          vim.cmd([[normal! gI]])
        end,

        -- Use <C-e> to go to end
        ["<C-e>"] = function()
          vim.cmd([[normal! $a]])
        end,

        -- Use <M-o>/<M-l> to switch or select open/tab
        ["<M-o>"] = switch_or_select,
        ["<M-l>"] = switch_or_select_tab,
      },
      n = {
        -- Use <C-S> to select horizontal
        ["<C-S>"] = actions.select_horizontal,

        -- Use <M-g>/<M-v> to select rightbelow horizontal/vertical
        ["<M-g>"] = select_rightbelow_horizontal,
        ["<M-v>"] = select_rightbelow_vertical,

        -- Use <M-t> to open in trouble
        ["<M-t>"] = trouble.open_with_trouble,
      },
    },
  },
})

-- Extensions
------------------------------

require("telescope").load_extension("file_browser")
if plugin_utils.is_enabled_plugin("telescope-fzf-native.nvim") then
  require("telescope").load_extension("fzf")
end
require("telescope").load_extension("project")
require("telescope").load_extension("zoxide")
require("telescope").load_extension("media_files")
require("telescope").load_extension("tele_tabby")
-- require('telescope').load_extension('neoclip')

require("telescope").load_extension("aerial")
require("telescope").load_extension("harpoon")
require("telescope").load_extension("urlview")
