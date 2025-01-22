local choose = require("vimrc.choose")

local my_snacks = {}

---@type snacks.Config
my_snacks.opts = {
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      header = [[
███╗   ███╗ █████╗ ██████╗ ███████╗██╗   ██╗██╗███╗   ███╗
████╗ ████║██╔══██╗██╔══██╗██╔════╝██║   ██║██║████╗ ████║
██╔████╔██║███████║██████╔╝███████╗██║   ██║██║██╔████╔██║
██║╚██╔╝██║██╔══██║██╔══██╗╚════██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚═╝ ██║██║  ██║██║  ██║███████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    },
  },
  -- NOTE: Currently, it cannot differentiate space & tab and do not respect 'listchars' tab second character '─'
  indent = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = choose.is_enabled_plugin("snacks.nvim-statuscolumn") },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true } -- Wrap notifications
    }
  },
  zen = { enabled = true },
}

my_snacks.keys = {
  { "<Leader>.",          function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
  { "<Leader>S",          function() Snacks.scratch.select() end,          desc = "Select Scratch Buffer" },
  { "<Leader>nn",         function() Snacks.notifier.show_history() end,   desc = "Notification History" },
  { "<Leader>bd",         function() Snacks.bufdelete() end,               desc = "Delete Buffer" },
  { "<Leader>cR",         function() Snacks.rename.rename_file() end,      desc = "Rename File" },

  -- TODO: Use better key mappings
  { "<Leader><Leader>gB", function() Snacks.gitbrowse() end,               desc = "Git Browse" },
  { "<Leader><Leader>gb", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
  { "<Leader><Leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
  { "<Leader><Leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
  { "<Leader><Leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },

  { "<Leader>un",         function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },
  { "<C-/>",              function() Snacks.terminal() end,                desc = "Toggle Terminal" },
  { "<C-_>",              function() Snacks.terminal() end,                desc = "which_key_ignore" },
  { "]]",                 function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",              mode = { "n", "t" } },
  { "[[",                 function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",              mode = { "n", "t" } },
  {
    "<leader>N",
    desc = "Neovim News",
    function()
      Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
          spell = false,
          wrap = false,
          signcolumn = "yes",
          statuscolumn = " ",
          conceallevel = 3,
        },
      })
    end,
  },
  { "<Leader>zm", function() Snacks.zen() end,             desc = "Zen Mode" },
  { "<Leader>zc", function() vim.cmd([[ZenModeCopy]]) end, desc = "Zen Mode Copy" },
  { "<Space>s;",  function() Snacks.picker() end,          desc = "Snacks picker" },
}

my_snacks.setup = function(opts)
  require("snacks").setup(opts)

  -- CTRL-L with nvim default behavior & dismiss notifications
  -- NOTE: This may break after reloading config
  local default_ctrl_l = vim.fn.maparg("<C-L>", "n", false, true)
  vim.keymap.set("n", "<C-L>", default_ctrl_l.rhs .. [[<Cmd>lua Snacks.notifier.hide()<CR>]], { silent = true })

  vim.api.nvim_create_user_command("ZenModeCopy", function()
    Snacks.zen.zen({
      toggles = {
        dim = false,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
        indent = false,
        line_number = false,
      }
    })
    vim.wo.statuscolumn = ""
    vim.wo.winbar = ""
    vim.wo.list = not vim.wo.list
    vim.wo.signcolumn = "no"
    vim.cmd([[silent! BlockOff]])
  end, {})
end

return my_snacks
