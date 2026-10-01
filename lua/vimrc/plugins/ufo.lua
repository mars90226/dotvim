local choose = require("vimrc.choose")

local ufo = {}

ufo.enable_treesitter = choose.is_enabled_plugin("nvim-treesitter")
ufo.default_providers = { "lsp", "indent" }
ufo.with_treesitter_providers = { "treesitter", "indent" }

ufo.toggle_treesitter = function()
  ufo.enable_treesitter = not ufo.enable_treesitter
end

ufo.provider_selector = function(bufnr, filetype, buftype)
  return ufo.enable_treesitter and ufo.with_treesitter_providers or ufo.default_providers
end

ufo.fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
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

  -- Keep UFO enabled across focus changes: it is event-driven, and repeated
  -- teardown can leave a deleted augroup behind if cleanup fails midway.
  local augroup_id = vim.api.nvim_create_augroup("nvim_ufo_settings", {})

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
