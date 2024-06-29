local ibl = require("ibl")
local hooks = require("ibl.hooks")

local choose = require("vimrc.choose")

local indent_blankline = {}

indent_blankline.line_threshold = 10000
indent_blankline.max_filesize = 1024 * 1024 -- 1 MB

indent_blankline.setup_config = function()
  ibl.setup({
    indent = {
      char = "│",
      tab_char = "│", -- NOTE: Use 'listchars' tab second character '─' to differentiate space & tab
    },
    scope = {
      enabled = choose.is_enabled_plugin("nvim-treesitter"),
    },
    exclude = {
      filetypes = {
        "any-jump",
        "checkhealth",
        "dashboard",
        "defx",
        "help",
        "floggraph",
        "fugitive",
        "git",
        "gitcommit",
        "gitrebase",
        "gitsendemail",
        "GV",
        "lspinfo",
        "man",
        "norg",
        "TeleScopePrompt",
        "TeleScopeResults",
        "",
      },
    },
  })

  hooks.register(
    hooks.type.ACTIVE,
    function(bufnr)
      -- max line check
      if vim.api.nvim_buf_line_count(bufnr) > indent_blankline.line_threshold then
        return false
      end

      -- max filesize check
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
      if ok and stats and stats.size > indent_blankline.max_filesize then
        return false
      end

      return true
    end
  )
end

indent_blankline.setup_mapping = function()
  nnoremap("<Space>il", ":IBLToggle<CR>")
  nnoremap("<Space>ir", ":IndentBlanklineRefresh<CR>")
end

indent_blankline.setup = function()
  indent_blankline.setup_config()
  indent_blankline.setup_mapping()
end

return indent_blankline
