local actions = require('telescope.actions')

-- Actions
------------------------------
local exit_insert_mode = function(prompt_bufnr)
  vim.cmd [[stopinsert]]
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
