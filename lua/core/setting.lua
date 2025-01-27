local plugin_utils = require("vimrc.plugin_utils")
local utils = require("vimrc.utils")

local settings = {}

-- TODO: Check mini.basics options
settings.setup_options = function()
  -- Vim basic setting {{{
  -- source custom mswin.vim
  if not plugin_utils.os_is("synology") then
    plugin_utils.source_in_vim_home("vimrc/mswin.vim")
  end
  -- }}}

  vim.opt.number = true
  vim.opt.hidden = true
  vim.opt.lazyredraw = true
  vim.opt.mouse = "nvi" -- NOTE: Test neovim 0.8 nightly popup-menu
  vim.opt.mousemodel = "popup_setpos"
  vim.opt.modeline = true
  vim.opt.updatetime = 200
  vim.opt.cursorline = true
  vim.opt.ruler = true -- show the cursor position all the time
  vim.opt.spell = true

  vim.go.timeout = true
  vim.go.timeoutlen = 300

  vim.opt.commentstring = "# %s" -- NOTE: Default is "# %s", set other 'commentstring' in ftplugin

  vim.opt.scrolloff = 0

  vim.opt.diffopt = {
    "internal",
    "filler",
    "vertical",
    "closeoff",
    "algorithm:histogram",
    "hiddenoff",
    "linematch:30",
    "indent-heuristic",
  }

  -- completion menu
  vim.opt.pumheight = 40
  vim.opt.pumblend = 0

  -- ignore pattern for wildmenu
  vim.opt.wildmenu = true
  vim.opt.wildignore:append({ "*.a", "*.o", "*.pyc", "*~", "*.swp", "*.tmp", "*.mypy_cache*", "*.min.js", "*.min.css" })
  vim.opt.wildmode = "full"
  vim.opt.wildoptions = { "pum", "tagfile" }

  -- fillchars
  vim.opt.fillchars = { diff = "⣿", fold = "-", vert = "│" }

  -- show hidden characters
  vim.opt.list = true
  -- NOTE: indent-blankline.nvim will override first charater of tab.
  -- So use second character to differentiate tab & space
  -- Use default for space to avoid Search highlight been override by Whitespace highlight
  vim.opt.listchars = { tab = "▸─", extends = "»", precedes = "«", nbsp = "␣", eol = "↴" }
  if utils.is_reader_mode() then
    -- Don't show trailing space in reader vim mode
    vim.opt.listchars:append({ trail = "•" })
  end

  vim.opt.laststatus = 2
  vim.opt.showcmd = true

  -- no distraction
  vim.opt.belloff = "all"

  -- Backup
  -- neovim has default folders for backup, undo, swap files
  -- Only move temporary files in vanilla vim
  -- TODO Use original backupdir and use other backupdir in Windows
  vim.g.backupdir = vim.env.HOME .. "/.local/share/nvim/backup"
  if vim.fn.isdirectory(vim.g.backupdir) == 0 then
    vim.fn.mkdir(vim.g.backupdir, "p")
  end

  vim.opt.backup = true -- keep a backup file (restore to previous version)
  vim.opt.backupdir = vim.g.backupdir .. ",."

  -- Persistent Undo
  vim.opt.undofile = true

  -- session options
  vim.opt.sessionoptions = {
    "blank",
    "buffers",
    "curdir",
    "help",
    "tabpages",
    "winsize",
    "winpos",
    "terminal",
  }

  -- misc
  if vim.fn.exists("+shellslash") == 1 then
    vim.opt.shellslash = true
  end
  vim.opt.splitkeep = "cursor"

  -- Complete
  if plugin_utils.get_dictionary() then
    vim.opt.dictionary = plugin_utils.get_dictionary()
  end

  -- Remove '=' from isfilename to complete filename in 'options'='filename' format
  -- TODO Move to ftplugin setting
  vim.opt.isfname:remove("=")

  -- Indent {{{
  vim.opt.smarttab = true
  vim.opt.expandtab = false
  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  vim.opt.autoindent = true
  -- Use cop instead
  -- vim.opt.pastetoggle = "<F10>"
  -- }}}

  -- Search {{{
  vim.opt.hlsearch = true
  vim.opt.ignorecase = true
  vim.opt.incsearch = true
  vim.opt.smartcase = true
  vim.opt.inccommand = "split"

  -- For builtin 'incsearch'
  vim.keymap.set({ "c" }, "<C-J>", "<C-G>", { noremap = true })
  vim.keymap.set({ "c" }, "<C-K>", "<C-T>", { noremap = true })
  -- }}}

  vim.opt.maxmempattern = 2000 -- 2000 KB

  -- Set terminal buffer size to 10000 (default: 10000)
  vim.opt.scrollback = 10000
end

settings.setup_option_toggle = function()
  vim.keymap.set("n", "cob", ":set buflisted!<CR>")
  vim.keymap.set("n", "coc", ":set termguicolors!<CR>")
  vim.keymap.set("n", "coe", ":set expandtab!<CR>")
  vim.keymap.set("n", "com", ":set modifiable!<CR>")
  vim.keymap.set("n", "coo", ":set readonly!<CR>")
  vim.keymap.set("n", "cop", ":set paste!<CR>")
  vim.keymap.set("n", "yoa", ":setlocal autoread!<CR>")

  vim.keymap.set("n", "codp", function()
    utils.toggle_list_option_flag(vim.opt.diffopt, "algorithm:patience")
  end, { noremap = true, desc = "Toggle diff algorithm:patience" })
  vim.keymap.set("n", "codh", function()
    utils.toggle_list_option_flag(vim.opt.diffopt, "algorithm:histogram")
  end, { noremap = true, desc = "Toggle diff algorithm:histogram" })
end

settings.setup_digraph = function()
  -- NOTE: Since nvim-cmp & LuaSnip use <C-K> for jumping to next expandable LuaSnip, we need to use
  -- <M-S-K> for digraph using it's fallback.
  -- FIXME: This is currently only works when copilot-cmp is enabled. Fix this

  -- These are already defined
  -- digraphs ,_ 12289 " '、'
  -- digraphs ._ 12290 " '。'
  vim.cmd([[digraphs ,- 65292 " '，']])
  vim.cmd([[digraphs ,: 65306 " '：']])
  vim.cmd([[digraphs ,; 65307 " '；']])
  vim.cmd([[digraphs .! 65281 " '！']])
  vim.cmd([[digraphs .? 65311 " '？']])
end

settings.setup = function()
  settings.setup_options()
  settings.setup_option_toggle()
  settings.setup_digraph()
end

return settings
