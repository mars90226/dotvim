local mini = {}

mini.files = {}

-- Ref: mini-files.txt help
mini.files.open_in_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
      vim.cmd(direction .. ' split')
      new_target_window = vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target_window)
    MiniFiles.go_in()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = 'Split ' .. direction
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

mini.setup_autocmd = function()
  -- Ref: mini-files.txt help
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak keys to your liking
      mini.files.open_in_split(buf_id, 'gs', 'belowright horizontal')
      mini.files.open_in_split(buf_id, 'gv', 'belowright vertical')
      mini.files.open_in_split(buf_id, 'gt', 'belowright tab')
    end,
  })
end

mini.setup_config = function()
  require('mini.files').setup()
  require('mini.pick').setup({
    mappings = {
      move_down = "<C-j>",
      move_up = "<C-k>",
    }
  })
end

mini.setup_mapping = function()
  -- mini.files
  nnoremap("<Leader>mf", [[<Cmd>lua MiniFiles.open()<CR>]])

  -- mini.pick
  nnoremap("<Space>mb", [[<Cmd>Pick buffers<CR>]])
  nnoremap("<Space>mf", [[<Cmd>Pick files<CR>]])
  nnoremap("<Space>mg", [[<Cmd>Pick grep<CR>]])
  nnoremap("<Space>mh", [[<Cmd>Pick help<CR>]])
  nnoremap("<Space>mi", [[<Cmd>Pick grep_live<CR>]])
  nnoremap("<Space>mu", [[<Cmd>Pick resume<CR>]])

  -- TODO: Add key mapping for `:Pick cli` 
end

mini.setup = function()
  mini.setup_config()
  mini.setup_mapping()
  mini.setup_autocmd()
end

return mini
