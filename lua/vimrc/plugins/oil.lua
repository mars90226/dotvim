local origin_oil = require("oil")
local origin_oil_actions = require("oil.actions")

local utils = require("vimrc.utils")

local oil = {}

oil.config = {
  is_simple_columns = true,
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  simple_columns = {
    "icon",
  },
}

oil.fzf_action = nil

oil.build_fzf_action = function()
  local oil_fzf_action = vim.tbl_extend("force", {
    enter = function(selected)
      oil.open(selected, "edit")
    end,
    ["ctrl-t"] = function(selected)
      oil.open(selected, "tab split")
    end,
    ["ctrl-s"] = function(selected)
      oil.open(selected, "split")
    end,
    ["ctrl-x"] = function(selected)
      oil.open(selected, "split")
    end,
    ["alt-g"] = function(selected)
      oil.open(selected, "rightbelow split")
    end,
    ["ctrl-v"] = function(selected)
      oil.open(selected, "vsplit")
    end,
    ["alt-v"] = function(selected)
      oil.open(selected, "rightbelow vsplit")
    end,
    ["alt-x"] = function(selected)
      oil.open_dir(selected, "edit")
    end,
    ["ctrl-alt-x"] = function(selected)
      oil.open_dir(selected, "split")
    end,
    ["alt-z"] = function(selected)
      oil.open_dir(selected, "VimrcFloatNew edit")
    end,
    ["alt-o"] = function(selected)
      require("vimrc.open").switch(selected, function(path)
        oil.open(path, "edit")
      end)
    end,
    ["alt-l"] = function(selected)
      require("vimrc.open").switch(selected, function(path)
        oil.open(path, "tab")
      end)
    end,
  }, vim.g.misc_fzf_action)

  oil.fzf_action = require("vimrc.plugins.fzf").wrap_actions_for_trigger(oil_fzf_action)
end

oil.choose_columns = function()
  return oil.config.is_simple_columns and oil.config.simple_columns or oil.config.columns
end

oil.open = function(target, action)
  local path = type(target) == "table" and target[1] or target
  if vim.fn.isdirectory(path) == 1 then
    if vim.bo.filetype == "oil" and action == "edit" then
      origin_oil.open(vim.fn.fnamemodify(path, ":p"))
    else
      if action ~= "edit" then
        vim.cmd(action)
      end
      origin_oil.open(path)
    end
  else
    vim.cmd(action .. " " .. path)
  end
end

oil.open_dir = function(target, action)
  local path = type(target) == "table" and target[1] or target
  path = vim.fn.fnamemodify(path, ":p:h")
  if vim.bo.filetype == "oil" and action == "edit" then
    origin_oil.open(path)
  else
    if action ~= "edit" then
      vim.cmd(action)
    end
    origin_oil.open(path)
  end
end

oil.use_oil_fzf_action = function(callback)
  if not oil.fzf_action then
    oil.build_fzf_action()
  end
  vim.g.fzf_action = oil.fzf_action

  local augroup_id = vim.api.nvim_create_augroup("use_oil_fzf_action_callback", {})
  vim.api.nvim_create_autocmd({ "TermClose" }, {
    group = augroup_id,
    pattern = "term://*fzf*",
    once = true,
    callback = function()
      vim.g.fzf_action = vim.g.default_fzf_action
      vim.api.nvim_del_augroup_by_id(augroup_id)
    end,
  })

  callback()
end

