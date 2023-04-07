local indent_blankline = {}

indent_blankline.line_threshold = 10000
indent_blankline.max_filesize = 1024 * 1024 -- 1 MB

indent_blankline.setup_config = function()
  require("indent_blankline").setup({
    char = "│",
    show_end_of_line = true,
    filetype_exclude = {
      "any-jump",
      "defx",
      "help",
      "floggraph",
      "fugitive",
      "git",
      "gitcommit",
      "gitrebase",
      "gitsendemail",
      "GV",
      "man",
      "norg",
    },
    buftype_exclude = { "nofile", "terminal" },
    -- TODO: Try disable for performance.
    -- indent-blankline.nvim still setup autocmd even if current buffer's 'show_current_context' is false.
    -- Ref: https://github.com/lukas-reineke/indent-blankline.nvim/issues/440
    show_current_context = true,
    show_current_context_start = true,
  })
end

indent_blankline.setup_mapping = function()
  -- Currently, there's no way to differentiate tab and space.
  -- The only way to differentiate is to disable indent-blankline.nvim
  -- temporarily.
  nnoremap("<Space>il", ":IndentBlanklineToggle<CR>")
  nnoremap("<Space>ir", ":IndentBlanklineRefresh<CR>")
end

indent_blankline.setup_autocmd = function()
  local augroup_id = vim.api.nvim_create_augroup("indent_blankline_settings", {})
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      local line_count = vim.api.nvim_buf_line_count(vim.api.nvim_get_current_buf())
      -- TODO: indent-blankline.nvim is still slow down even if these option are disabled.
      -- Maybe it's not disabled properly after the initial global enable.
      if line_count > indent_blankline.line_threshold then
        vim.b.indent_blankline_show_current_context = false
        vim.b.indent_blankline_show_current_context_start = false
        require("indent_blankline.commands").refresh()
      end
    end
  })
  vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
      if ok and stats and stats.size > indent_blankline.max_filesize then
        require("indent_blankline.commands").disable()
      end
    end
  })
end

indent_blankline.setup = function()
  indent_blankline.setup_config()
  indent_blankline.setup_mapping()
  indent_blankline.setup_autocmd()
end

return indent_blankline
