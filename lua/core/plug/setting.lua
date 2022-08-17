local plugin_utils = require("vimrc.plugin_utils")

local settings = {}

settings.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  use_config({
    "mars90226/setting",
    config = function()
      local plugin_utils = require("vimrc.plugin_utils")

      -- Vim basic setting {{{
      -- source custom mswin.vim
      if vim.fn["vimrc#plugin#check#get_os"]() ~= "synology" then
        vim.fn["vimrc#source"]("vimrc/mswin.vim")
        vim.cmd([[behave xterm]])
      end
      -- }}}

      vim.opt.number = true
      vim.opt.hidden = true
      vim.opt.lazyredraw = true
      vim.opt.mouse = "nvi" -- NOTE: Test neovim 0.8 nightly popup-menu
      vim.opt.mousemodel = "popup_setpos"
      vim.opt.modeline = true
      -- This config affect CursorHold event trigger time, default: 4000
      -- Avoid being to small to avoid multiple CursorHold event triggered when
      -- moving cursor fastly.
      -- NOTE: CursorHold updatetime is managed by FixCursorHold.nvim, so don't
      -- change 'updatetime'.
      -- vim.opt.updatetime = 300
      vim.opt.updatetime = 4000
      vim.opt.cursorline = true
      vim.opt.ruler = true -- show the cursor position all the time
      -- TODO: Remove this comment when neovim bug fixed
      -- Fix neovim VimResized bug: https://github.com/neovim/neovim/issues/12432
      -- vim.opt.display:remove("msgsep")

      vim.opt.scrolloff = 0

      vim.opt.diffopt = { "internal", "filler", "vertical", "closeoff", "algorithm:histogram", "hiddenoff" }

      -- completion menu
      vim.opt.pumheight = 40
      vim.opt.pumblend = 0

      -- ignore pattern for wildmenu
      vim.opt.wildmenu = true
      vim.opt.wildignore:append({ "*.a", "*.o", "*.pyc", "*~", "*.swp", "*.tmp" })
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
      if vim.fn["vimrc#get_vim_mode"]() ~= "reader" then
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
        "folds",
        "help",
        "tabpages",
        "winsize",
        "winpos",
        "terminal",
      }

      -- misc
      vim.opt.shellslash = true

      -- Complete
      vim.opt.dictionary = "/usr/share/dict/words"

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
    end,
  })
end

return settings
