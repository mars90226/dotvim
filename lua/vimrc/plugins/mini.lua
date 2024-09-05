local mini = {}

mini.files = {}

-- Ref: mini-files.txt help
mini.files.open_in_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target_window)
    MiniFiles.go_in()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

mini.setup_autocmd = function()
  -- Ref: mini-files.txt help
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak keys to your liking
      mini.files.open_in_split(buf_id, "gs", "belowright horizontal")
      mini.files.open_in_split(buf_id, "gv", "belowright vertical")
      mini.files.open_in_split(buf_id, "gt", "belowright tab")
    end,
  })
end

mini.setup_config = function()
  local gen_spec = require("mini.ai").gen_spec
  require("mini.ai").setup({
    custom_textobjects = {
      d = gen_spec.function_call(),
      f = nil, -- NOTE: Conflict with nvim-treesitter-textobjects @function.outer/@function.inner
    },
  })
  -- TODO: Check if individual modules can be lazy loaded?
  require("mini.basics").setup({
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
  require("mini.bracketed").setup({
    -- Map [K, [k, ]k, ]K for comment to avoid [c, ]c default vim mappings in diff-mode.
    comment = { suffix = "k" },
    -- Map [N, [n, ]n, ]N for conflict marker like in 'tpope/vim-unimpaired'
    conflict = { suffix = "n" },
  })
  require("mini.files").setup({
    options = {
      -- Whether to use for editing directories
      use_as_default_explorer = false, -- Use oil.nvim as default explorer
    },
  })
  require("mini.pick").setup({
    mappings = {
      move_down = "<C-j>",
      move_up = "<C-k>",
    },
  })
  require("mini.extra").setup()
end

mini.setup_mapping = function()
  -- mini.files
  vim.keymap.set("n", "<Leader>mf", [[<Cmd>lua MiniFiles.open()<CR>]])

  -- mini.pick
  vim.keymap.set("n", "<Space>mb", [[<Cmd>Pick buffers<CR>]])
  vim.keymap.set("n", "<Space>mf", [[<Cmd>Pick files<CR>]])
  vim.keymap.set("n", "<Space>mg", [[<Cmd>Pick grep<CR>]])
  vim.keymap.set("n", "<Space>mh", [[<Cmd>Pick help<CR>]])
  vim.keymap.set("n", "<Space>mi", [[<Cmd>Pick grep_live<CR>]])
  vim.keymap.set("n", "<Space>mu", [[<Cmd>Pick resume<CR>]])

  -- mini.extra
  vim.keymap.set("n", "<Space>mll", [[<Cmd>Pick buf_lines scope='current'<CR>]])
  vim.keymap.set("n", "<Space>mL", [[<Cmd>Pick buf_lines<CR>]])
  vim.keymap.set("n", "<Space>m;", [[<Cmd>Pick commands<CR>]])
  vim.keymap.set("n", "<Space>md", [[<Cmd>Pick diagnostic scope='current'<CR>]])
  vim.keymap.set("n", "<Space>mD", [[<Cmd>Pick diagnostic<CR>]])
  vim.keymap.set("n", "<Space>m0", [[<Cmd>Pick explorer<CR>]])
  vim.keymap.set("n", "<Space>mB", [[<Cmd>Pick git_branches<CR>]])
  vim.keymap.set("n", "<Space>mc", [[<Cmd>Pick git_commits path='%'<CR>]])
  vim.keymap.set("n", "<Space>mC", [[<Cmd>Pick git_commits<CR>]])
  vim.keymap.set("n", "<Space>mv", [[<Cmd>Pick git_hunks path='%'<CR>]])
  vim.keymap.set("n", "<Space>mV", [[<Cmd>Pick git_hunks<CR>]])
  vim.keymap.set("n", "<Space>mo", [[<Cmd>Pick history<CR>]])
  vim.keymap.set("n", "<Space>m:", [[<Cmd>Pick history scope='cmd'<CR>]])
  vim.keymap.set("n", "<Space>m/", [[<Cmd>Pick history scope='search'<CR>]])
  vim.keymap.set("n", "<Space>mY", [[<Cmd>Pick hl_groups<CR>]])
  vim.keymap.set("n", "<Space>m<Tab>", [[<Cmd>Pick keymaps<CR>]])
  vim.keymap.set("n", "<Space>mq", [[<Cmd>Pick list scope='quickfix'<CR>]])
  vim.keymap.set("n", "<Space>ma", [[<Cmd>Pick list scope='location'<CR>]])
  vim.keymap.set("n", "<Space>mj", [[<Cmd>Pick list scope='jump'<CR>]])
  vim.keymap.set("n", "<Space>mx", [[<Cmd>Pick list scope='change'<CR>]])
  vim.keymap.set("n", "<Space>mld", [[<Cmd>Pick lsp scope='definition'<CR>]])
  vim.keymap.set("n", "<Space>mlD", [[<Cmd>Pick lsp scope='declaration'<CR>]])
  vim.keymap.set("n", "<Space>mlr", [[<Cmd>Pick lsp scope='references'<CR>]])
  vim.keymap.set("n", "<Space>mlc", [[<Cmd>Pick lsp scope='document_symbol'<CR>]])
  vim.keymap.set("n", "<Space>mlC", [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]])
  vim.keymap.set("n", "<Space>mli", [[<Cmd>Pick lsp scope='implementation'<CR>]])
  vim.keymap.set("n", "<Space>mlt", [[<Cmd>Pick lsp scope='type_definition'<CR>]])
  vim.keymap.set("n", "<Space>m`", [[<Cmd>Pick marks<CR>]])
  vim.keymap.set("n", "<Space>mO", [[<Cmd>Pick oldfiles<CR>]])
  vim.keymap.set("n", "<Space>m<C-O>", [[<Cmd>Pick options<CR>]])
  vim.keymap.set("n", "<Space>mS", [[<Cmd>Pick registers<CR>]])
  vim.keymap.set("n", "<Space>mt", [[<Cmd>Pick treesitter<CR>]])

  -- TODO: Add key mapping for `:Pick cli`
end

mini.setup = function()
  mini.setup_config()
  mini.setup_mapping()
  mini.setup_autocmd()
end

return mini
