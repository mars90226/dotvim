local utils = require("vimrc.utils")

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
  indent = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          ["<Esc>"] = { "close", mode = { "n", "i" } },
          ["<C-O>"] = { function() vim.cmd([[stopinsert]]) end, mode = { "i" } },
          ["<C-T>"] = { "edit_tab", mode = { "i", "n" } }
        },
      },
      list = {
        keys = {
          ["<C-T>"] = "edit_tab",
        },
      }
    }
  },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true } -- Wrap notifications
    }
  },
  zen = { enabled = true },
}

my_snacks.keys = (function()
  -- NOTE: `<Space>s` is used by too many plugins
  local snacks_picker_prefix = "<Space>a"
  local snacks_picker_lsp_prefix = "<Space>al"

  return {
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

    -- Snacks picker
    { snacks_picker_prefix .. ",", function() Snacks.picker() end, desc = "Snacks picker" },
    { snacks_picker_prefix .. "b", function() Snacks.picker.buffers() end, desc = "Snacks Picker - Buffers" },
    { snacks_picker_prefix .. "i", function() Snacks.picker.grep() end, desc = "Snacks Picker - Live Grep" },
    { snacks_picker_prefix .. ":", function() Snacks.picker.command_history() end, desc = "Snacks Picker - Command History" },
    { snacks_picker_prefix .. "f", function() Snacks.picker.files() end, desc = "Snacks Picker - Find Files" },
    { snacks_picker_prefix .. "<CR>", function() Snacks.picker.smart() end, desc = "Snacks Picker - Smart" },
    -- find
    { snacks_picker_prefix .. "C", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Snacks Picker - Find Config File" },
    { snacks_picker_prefix .. "g", function() Snacks.picker.git_files() end, desc = "Snacks Picker - Find Git Files" },
    { snacks_picker_prefix .. "o", function() Snacks.picker.recent() end, desc = "Snacks Picker - Recent" },
    -- git
    { snacks_picker_prefix .. "B", function() Snacks.picker.git_branches() end, desc = "Snacks Picker - Git Branches" },
    { snacks_picker_prefix .. "c", function() Snacks.picker.git_log() end, desc = "Snacks Picker - Git Log" },
    { snacks_picker_prefix .. "s", function() Snacks.picker.git_status() end, desc = "Snacks Picker - Git Status" },
    { snacks_picker_prefix .. "d", function() Snacks.picker.git_diff() end, desc = "Snacks Picker - Git Diff" },
    { snacks_picker_prefix .. "H", function() Snacks.picker.git_stash() end, desc = "Snacks Picker - Git Stash" },
    -- Grep
    { snacks_picker_prefix .. "ll", function() Snacks.picker.lines() end, desc = "Snacks Picker - Buffer Lines" },
    { snacks_picker_prefix .. "L", function() Snacks.picker.grep_buffers() end, desc = "Snacks Picker - Grep Open Buffers" },
    { snacks_picker_prefix .. "k", function() Snacks.picker.grep_word() end, desc = "Snacks Picker - Visual selection or word", mode = { "n", "x" } },
    -- search
    { snacks_picker_prefix .. '"', function() Snacks.picker.registers() end, desc = "Snacks Picker - Registers" },
    { snacks_picker_prefix .. "A", function() Snacks.picker.autocmds() end, desc = "Snacks Picker - Autocmds" },
    { snacks_picker_prefix .. ";", function() Snacks.picker.commands() end, desc = "Snacks Picker - Commands" },
    { snacks_picker_prefix .. "x", function() Snacks.picker.diagnostics() end, desc = "Snacks Picker - Diagnostics" },
    { snacks_picker_prefix .. "X", function() Snacks.picker.diagnostics_buffer() end, desc = "Snacks Picker - Diagnostics Buffer" },
    { snacks_picker_prefix .. "h", function() Snacks.picker.help() end, desc = "Snacks Picker - Help Pages" },
    { snacks_picker_prefix .. "Y", function() Snacks.picker.highlights() end, desc = "Snacks Picker - Highlights" },
    { snacks_picker_prefix .. "I", function() Snacks.picker.icons() end, desc = "Snacks Picker - Icons" },
    { snacks_picker_prefix .. "j", function() Snacks.picker.jumps() end, desc = "Snacks Picker - Jumps" },
    { snacks_picker_prefix .. "<Tab>", function() Snacks.picker.keymaps() end, desc = "Snacks Picker - Keymaps" },
    { snacks_picker_prefix .. "a", function() Snacks.picker.loclist() end, desc = "Snacks Picker - Location List" },
    { snacks_picker_prefix .. "<F1>", function() Snacks.picker.man() end, desc = "Snacks Picker - Man Pages" },
    { snacks_picker_prefix .. "'", function() Snacks.picker.marks() end, desc = "Snacks Picker - Marks" },
    { snacks_picker_prefix .. "n", function() Snacks.picker.notifications() end, desc = "Snacks Picker - Explorer" },
    { snacks_picker_prefix .. "u", function() Snacks.picker.resume() end, desc = "Snacks Picker - Resume" },
    { snacks_picker_prefix .. "q", function() Snacks.picker.qflist() end, desc = "Snacks Picker - Quickfix List" },
    { snacks_picker_prefix .. "v", function() Snacks.picker.colorschemes() end, desc = "Snacks Picker - Colorschemes" },
    { snacks_picker_prefix .. "p", function() Snacks.picker.projects() end, desc = "Snacks Picker - Projects" },
    { snacks_picker_prefix .. "=", function() Snacks.picker.cliphist() end, desc = "Snacks Picker - System Clipboard History" },
    { snacks_picker_prefix .. "/", function() Snacks.picker.search_history() end, desc = "Snacks Picker - Search History" },
    { snacks_picker_prefix .. "S", function() Snacks.picker.spelling() end, desc = "Snacks Picker - Spelling" },
    { snacks_picker_prefix .. "U", function() Snacks.picker.undo() end, desc = "Snacks Picker - Undo" },
    { snacks_picker_prefix .. "z", function() Snacks.picker.zoxide() end, desc = "Snacks Picker - Zoxide" },
    {
      snacks_picker_prefix .. "0",
      function()
        Snacks.picker.explorer({
          win = {
            input = {
              keys = {
                -- Exit to normal mode on ESC
                ["<Esc>"] = "close",
              },
            },
          },
        })
      end,
      desc = "Snacks Picker - Explorer"
    },
    -- LSP
    { snacks_picker_lsp_prefix .. "d", function() Snacks.picker.lsp_definitions() end, desc = "Snacks Picker - Goto Definition" },
    { snacks_picker_lsp_prefix .. "D", function() Snacks.picker.lsp_declarations() end, desc = "Snacks Picker - Goto Declaration" },
    { snacks_picker_lsp_prefix .. "r", function() Snacks.picker.lsp_references() end, nowait = true, desc = "Snacks Picker - References" },
    { snacks_picker_lsp_prefix .. "I", function() Snacks.picker.lsp_implementations() end, desc = "Snacks Picker - Goto Implementation" },
    { snacks_picker_lsp_prefix .. "y", function() Snacks.picker.lsp_type_definitions() end, desc = "Snacks Picker - Goto Type Definition" },
    { snacks_picker_lsp_prefix .. "o", function() Snacks.picker.lsp_symbols() end, desc = "Snacks Picker - LSP Symbols" },
    { snacks_picker_lsp_prefix .. "s", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Snacks Picker - LSP Workspace Symbols" },

    -- Custom Grep
    {
      snacks_picker_prefix .. "r",
      function()
        Snacks.picker.grep({
          search = utils.input("Grep: "),
          regex = true,
          live = false,
          supports_live = false,
        })
      end,
      desc = "Snacks Picker - Grep",
    },
  }
end)()

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
