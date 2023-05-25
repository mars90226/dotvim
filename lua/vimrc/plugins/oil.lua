local origin_oil = require("oil")
local origin_oil_actions = require("oil.actions")

local oil = {}

oil.setup_config = function()
  origin_oil.setup({
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
      buflisted = false,
      bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "n",
    },
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`
    default_file_explorer = true,
    -- Restore window options to previous values when leaving an oil buffer
    restore_win_options = true,
    -- Skip the confirmation popup for simple operations
    skip_confirm_for_simple_edits = false,
    -- Deleted files will be removed with the `trash-put` command.
    delete_to_trash = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    prompt_save_on_select_new_entry = true,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-S>"] = "actions.select_vsplit",
      ["<C-H>"] = "actions.select_split",
      ["<C-T>"] = "actions.select_tab",
      ["<C-P>"] = "actions.preview",
      ["<C-C>"] = "actions.close",
      ["<C-L>"] = {
        callback = function()
          vim.cmd("nohlsearch")
          origin_oil_actions.refresh.callback()
        end,
        desc = "clear highlight search & refresh current directory list",
      },
      ["-"] = "actions.parent",
      ["_"] = {
        callback = function()
          local folder = origin_oil.get_current_dir()
          vim.cmd("vertical split")
          origin_oil.open(folder)
        end,
        desc = "Open oil.nvim current folder in vertical split"
      },
      ["<Space>-"] = {
        callback = function()
          local folder = origin_oil.get_current_dir()
          vim.cmd("split")
          origin_oil.open(folder)
        end,
        desc = "Open oil.nvim current folder in horizontal split"
      },
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["cb"] = "actions.open_cwd",
      ["g."] = "actions.toggle_hidden",
      ["gx"] = "actions.open_cmdline",
      ["gX"] = "actions.open_cmdline_dir",
      ["y<C-G>"] = "actions.copy_entry_path",

      -- fzf.nvim support
      ["\\f"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          vim.cmd.Files(dir)
        end,
        desc = "FZF Files in current folder",
      },
      ["\\r"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          vim.cmd.RgWithOption(dir .. '::' .. vim.fn.input('Rg: '))
        end,
        desc = "FZF Rg in current folder",
      },

      -- Simulate Defx.nvim
      ["h"] = "actions.parent",
      ["l"] = "actions.select",

      -- Defx.nvim support
      ["\\d"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          vim.cmd.Defx(dir)
        end,
        desc = "Open current folder in Defx.nvim",
      },
      ["\\D"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          vim.cmd.Defx(dir .. ' -split=vertical')
        end,
        desc = "Open current folder in Defx.nvim",
      },

      -- Paste
      ["\\p"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          if not dir then
            return
          end

          -- NOTE: Use defx.vim function
          vim.fn["vimrc#defx#_paste_from_system_clipboard"](dir)
        end,
        desc = "Paste from system clipboard"
      },
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = false,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        return vim.startswith(name, ".")
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return false
      end,
    },
    -- Configuration for the floating window in oil.open_float
    float = {
      -- Padding around the floating window
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 10,
      },
    },
    -- Configuration for the actions floating preview window
    preview = {
      -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_width and max_width can be a single value or a list of mixed integer/float types.
      -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
      max_width = 0.9,
      -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
      min_width = { 40, 0.4 },
      -- optionally define an integer/float for the exact width of the preview window
      width = nil,
      -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- min_height and max_height can be a single value or a list of mixed integer/float types.
      -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
      max_height = 0.9,
      -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
      min_height = { 5, 0.1 },
      -- optionally define an integer/float for the exact height of the preview window
      height = nil,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
    -- Configuration for the floating progress window
    progress = {
      max_width = 0.9,
      min_width = { 40, 0.4 },
      width = nil,
      max_height = { 10, 0.9 },
      min_height = { 5, 0.1 },
      height = nil,
      border = "rounded",
      minimized_border = "none",
      win_options = {
        winblend = 0,
      },
    },
  })
end

oil.setup_filetype_mapping = function()
  vim.keymap.set("c", "<C-X>d", function()
    return origin_oil.get_current_dir()
  end, { desc = "Insert oil current folder", expr = true })
  vim.keymap.set("c", "<C-X>f", function()
    local entry = origin_oil.get_cursor_entry()
    if not entry then
      return ''
    end

    return origin_oil.get_current_dir() .. entry.name
  end, { desc = "Insert oil cursor entry full path", expr = true })
end

oil.setup_mapping = function()
  vim.keymap.set("n", "<Space>o", origin_oil.open, { desc = "Open parent directory" })
  vim.keymap.set("n", "<Space>O", function(...)
    vim.cmd("vertical split")
    origin_oil.open(...)
  end, { desc = "Open parent directory in vertical split" })
  vim.keymap.set("n", "<Space><C-O>", function(...)
    vim.cmd("split")
    origin_oil.open(...)
  end, { desc = "Open parent directory in horizontal split" })
end

oil.setup = function()
  oil.setup_config()
  oil.setup_mapping()
end

return oil
