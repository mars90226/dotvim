local ufo = {}

ufo.enable_treesitter = false
ufo.default_providers = { "lsp", "indent" }
ufo.with_treesitter_providers = { "lsp", "treesitter", "indent" }

ufo.toggle_treesitter = function()
  ufo.enable_treesitter = not ufo.enable_treesitter
end

ufo.provider_selector = function(bufnr, filetype, buftype)
  return ufo.enable_treesitter and ufo.with_treesitter_providers or ufo.default_providers
end

ufo.fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

ufo.setup = function()
  local origin_ufo = require("ufo")

  -- TODO: Display fold symbol in foldcolumn
  -- Ref: https://github.com/kevinhwang91/nvim-ufo/issues/4#issuecomment-1157716294
  vim.wo.foldcolumn = "1"
  vim.wo.foldlevel = 99 -- feel free to decrease the value
  vim.wo.foldenable = true
  vim.o.foldlevelstart = 99

  origin_ufo.setup({
    open_fold_hl_timeout = 150,
    -- FIXME: Disabled due to error: `Error executing vim.schedule lua callback: UnhandledPromiseRejection with the reason:`
    -- close_fold_kinds_for_ft = { "imports", "comment" },
    close_fold_kinds_for_ft = {},
    fold_virt_text_handler = ufo.fold_virt_text_handler,
    provider_selector = ufo.provider_selector,
    preview = {
      win_config = {
        winhighlight = "Normal:OpaqueNormal,NormalFloat:OpaqueNormalFloat",
      },
    },
  })

  vim.keymap.set("n", "<F10>", function()
    ufo.toggle_treesitter()
  end)

  vim.keymap.set("n", "zR", origin_ufo.openAllFolds)
  vim.keymap.set("n", "zM", origin_ufo.closeAllFolds)
  vim.keymap.set("n", "zr", origin_ufo.openFoldsExceptKinds)
  vim.keymap.set("n", "zm", origin_ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  vim.keymap.set("n", "K", function()
    local winid = origin_ufo.peekFoldedLinesUnderCursor()
    if not winid then
      -- fallback to 'keywordprg'
      vim.api.nvim_feedkeys("K", "n", false)
    end
  end)

  -- Performance trick
  -- Ref: nvim_treesitter.lua performance trick
  local augroup_id = vim.api.nvim_create_augroup("nvim_ufo_settings", {})
  vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      vim.cmd([[UfoEnable]])
    end,
  })
  vim.api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, {
    group = augroup_id,
    pattern = "*",
    callback = function()
      vim.cmd([[UfoDisable]])
    end,
  })

  -- Disable on FileType
  local disabled_filetypes = { "dashboard", "man", "snacks_dashboard" }
  -- Disable fold if current buffer is in disabled_filetypes
  if vim.list_contains(disabled_filetypes, vim.api.nvim_buf_get_option(0, "filetype")) then
    vim.wo[0].foldenable = false
    vim.wo[0].foldcolumn = "0"
  end
  -- Disable fold for future buffers in disabled_filetypes
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup_id,
    pattern = disabled_filetypes,
    callback = function()
      -- TODO: Check if we need fold, but not foldcolumn by nvim-ufo.
      origin_ufo.detach()
      vim.wo.foldenable = false
      vim.wo.foldcolumn = "0"
    end,
  })

  -- TODO: UfoDetach on huge file
end

return ufo
