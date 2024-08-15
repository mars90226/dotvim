local gitsigns = {}

gitsigns.on_attach = function(bufnr)
  local gs = require("gitsigns")

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]g", function()
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Gitsigns next_hunk" })

  map("n", "[g", function()
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Gitsigns preview_hunk" })

  -- Actions
  map({ "n", "v" }, "<Leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Gitsigns stage_hunk" })
  map({ "n", "v" }, "<Leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Gitsigns reset_hunk" })
  map("n", "<Leader>hS", gs.stage_buffer, { desc = "Gitsigns stage_buffer" })
  map("n", "<Leader>hu", gs.undo_stage_hunk, { desc = "Gitsigns undo_stage_hunk" })
  map("n", "<Leader>hR", gs.reset_buffer, { desc = "Gitsigns reset_buffer" })
  map("n", "<Leader>hp", gs.preview_hunk, { desc = "Gitsigns preview_hunk" })
  map("n", "<Leader>hb", function()
    gs.blame_line({ full = true })
  end, { desc = "Gitsigns blame_line" })
  map("n", "<Leader>hB", gs.toggle_current_line_blame, { desc = "Gitsigns toggle_current_line_blame" })
  map("n", "<Leader>hd", gs.diffthis, { desc = "Gitsigns diffthis" })
  map("n", "<Leader>hD", function()
    gs.diffthis("~")
  end, { desc = "Gitsigns diffthis with parent of HEAD" })
  map("n", "<Leader>hD", gs.toggle_deleted, { desc = "Gitsigns toggle_deleted" })
  map("n", "<Leader>hq", gs.setqflist, { desc = "Gitsigns setqflist" })
  map("n", "<Leader>ha", gs.setloclist, { desc = "Gitsigns setloclist" })

  -- Text object
  map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

gitsigns.setup_config = function()
  require("gitsigns").setup({
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    on_attach = gitsigns.on_attach,
    watch_gitdir = {
      follow_files = true,
    },
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align",
      delay = 500,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    diff_opts = {
      internal = true,
    },
    preview_config = {
      border = "rounded",
    },
  })
end

gitsigns.setup = function()
  gitsigns.setup_config()
  -- gitsigns.nvim use fs_events instead of polling now.
  -- Ref: https://github.com/lewis6991/gitsigns.nvim/issues/823
end

return gitsigns
