local plugin_utils = require("vimrc.plugin_utils")

local float = {}

float.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/float",
    config = function()
      -- TODO: Move these config to other place
      -- Zoom {{{
      vim.keymap.set("n", "<Leader>zz", [[:call vimrc#zoom#zoom()<CR>]], { silent = true })
      vim.keymap.set("x", "<Leader>zz", [[:<C-U>call vimrc#zoom#selected(vimrc#utility#get_visual_selection())<CR>]], { silent = true })

      vim.keymap.set("n", "<Leader>zf", [[:call vimrc#zoom#float()<CR>]], { silent = true })
      vim.keymap.set("x", 
        "<Leader>zf",
        [[:<C-U>call vimrc#zoom#float_selected(vimrc#utility#get_visual_selection())<CR>]],
        { silent = true }
      )
      vim.keymap.set("n", "<Leader>zF", [[:call vimrc#zoom#into_float()<CR>]], { silent = true })
      -- }}}

      -- Float {{{
      vim.api.nvim_create_user_command(
        "VimrcFloatToggle",
        [[call vimrc#float#toggle(<q-args>, <bang>0)]],
        { bang = true, nargs = "?" }
      )
      vim.api.nvim_create_user_command(
        "VimrcFloatNew",
        [[call vimrc#float#new(<q-args>, <bang>0)]],
        { bang = true, nargs = "?", complete = "command" }
      )
      vim.api.nvim_create_user_command("VimrcFloatPrev", [[call vimrc#float#prev()]], {})
      vim.api.nvim_create_user_command("VimrcFloatNext", [[call vimrc#float#next()]], {})
      vim.api.nvim_create_user_command("VimrcFloatRemove", [[call vimrc#float#remove()]], {})
      -- TODO: Use floaterm & g:floaterm_autoclose = v:false for non-interactive
      -- terminal command
      vim.api.nvim_create_user_command(
        "VimrcFloatermNew",
        [[call vimrc#float#new('TermOpen '.<q-args>, <bang>0)]],
        { bang = true, nargs = "?", complete = "command" }
      )

      vim.keymap.set("n", "<M-,><M-l>", [[:VimrcFloatToggle<CR>]], { silent = true })
      vim.keymap.set("i", "<M-,><M-l>", [[<Esc>:VimrcFloatToggle<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-n>", [[:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-m>", [[:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-j>", [[:VimrcFloatPrev<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-k>", [[:VimrcFloatNext<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-r>", [[:VimrcFloatRemove<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-x>", [[:execute 'VimrcFloatermNew '.input('command: ', '', 'shellcmd')<CR>]], { silent = true })
      vim.keymap.set("n", "<M-,><M-c>", [[:execute 'VimrcFloatermNew! '.input('command: ', '', 'shellcmd')<CR>]], { silent = true })

      -- terminal key mappings
      vim.keymap.set("t", "<M-q><M-,><M-l>", [[<C-\><C-N>:VimrcFloatToggle<CR>]], { silent = true })
      vim.keymap.set("t", 
        "<M-q><M-,><M-n>",
        [[<C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]],
        { silent = true }
      )
      vim.keymap.set("t", 
        "<M-q><M-,><M-m>",
        [[<C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]],
        { silent = true }
      )
      vim.keymap.set("t", "<M-q><M-,><M-j>", [[<C-\><C-N>:VimrcFloatPrev<CR>]], { silent = true })
      vim.keymap.set("t", "<M-q><M-,><M-k>", [[<C-\><C-N>:VimrcFloatNext<CR>]], { silent = true })
      vim.keymap.set("t", "<M-q><M-,><M-r>", [[<C-\><C-N>:VimrcFloatRemove<CR>]], { silent = true })

      vim.keymap.set("t", "<M-q><M-,><M-l>", [[<C-\><C-N>:VimrcFloatToggle<CR>]], { silent = true })
      vim.keymap.set("t", 
        "<M-q><M-,><M-n>",
        [[<C-\><C-N>:execute 'VimrcFloatNew '.input('command: ', '', 'command')<CR>]],
        { silent = true }
      )
      vim.keymap.set("t", 
        "<M-q><M-,><M-m>",
        [[<C-\><C-N>:execute 'VimrcFloatNew! '.input('command: ', '', 'command')<CR>]],
        { silent = true }
      )
      vim.keymap.set("t", "<M-q><M-,><M-j>", [[<C-\><C-N>:VimrcFloatPrev<CR>]], { silent = true })
      vim.keymap.set("t", "<M-q><M-,><M-k>", [[<C-\><C-N>:VimrcFloatNext<CR>]], { silent = true })
      vim.keymap.set("t", "<M-q><M-,><M-r>", [[<C-\><C-N>:VimrcFloatRemove<CR>]], { silent = true })

      -- TODO For nested neovim
      -- Need to implement different prefix_count for diferrent key mappings in
      -- nested_neovim.vim
      -- }}}
    end,
  })
end

return float