oil.setup_config = function()
  -- FIXME: Use oil.nvim as default file explorer over Defx.nvim
  origin_oil.setup({
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = true,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = oil.choose_columns(),
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
      concealcursor = "nvic",
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = false,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    -- (:help prompt_save_on_select_new_entry)
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    -- You can set the delay to false to disable cleanup entirely
    -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
    cleanup_delay_ms = 2000,
    lsp_file_methods = {
      -- Time to wait for LSP file operations to complete before skipping
      timeout_ms = 1000,
      -- Set to true to autosave buffers that are updated with LSP willRenameFiles
      -- Set to "unmodified" to only save unmodified buffers
      autosave_changes = false,
    },
    -- Constrain the cursor to the editable parts of the oil buffer
    -- Set to `false` to disable, or "name" to keep it on the file names
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    watch_for_changes = false,
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-S>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-H>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
      ["<C-T>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
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
        desc = "Open oil.nvim current folder in vertical split",
      },
      ["<Space>-"] = {
        callback = function()
          local folder = origin_oil.get_current_dir()
          vim.cmd("split")
          origin_oil.open(folder)
        end,
        desc = "Open oil.nvim current folder in horizontal split",
      },
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      ["cb"] = "actions.open_cwd",
      ["gc"] = function()
        oil.config.is_simple_columns = not oil.config.is_simple_columns
        origin_oil.set_columns(oil.config.is_simple_columns and oil.config.simple_columns or oil.config.columns)
      end,
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
      ["<Leader>;"] = "actions.open_cmdline",
      ["<Leader>:"] = {
        "actions.open_cmdline",
        opts = {
          shorten_path = true,
          modify = ":h",
        },
        desc = "Open the command line with the current directory as an argument",
      },
      -- <C-_> and <C-/> are the same key
      ["<C-_>"] = "actions.open_terminal",
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
          vim.cmd.RgWithOption(dir .. "::" .. vim.fn.input("Rg: "))
        end,
        desc = "FZF Rg in current folder",
      },

      -- fzf-lua support
      ["\\F"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          require("fzf-lua").files({ cwd = dir })
        end,
        desc = "FzfLua files in current folder",
      },
      ["\\R"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          require("fzf-lua").grep({ cwd = dir })
        end,
        desc = "FzfLua grep in current folder",
      },

      -- Simulate Defx.nvim
      ["h"] = "actions.parent",
      ["l"] = "actions.select",

      -- Defx.nvim support
      ["\\d"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          require("vimrc.plugins.defx").load_defx()
          vim.cmd.Defx(dir)
        end,
        desc = "Open current folder in Defx.nvim",
      },
      ["\\D"] = {
        callback = function()
          local dir = origin_oil.get_current_dir()
          require("vimrc.plugins.defx").load_defx()
          vim.cmd.Defx(dir .. " -split=vertical")
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
        desc = "Paste from system clipboard",
      },

      -- Bookmarks
      ["gd"] = {
        callback = function()
          -- TODO: Change to dynamic bookmarks
          local bookmarks = {
            ["home"] = vim.env.HOME,
            ["vim config"] = utils.get_vim_home(),
            ["vim runtime"] = vim.env.VIMRUNTIME,
            ["vim data"] = function()
              return vim.fn.stdpath("data")
            end,
            ["vim cache"] = function()
              return vim.fn.stdpath("cache")
            end,
            ["vim state"] = function()
              return vim.fn.stdpath("state")
            end,
            ["git root"] = function()
              return vim.fn["vimrc#git#root"]()
            end,
            ["working directory"] = function()
              return vim.fn.getcwd()
            end,
            ["lazy.nvim plugins"] = function()
              return vim.fn.stdpath("data") .. "/lazy"
            end,
          }

          -- TODO: Use fzf-lua to do other actions
          vim.ui.select(vim.tbl_keys(bookmarks), {
            prompt = "Goto bookmark:",
          }, function(choice)
            local folder = bookmarks[choice]
            if type(folder) == "function" then
              folder = folder()
            end

            origin_oil.open(folder)
          end)
        end,
        desc = "Goto bookmark",
      },

      -- Change current working directory to project root from current directory
      ["<Leader>pr"] = {
        callback = function()
          local current_dir = origin_oil.get_current_dir()

          vim.cmd.lcd(current_dir)
          vim.b.git_dir = vim.fn["FugitiveExtractGitDir"](current_dir)

          local git_root = vim.fn["vimrc#git#root"]()
          if not git_root then
            return
          end

          vim.cmd.lcd(git_root)
        end,
        desc = "Change current working directory to project root from current directory",
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
      -- Sort file names in a more intuitive order for humans. Is less performant,
      -- so you may want to set to false if you work with large directories.
      natural_order = true,
      -- Sort file and directory names case insensitive
      case_insensitive = false,
      sort = {
        -- sort order can be "asc" or "desc"
        -- see :help oil-columns to see which columns are sortable
        { "type", "asc" },
        { "name", "asc" },
      },
    },
    -- Extra arguments to pass to SCP when moving/copying files over SSH
    extra_scp_args = {},
    -- EXPERIMENTAL support for performing file operations with git
    git = {
      -- Return true to automatically git add/mv/rm files
      add = function(path)
        return false
      end,
      mv = function(src_path, dest_path)
        return false
      end,
      rm = function(path)
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
        winblend = 0,
      },
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = "auto",
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      override = function(conf)
        return conf
      end,
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
      -- Whether the preview window is automatically updated when the cursor is moved
      update_on_cursor_moved = true,
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
    -- Configuration for the floating SSH window
    ssh = {
      border = "rounded",
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
      border = "rounded",
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
      return ""
    end

    return origin_oil.get_current_dir() .. entry.name
  end, { desc = "Insert oil cursor entry full path", expr = true })
end

oil.setup_mapping = function()
  -- Buffer directory
  vim.keymap.set("n", "<Space>o", origin_oil.open, { desc = "Open parent directory in oil" })
  vim.keymap.set("n", "<Space>O", function(...)
    vim.cmd("vertical split")
    origin_oil.open(...)
  end, { desc = "Open parent directory in vertical split in oil" })
  vim.keymap.set("n", "<Space><C-O>", function(...)
    vim.cmd("split")
    origin_oil.open(...)
  end, { desc = "Open parent directory in horizontal split oil" })

  -- Current working directory
  vim.keymap.set("n", [[\oo]], function()
    origin_oil.open(".")
  end, { desc = "Open current working directory in oil" })
  vim.keymap.set("n", [[\ov]], function()
    vim.cmd("vertical split")
    origin_oil.open(".")
  end, { desc = "Open current working directory in vertical split in oil" })
  vim.keymap.set("n", [[\os]], function()
    vim.cmd("split")
    origin_oil.open(".")
  end, { desc = "Open current working directory in horizontal split in oil" })
end

oil.setup = function()
  oil.setup_config()
  oil.setup_mapping()
end

return oil
