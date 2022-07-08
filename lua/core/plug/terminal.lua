local plugin_utils = require("vimrc.plugin_utils")

local terminal = {}

terminal.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  use_config({
    "mars90226/terminal",
    config = function()
      -- neovim terminal key mapping and settings {{{
      -- Set terminal buffer size to unlimited
      -- TODO: Move to setting.lua
      vim.opt.scrollback = 100000

      vim.api.nvim_create_user_command(
        "TermOpen",
        [[call vimrc#terminal#open_current_folder('edit', <q-args>)]],
        { nargs = "*" }
      )

      -- For quick terminal access
      nnoremap("<Leader>te", [[:call vimrc#terminal#open_current_shell('edit')<CR>]], "<silent>")
      nnoremap("<Leader>tt", [[:call vimrc#terminal#open_current_shell('tabnew')<CR>]], "<silent>")
      nnoremap("<Leader>ts", [[:call vimrc#terminal#open_current_shell('new')<CR>]], "<silent>")
      nnoremap("<Leader>tv", [[:call vimrc#terminal#open_current_shell('vnew')<CR>]], "<silent>")
      nnoremap("<Leader>tb", [[:call vimrc#terminal#open_current_shell('rightbelow vnew')<CR>]], "<silent>")
      nnoremap("<Leader>td", [[:call vimrc#terminal#open_shell('new', input('Folder: ', '', 'dir'))<CR>]], "<silent>")
      nnoremap(
        "<Leader>tD",
        [[:call vimrc#terminal#open_shell('tabnew', input('Folder: ', '', 'dir'))<CR>]],
        "<silent>"
      )

      -- Quick terminal function
      tnoremap("<M-F1>", [[<C-\><C-N>]])
      tnoremap("<M-F2>", [[<C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>]])
      tnoremap("<M-F3>", [[<C-\><C-N>:Windows<CR>]])

      -- Quickly switch window in terminal
      tnoremap("<M-S-h>", [[<C-\><C-N><C-W>h]])
      tnoremap("<M-S-j>", [[<C-\><C-N><C-W>j]])
      tnoremap("<M-S-k>", [[<C-\><C-N><C-W>k]])
      tnoremap("<M-S-l>", [[<C-\><C-N><C-W>l]])

      -- Quickly switch tab in terminal
      tnoremap("<M-C-J>", [[<C-\><C-N>gT]])
      tnoremap("<M-C-K>", [[<C-\><C-N>gt]])

      -- Quickly switch to last tab in terminal
      tnoremap("<M-1>", [[<C-\><C-N>:LastTab<CR>]])

      -- Quickly paste from register
      tnoremap("<M-r>", [[<C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>]])
      tnoremap("<M-r><M-r>", [[<M-r>]])

      -- Quickly suspend neovim
      tnoremap("<M-C-Z>", [[<C-\><C-N>:suspend<CR>]])

      -- Quickly page-up/page-down
      tnoremap("<M-PageUp>", [[<C-\><C-N><PageUp>]])
      tnoremap("<M-PageDown>", [[<C-\><C-N><PageDown>]])

      -- Search pattern
      tnoremap("<M-s><C-F>", [[<C-\><C-N>:call vimrc#search#search_file(0)<CR>]])
      tnoremap("<M-s><C-Y>", [[<C-\><C-N>:call vimrc#search#search_hash(0)<CR>]])
      tnoremap("<M-s><C-U>", [[<C-\><C-N>:call vimrc#search#search_url(0)<CR>]])
      tnoremap("<M-s><C-I>", [[<C-\><C-N>:call vimrc#search#search_ip(0)<CR>]])
      tnoremap("<M-s><M-s>", [[<M-s>]])

      -- Command palette
      tnoremap("<M-m><M-m>", [[<C-\><C-N>:Telescope command_palette<CR>]])

      -- For nested neovim {{{
      -- Use <M-q> as prefix

      -- Quick terminal function
      tnoremap("<M-q>1", [[<C-\><C-\><C-N>]])
      tnoremap("<M-q>2", [[<C-\><C-\><C-N>:call vimrc#terminal#open_current_shell('tabnew')<CR>]])
      tnoremap("<M-q>3", [[<C-\><C-\><C-N>:Windows<CR>]])

      -- Quickly switch window in terminal
      tnoremap("<M-q><M-h>", [[<C-\><C-\><C-N><C-W>h]])
      tnoremap("<M-q><M-j>", [[<C-\><C-\><C-N><C-W>j]])
      tnoremap("<M-q><M-k>", [[<C-\><C-\><C-N><C-W>k]])
      tnoremap("<M-q><M-l>", [[<C-\><C-\><C-N><C-W>l]])

      -- Quickly switch tab in terminal
      tnoremap("<M-q><C-J>", [[<C-\><C-\><C-N>gT]])
      tnoremap("<M-q><C-K>", [[<C-\><C-\><C-N>gt]])

      -- Quickly switch to last tab in terminal
      tnoremap("<M-q><M-1>", [[<C-\><C-\><C-N>:LastTab<CR>]])

      -- Quickly paste from register
      tnoremap(
        "<M-q><M-r>",
        [[<C-\><C-\><C-N>:execute 'normal! "'.v:lua.require("vimrc.utils").get_char_string().'pi'<CR>]]
      )

      -- Quickly suspend neovim
      tnoremap("<M-q><C-Z>", [[<C-\><C-\><C-N>:suspend<CR>]])

      -- Quickly page-up/page-down
      tnoremap("<M-q><PageUp>", [[<C-\><C-\><C-N><PageUp>]])
      tnoremap("<M-q><PageDown>", [[<C-\><C-\><C-N><PageDown>]])

      -- Search pattern
      tnoremap("<M-q><C-F>", [[<C-\><C-\><C-N>:call vimrc#search#search_file(0)<CR>]])
      tnoremap("<M-q><C-Y>", [[<C-\><C-\><C-N>:call vimrc#search#search_hash(0)<CR>]])
      tnoremap("<M-q><C-U>", [[<C-\><C-\><C-N>:call vimrc#search#search_url(0)<CR>]])
      tnoremap("<M-q><C-I>", [[<C-\><C-\><C-N>:call vimrc#search#search_ip(0)<CR>]])

      -- Command palette
      tnoremap("<M-q><M-m>", [[<C-\><C-\><C-N>:Telescope command_palette<CR>]])

      -- For nested nested neovim {{{
      tnoremap("<expr>", [[<M-q><M-q> vimrc#terminal#nested_neovim#start("\<M-q>", 2)]], "<silent>")

      -- Quick terminal function
      vim.fn["vimrc#terminal#nested_neovim#register"]("1", "")
      vim.fn["vimrc#terminal#nested_neovim#register"]("2", ":call vimrc#terminal#open_current_shell('tabnew')<CR>")
      vim.fn["vimrc#terminal#nested_neovim#register"]("3", ":Windows<CR>")

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
      vim.fn["vimrc#terminal#nested_neovim#register"]("<C-F>", ":call vimrc#search#search_file(0)<CR>")
      vim.fn["vimrc#terminal#nested_neovim#register"]("<C-Y>", ":call vimrc#search#search_hash(0)<CR>")
      vim.fn["vimrc#terminal#nested_neovim#register"]("<C-U>", ":call vimrc#search#search_url(0)<CR>")
      vim.fn["vimrc#terminal#nested_neovim#register"]("<C-I>", ":call vimrc#search#search_ip(0)<CR>")

      -- Command palette
      vim.fn["vimrc#terminal#nested_neovim#register"]("<M-m><M-m>", ":Telescope command_palette<CR>")
      -- }}}
      -- }}}

      vim.cmd([[augroup terminal_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd TermOpen * call vimrc#terminal#settings()]])
      vim.cmd([[  autocmd TermOpen * call vimrc#terminal#mappings()]])

      -- TODO Start insert mode when cancelling :Windows in terminal mode or
      -- selecting another terminal buffer
      vim.cmd([[  autocmd BufWinEnter,WinEnter term://* if &buftype ==# 'terminal' | startinsert | endif]])
      vim.cmd([[  autocmd BufLeave             term://* if &buftype ==# 'terminal' | stopinsert  | endif]])

      -- Ignore various filetypes as those will close terminal automatically
      -- Ignore fzf
      vim.cmd([[  autocmd TermClose term://* call vimrc#terminal#close_result_buffer(expand('<afile>'))]])
      vim.cmd([[augroup END]])
      -- }}}
    end,
  })
end

return terminal
