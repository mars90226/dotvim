local utils = require("vimrc.utils")

local terminal = {}

terminal.setup_terminal = function()
  vim.api.nvim_create_user_command(
    "TermOpen",
    [[call vimrc#terminal#open_current_folder('edit', <q-args>)]],
    { nargs = "*" }
  )

  -- For quick terminal access
  local terminal_prefix = "<Leader><Tab>"
  vim.keymap.set(
    "n",
    terminal_prefix .. "e",
    [[:call vimrc#terminal#open_current_shell('edit')<CR>]],
    { silent = true, desc = "Open shell in current buffer" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "t",
    [[:call vimrc#terminal#open_current_shell('tabnew')<CR>]],
    { silent = true, desc = "Open shell in new tab" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "s",
    [[:call vimrc#terminal#open_current_shell('new')<CR>]],
    { silent = true, desc = "Open shell in horizontal split" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "v",
    [[:call vimrc#terminal#open_current_shell('vnew')<CR>]],
    { silent = true, desc = "Open shell in vertical split" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "b",
    [[:call vimrc#terminal#open_current_shell('rightbelow vnew')<CR>]],
    { silent = true, desc = "Open shell in right below vertical split" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "d",
    [[:call vimrc#terminal#open_shell('new', input('Folder: ', '', 'dir'))<CR>]],
    { silent = true, desc = "Open shell with input folder" }
  )
  vim.keymap.set(
    "n",
    terminal_prefix .. "D",
    [[:call vimrc#terminal#open_shell('tabnew', input('Folder: ', '', 'dir'))<CR>]],
    { silent = true, desc = "Open shell with input folder in new tab" }
  )

  -- Quick terminal function
  -- For Alt + Function keys, the keycode may be wrong when using "<M-Fn>" in different `$TERM`s.
  -- When $TERM is `tmux`/`tmux-256color`, the generated keycode for <M-F1> ~ <M-F12> recognized as <F49> ~ <F60> by neovim.
  -- Ref: https://github.com/neovim/neovim/issues/8317
  -- TODO: Better syntax
  for _, key in ipairs(utils.meta_fn_key(1)) do
    vim.keymap.set("t", key, [[<C-\><C-N>]])
  end
  for _, key in ipairs(utils.meta_fn_key(2)) do
    vim.keymap.set("t", key, [[<C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>]])
  end
  for _, key in ipairs(utils.meta_fn_key(3)) do
    vim.keymap.set("t", key, [[<C-\><C-N>:Windows<CR>]])
  end

  -- Quickly leave terminal mode
  vim.keymap.set("t", "<M-C-Q>", [[<C-\><C-N>]])

  -- Quickly switch window in terminal
  vim.keymap.set("t", "<M-S-h>", [[<C-\><C-N><C-W>h]])
  vim.keymap.set("t", "<M-S-j>", [[<C-\><C-N><C-W>j]])
  vim.keymap.set("t", "<M-S-k>", [[<C-\><C-N><C-W>k]])
  -- FIXME: Conflict with M-L in tmux
  vim.keymap.set("t", "<M-S-l>", [[<C-\><C-N><C-W>l]])

  -- Quickly switch tab in terminal
  vim.keymap.set("t", "<M-C-J>", [[<C-\><C-N>gT]])
  vim.keymap.set("t", "<M-C-K>", [[<C-\><C-N>gt]])

  -- Quickly switch to last tab in terminal
  -- NOTE: Similar to <C-Tab>, but support fzf
  vim.keymap.set("t", "<M-1>", [[<C-\><C-N>:LastTab<CR>]])

  -- Quickly paste from register
  vim.keymap.set(
    "t",
    "<M-r>",
    [[<C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>]]
  )
  vim.keymap.set("t", "<M-r><M-r>", [[<M-r>]])

  -- Quickly suspend neovim
  vim.keymap.set("t", "<M-C-Z>", [[<C-\><C-N>:suspend<CR>]])

  -- Quickly page-up/page-down
  vim.keymap.set("t", "<M-PageUp>", [[<C-\><C-N><PageUp>]])
  vim.keymap.set("t", "<M-PageDown>", [[<C-\><C-N><PageDown>]])

  -- Search pattern
  vim.keymap.set("t", "<M-s>", [[<C-\><C-N><Plug>(search-prefix)]], { remap = true })
  vim.keymap.set("t", "<M-s><M-s>", [[<M-s>]])

  -- Jump to pattern
  vim.keymap.set("t", "<M-m>w", [=[<C-\><C-N>:lua require('hop').hint_patterns({}, [[\v\k+]])<CR>]=])
  vim.keymap.set("t", "<M-m>W", [=[<C-\><C-N>:lua require('hop').hint_patterns({}, [[\v\S+]])<CR>]=])
  vim.keymap.set("t", "<M-m>f", [=[<C-\><C-N>:lua require('vimrc.plugins.hop').search_patterns({}, 'file')<CR>]=])
  vim.keymap.set("t", "<M-m>y", [=[<C-\><C-N>:lua require('vimrc.plugins.hop').search_patterns({}, 'hash')<CR>]=])
  vim.keymap.set("t", "<M-m>u", [=[<C-\><C-N>:lua require('vimrc.plugins.hop').search_patterns({}, 'url')<CR>]=])
  vim.keymap.set("t", "<M-m>i", [=[<C-\><C-N>:lua require('vimrc.plugins.hop').search_patterns({}, 'ip')<CR>]=])

  -- Jump to pattern by flash
  vim.keymap.set("t", "<M-m><M-,>", [=[<C-\><C-N>:lua require('flash').jump()<CR>]=])

  -- Jump to pattern by pounce
  vim.keymap.set("t", "<M-m><M-/>", [=[<C-\><C-N>:Pounce<CR>]=])
end

terminal.setup_nested_neovim = function()
  -- NOTE: Use <M-q> as prefix

  -- Quick terminal function
  vim.keymap.set("t", "<M-q>1", [[<C-\><C-\><C-N>]])
  vim.keymap.set("t", "<M-q>2", [[<C-\><C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>]])
  vim.keymap.set("t", "<M-q>3", [[<C-\><C-\><C-N>:Windows<CR>]])

  -- Quickly leave terminal mode
  vim.keymap.set("t", "<M-q><M-C-Q>", [[<C-\><C-\><C-N>]])

  -- Quickly switch window in terminal
  vim.keymap.set("t", "<M-q><M-h>", [[<C-\><C-\><C-N><C-W>h]])
  vim.keymap.set("t", "<M-q><M-j>", [[<C-\><C-\><C-N><C-W>j]])
  vim.keymap.set("t", "<M-q><M-k>", [[<C-\><C-\><C-N><C-W>k]])
  vim.keymap.set("t", "<M-q><M-l>", [[<C-\><C-\><C-N><C-W>l]])

  -- Quickly switch tab in terminal
  vim.keymap.set("t", "<M-q><C-J>", [[<C-\><C-\><C-N>gT]])
  vim.keymap.set("t", "<M-q><C-K>", [[<C-\><C-\><C-N>gt]])

  -- Quickly switch to last tab in terminal
  vim.keymap.set("t", "<M-q><M-1>", [[<C-\><C-\><C-N>:LastTab<CR>]])

  -- Quickly paste from register
  vim.keymap.set(
    "t",
    "<M-q><M-r>",
    [[<C-\><C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>]]
  )

  -- Quickly suspend neovim
  vim.keymap.set("t", "<M-q><C-Z>", [[<C-\><C-\><C-N>:suspend<CR>]])

  -- Quickly page-up/page-down
  vim.keymap.set("t", "<M-q><PageUp>", [[<C-\><C-\><C-N><PageUp>]])
  vim.keymap.set("t", "<M-q><PageDown>", [[<C-\><C-\><C-N><PageDown>]])

  -- Search pattern
  vim.keymap.set("t", "<M-q><M-s>", [[<C-\><C-\><C-N><Plug>(search-prefix)]], { remap = true })
  -- FIXME: Cannot send `<M-s>` to nested neovim
end

-- TODO: Improve naming
terminal.setup_nested_nested_neovim = function()
  -- For nested nested neovim {{{
  vim.keymap.set(
    "t",
    [[<M-q><M-q>]],
    [[vimrc#terminal#nested_neovim#start("\<M-q>", 2)]],
    { expr = true, silent = true }
  )

  -- Quick terminal function
  vim.fn["vimrc#terminal#nested_neovim#register"]("1", "")
  vim.fn["vimrc#terminal#nested_neovim#register"]("2", ":call vimrc#terminal#open_current_shell('tabnew')<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("3", ":Windows<CR>")

  -- Quickly leave terminal mode
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-C-Q>", "")

  -- Quickly switch window in terminal
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-h>", "<C-W>h")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-j>", "<C-W>j")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-k>", "<C-W>k")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-l>", "<C-W>l")

  -- Quickly switch tab in terminal
  vim.fn["vimrc#terminal#nested_neovim#register"]("<C-J>", "gT")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<C-K>", "gt")

  -- Quickly switch to last tab in terminal
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-1>", ":LastTab<CR>")

  -- Quickly paste from register
  vim.fn["vimrc#terminal#nested_neovim#register"](
    "<M-r>",
    ":execute 'normal! \"'.v:lua.require('vimrc.utils').get_char_string().'pi'<CR>"
  )

  -- Quickly suspend neovim
  vim.fn["vimrc#terminal#nested_neovim#register"]("<C-Z>", ":suspend<CR>")

  -- Quickly page-up/page-down
  vim.fn["vimrc#terminal#nested_neovim#register"]("<PageUp>", "<PageUp>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<PageDown>", "<PageDown>")

  -- Search pattern
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-s>", [[<Plug>(search-prefix)]])

  -- Jump to pattern
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m>w", [=[:lua require('hop').hint_patterns({}, [[\v\k+]])<CR>]=])
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m>W", [=[:lua require('hop').hint_patterns({}, [[\v\S+]])<CR>]=])
  vim.fn["vimrc#terminal#nested_neovim#register"](
    "<M-m>f",
    [=[:lua require('vimrc.plugins.hop').search_patterns({}, 'file')<CR>]=]
  )
  vim.fn["vimrc#terminal#nested_neovim#register"](
    "<M-m>y",
    [=[:lua require('vimrc.plugins.hop').search_patterns({}, 'hash')<CR>]=]
  )
  vim.fn["vimrc#terminal#nested_neovim#register"](
    "<M-m>u",
    [=[:lua require('vimrc.plugins.hop').search_patterns({}, 'url')<CR>]=]
  )
  vim.fn["vimrc#terminal#nested_neovim#register"](
    "<M-m>i",
    [=[:lua require('vimrc.plugins.hop').search_patterns({}, 'ip')<CR>]=]
  )

  -- Jump to pattern by flash
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m><M-,>", [=[:lua require('flash').jump()<CR>]=])

  -- Jump to pattern by pounce
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m><M-/>", [=[:Pounce<CR>]=])

  -- Command palette
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m><M-m>", ":Telescope command_palette<CR>")
  vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m><M-M>", ":CommandPalette<CR>")
  -- }}}
end

terminal.setup_autocmd = function()
  local terminal_augroup_id = vim.api.nvim_create_augroup("terminal_settings", {})
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = terminal_augroup_id,
    pattern = "*",
    callback = function()
      vim.fn["vimrc#terminal#settings"]()
      vim.fn["vimrc#terminal#mappings"]()
    end,
  })

  -- TODO Start insert mode when canceling :Windows in terminal mode or
  -- selecting another terminal buffer
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    group = terminal_augroup_id,
    pattern = "term://*",
    callback = function()
      if vim.bo.buftype == "terminal" then
        if require("vimrc.terminal").is_startinsert_ignored() then
          return
        end
        vim.cmd([[startinsert]])
      end
    end,
  })
  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    group = terminal_augroup_id,
    pattern = "term://*",
    callback = function()
      if vim.bo.buftype == "terminal" then
        vim.cmd([[stopinsert]])
      end
    end,
  })

  -- Ignore various filetypes as those will close terminal automatically
  -- Ignore fzf
  vim.api.nvim_create_autocmd({ "TermClose" }, {
    group = terminal_augroup_id,
    pattern = "term://*",
    callback = function()
      vim.fn["vimrc#terminal#close_result_buffer"](vim.fn.expand("<afile>"))
    end,
  })
end

terminal.setup = function()
  terminal.setup_terminal()
  terminal.setup_nested_neovim()
  terminal.setup_nested_nested_neovim()
  terminal.setup_autocmd()
end

return terminal
