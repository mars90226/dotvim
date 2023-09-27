local gitsigns = {}

gitsigns.on_attach = function(bufnr)
  local gs = require("gitsigns")

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map("n", "]h", function()
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Gitsigns next_hunk" })

  map("n", "[h", function()
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
  map("n", "<Leader>htb", gs.toggle_current_line_blame, { desc = "Gitsigns toggle_current_line_blame" })
  map("n", "<Leader>hd", gs.diffthis, { desc = "Gitsigns diffthis" })
  map("n", "<Leader>hD", function()
    gs.diffthis("~")
  end, { desc = "Gitsigns diffthis with parent of HEAD" })
  map("n", "<Leader>htd", gs.toggle_deleted, { desc = "Gitsigns toggle_deleted" })
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
      virt_text_pos = "eol",
      delay = 500,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    diff_opts = {
      internal = true,
    },
  })
end

-- FIXME: Cannot actually make gitsigns.nvim not watching, or even triggering `update_cwd_head`. The
-- debounce function is not called when using autocmd to trigger DirChanged autocmd.
gitsigns.setup_performance_trick = function()
  -- NOTE: Change directory to non-git folder to avoid gitsigns watching .git on background
  -- Assuming the buffer before FocusLost and the buffer after FocusGained are the same.
  -- TODO: Monitor this to check if there's weird directory change and cause problem
  -- This may cause remote sending command to neovim not working.
  local origin_working_folder = ""
  local tmp_working_folder = vim.fn.stdpath('state')
  local gitsigns_augroup_id = vim.api.nvim_create_augroup("gitsigns_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = gitsigns_augroup_id,
    pattern = "*",
    nested = true, -- NOTE: To allow gitsigns.nvim to execute DirChanged autocmd
    callback = function()
      vim.schedule_wrap(function()
        if origin_working_folder ~= '' then
          vim.fn.chdir(origin_working_folder)
        end
      end)
    end,
  })
  vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
    group = gitsigns_augroup_id,
    pattern = "*",
    nested = true, -- NOTE: To allow gitsigns.nvim to execute DirChanged autocmd
    callback = function()
      vim.schedule_wrap(function()
        origin_working_folder = vim.fn.getcwd()
        vim.fn.chdir(tmp_working_folder)
      end)
    end,
  })
end

gitsigns.setup = function()
  gitsigns.setup_config()
  -- FIXME: Fix this
  -- gitsigns.setup_performance_trick()
end

return gitsigns
