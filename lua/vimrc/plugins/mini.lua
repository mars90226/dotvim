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
  require('mini.ai').setup()
  -- TODO: Check if individual modules can be lazy loaded?
  require('mini.basics').setup({
    options = {
      basic = false,
    },
    mappings = {
      basic = false,
      option_toggle_prefix = [[yo]],
    },
    autocommands = {
      basic = false,
    },
  })
  require('mini.bracketed').setup({
    -- Map [K, [k, ]k, ]K for comment to avoid [c, ]c default vim mappings in diff-mode.
    comment = { suffix = 'k' },
    -- Map [N, [n, ]n, ]N for conflict marker like in 'tpope/vim-unimpaired'
    conflict = { suffix = 'n' },
  })
  require('mini.files').setup({
    options = {
      -- Whether to use for editing directories
      use_as_default_explorer = false, -- Use oil.nvim as default explorer
    }
  })
  require('mini.pick').setup({
    mappings = {
      move_down = "<C-j>",
      move_up = "<C-k>",
    }
  })
  require('mini.extra').setup()
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

  -- mini.extra
  nnoremap("<Space>mll", [[<Cmd>Pick buf_lines scope='current'<CR>]])
  nnoremap("<Space>mL", [[<Cmd>Pick buf_lines<CR>]])
  nnoremap("<Space>m;", [[<Cmd>Pick commands<CR>]])
  nnoremap("<Space>md", [[<Cmd>Pick diagnostic scope='current'<CR>]])
  nnoremap("<Space>mD", [[<Cmd>Pick diagnostic<CR>]])
  nnoremap("<Space>m0", [[<Cmd>Pick explorer<CR>]])
  nnoremap("<Space>mB", [[<Cmd>Pick git_branches<CR>]])
  nnoremap("<Space>mc", [[<Cmd>Pick git_commits path='%'<CR>]])
  nnoremap("<Space>mC", [[<Cmd>Pick git_commits<CR>]])
  nnoremap("<Space>mv", [[<Cmd>Pick git_hunks path='%'<CR>]])
  nnoremap("<Space>mV", [[<Cmd>Pick git_hunks<CR>]])
  nnoremap("<Space>mo", [[<Cmd>Pick history<CR>]])
  nnoremap("<Space>m:", [[<Cmd>Pick history scope='cmd'<CR>]])
  nnoremap("<Space>m/", [[<Cmd>Pick history scope='search'<CR>]])
  nnoremap("<Space>mY", [[<Cmd>Pick hl_groups<CR>]])
  nnoremap("<Space>m<Tab>", [[<Cmd>Pick keymaps<CR>]])
  nnoremap("<Space>mq", [[<Cmd>Pick list scope='quickfix'<CR>]])
  nnoremap("<Space>ma", [[<Cmd>Pick list scope='location'<CR>]])
  nnoremap("<Space>mj", [[<Cmd>Pick list scope='jump'<CR>]])
  nnoremap("<Space>mx", [[<Cmd>Pick list scope='change'<CR>]])
  nnoremap("<Space>mld", [[<Cmd>Pick lsp scope='definition'<CR>]])
  nnoremap("<Space>mlD", [[<Cmd>Pick lsp scope='declaration'<CR>]])
  nnoremap("<Space>mlr", [[<Cmd>Pick lsp scope='references'<CR>]])
  nnoremap("<Space>mlc", [[<Cmd>Pick lsp scope='document_symbol'<CR>]])
  nnoremap("<Space>mlC", [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]])
  nnoremap("<Space>mli", [[<Cmd>Pick lsp scope='implementation'<CR>]])
  nnoremap("<Space>mlt", [[<Cmd>Pick lsp scope='type_definition'<CR>]])
  nnoremap("<Space>m`", [[<Cmd>Pick marks<CR>]])
  nnoremap("<Space>mO", [[<Cmd>Pick oldfiles<CR>]])
  nnoremap("<Space>m<C-O>", [[<Cmd>Pick options<CR>]])
  nnoremap("<Space>mS", [[<Cmd>Pick registers<CR>]])
  nnoremap("<Space>mt", [[<Cmd>Pick treesitter<CR>]])

  -- TODO: Add key mapping for `:Pick cli` 
end

mini.setup = function()
  mini.setup_config()
  mini.setup_mapping()
  mini.setup_autocmd()
end

return mini
