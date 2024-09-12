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
  local mini_prefix = "<Leader>m"
  local mini_pick_prefix = "<Space>m"
  local mini_pick_lsp_prefix = "<Space>ml"

  -- mini.files
  vim.keymap.set("n", mini_prefix .. "f", [[<Cmd>lua MiniFiles.open()<CR>]])

  -- mini.pick
  vim.keymap.set("n", mini_pick_prefix .. "b", [[<Cmd>Pick buffers<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "f", [[<Cmd>Pick files<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "g", [[<Cmd>Pick grep<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "h", [[<Cmd>Pick help<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "i", [[<Cmd>Pick grep_live<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "u", [[<Cmd>Pick resume<CR>]])

  -- mini.extra
  vim.keymap.set("n", mini_pick_prefix .. "ll", [[<Cmd>Pick buf_lines scope='current'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "L", [[<Cmd>Pick buf_lines<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. ";", [[<Cmd>Pick commands<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "d", [[<Cmd>Pick diagnostic scope='current'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "D", [[<Cmd>Pick diagnostic<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "0", [[<Cmd>Pick explorer<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "B", [[<Cmd>Pick git_branches<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "c", [[<Cmd>Pick git_commits path='%'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "C", [[<Cmd>Pick git_commits<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "v", [[<Cmd>Pick git_hunks path='%'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "V", [[<Cmd>Pick git_hunks<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "o", [[<Cmd>Pick history<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. ":", [[<Cmd>Pick history scope='cmd'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "/", [[<Cmd>Pick history scope='search'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "Y", [[<Cmd>Pick hl_groups<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "<Tab>", [[<Cmd>Pick keymaps<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "q", [[<Cmd>Pick list scope='quickfix'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "a", [[<Cmd>Pick list scope='location'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "j", [[<Cmd>Pick list scope='jump'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "x", [[<Cmd>Pick list scope='change'<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "`", [[<Cmd>Pick marks<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "O", [[<Cmd>Pick oldfiles<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "<C-O>", [[<Cmd>Pick options<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "S", [[<Cmd>Pick registers<CR>]])
  vim.keymap.set("n", mini_pick_prefix .. "t", [[<Cmd>Pick treesitter<CR>]])

  -- mini.extra lsp
  vim.keymap.set("n", mini_pick_lsp_prefix .. "d", [[<Cmd>Pick lsp scope='definition'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "D", [[<Cmd>Pick lsp scope='declaration'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "r", [[<Cmd>Pick lsp scope='references'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "c", [[<Cmd>Pick lsp scope='document_symbol'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "C", [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "i", [[<Cmd>Pick lsp scope='implementation'<CR>]])
  vim.keymap.set("n", mini_pick_lsp_prefix .. "t", [[<Cmd>Pick lsp scope='type_definition'<CR>]])

  -- TODO: Add key mapping for `:Pick cli`
end

mini.setup = function()
  mini.setup_config()
  mini.setup_mapping()
  mini.setup_autocmd()
end

return mini
