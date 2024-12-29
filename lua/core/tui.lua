local plugin_utils = require("vimrc.plugin_utils")

local tui = {}

tui.setup = function()
  -- TODO: Lazy load config

  -- Search keyword with Google using surfraw
  if plugin_utils.is_executable("sr") then
    vim.api.nvim_create_user_command("GoogleKeyword", [[call vimrc#tui#google_keyword(<q-args>)]], { nargs = 1 })
    vim.keymap.set("n", "<Leader>gk", [[:execute 'GoogleKeyword ' . expand('<cword>')<CR>]])
  end

  if plugin_utils.is_executable("htop") then
    vim.api.nvim_create_user_command("Htop", [[call vimrc#tui#run('float', 'htop '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("HtopSplit", [[call vimrc#tui#run('new', 'htop '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Htop", ":Htop", 1 },
      { "HtopSplit", ":HtopSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>ht", [[:Htop<CR>]])
  end

  if plugin_utils.is_executable("atop") then
    vim.api.nvim_create_user_command("Atop", [[call vimrc#tui#run('float', 'atop '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("AtopSplit", [[call vimrc#tui#run('new', 'atop '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Atop", ":Atop", 1 },
      { "AtopSplit", ":AtopSplit", 1 },
    })
  end

  if plugin_utils.is_executable("btm") then
    vim.api.nvim_create_user_command("Btm", [[call vimrc#tui#run('float', 'btm '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("BtmSplit", [[call vimrc#tui#run('new', 'btm '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Btm", ":Btm", 1 },
      { "BtmSplit", ":BtmSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>bt", [[:Btm<CR>]])
  end

  if plugin_utils.is_executable("broot") then
    -- NOTE: vim-floaterm wrapper for broot need to update
    -- Change `broot --conf "/path/configs" --out "path/temp/file"`
    -- to `broot --conf "/path/configs" >> "path/temp/file"`
    -- Ref: https://github.com/voldikss/vim-floaterm/issues/364
    vim.api.nvim_create_user_command("Broot", [[call vimrc#tui#run('float', 'broot -p '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command(
      "BrootSplit",
      [[call vimrc#tui#run('vnew', 'broot -p '.<q-args>)]],
      { nargs = "*" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Broot", ":Broot", 1 },
      { "BrootSplit", ":BrootSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>br", [[:Broot<CR>]])
  end

  if plugin_utils.is_executable("ranger") then
    vim.api.nvim_create_user_command("Ranger", [[call vimrc#tui#run('float', 'ranger '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("RangerSplit", [[call vimrc#tui#run('new', 'ranger '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Ranger", ":Ranger", 1 },
      { "RangerSplit", ":RangerSplit", 1 },
    })
  end

  if plugin_utils.is_executable("nnn") then
    vim.api.nvim_create_user_command("Nnn", [[call vimrc#tui#run('float', 'nnn '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("NnnSplit", [[call vimrc#tui#run('new', 'nnn '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Nnn", ":Nnn", 1 },
      { "NnnSplit", ":NnnSplit", 1 },
    })
  end

  if plugin_utils.is_executable("vifm") then
    -- NOTE: vifm.vim use :Vifm command
    vim.api.nvim_create_user_command("VifmFloat", [[call vimrc#tui#run('float', 'vifm '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("VifmSplit", [[call vimrc#tui#run('new', 'vifm '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command(
      "VifmDirFloat",
      [[call vimrc#tui#run('float', 'vifm_dir '.<q-args>)]],
      { nargs = "*" }
    )
    vim.api.nvim_create_user_command(
      "VifmDirBMarks",
      [[call vimrc#tui#run('float', 'vifm_dir +bmarks '.<q-args>)]],
      { nargs = "*" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Vifm", ":Vifm", 1 },
      { "VifmSplit", ":VifmSplit", 1 },
      { "VifmDir", ":VifmDirFloat", 1 },
      { "VifmDirSplit", ":VifmDirSplit", 1 },
      { "VifmDirBMarks", ":VifmDirBMarks", 1 },
    })

    vim.keymap.set("n", "<Leader>vi", [[:VifmFloat<CR>]])
    vim.keymap.set("n", "<Leader>vd", [[:VifmDirFloat<CR>]])
    vim.keymap.set("n", "<Leader>vm", [[:VifmDirBMarks<CR>]])
  end

  if plugin_utils.is_executable("fff") then
    vim.api.nvim_create_user_command("Fff", [[call vimrc#tui#run('float', 'fff '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("FffSplit", [[call vimrc#tui#run('new', 'fff '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Fff", ":Fff", 1 },
      { "FffSplit", ":FffSplit", 1 },
    })
  end

  if plugin_utils.is_executable("lf") then
    vim.api.nvim_create_user_command("Lf", [[call vimrc#tui#run('float', 'lf '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("LfSplit", [[call vimrc#tui#run('new', 'lf '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Lf", ":Lf", 1 },
      { "LfSplit", ":LfSplit", 1 },
    })
  end

  if plugin_utils.is_executable("xplr") then
    vim.api.nvim_create_user_command("Xplr", [[call vimrc#tui#run('float', 'xplr '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("XplrSplit", [[call vimrc#tui#run('new', 'xplr '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Xplr", ":Xplr", 1 },
      { "XplrSplit", ":XplrSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>xp", [[:Xplr<CR>]])
  end

  if plugin_utils.is_executable("yazi") then
    vim.api.nvim_create_user_command("Yazi", [[call vimrc#tui#run('float', 'yazi '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("YaziSplit", [[call vimrc#tui#run('new', 'yazi '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Yazi", ":Yazi", 1 },
      { "YaziSplit", ":YaziSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>zA", [[:Yazi<CR>]])
    vim.keymap.set("n", "<Leader>zs", [[:YaziSplit<CR>]])
  end

  if plugin_utils.is_executable("lazygit") then
    vim.api.nvim_create_user_command("LazyGit", [[call vimrc#tui#run('float', 'lazygit '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command(
      "LazyGitSplit",
      [[call vimrc#tui#run('new', 'lazygit '.<q-args>)]],
      { nargs = "*" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "LazyGit", ":LazyGit", 1 },
      { "LazyGitSplit", ":LazyGitSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>gz", [[:LazyGit<CR>]])
  end

  if plugin_utils.is_executable("gitui") then
    local base_gitui_cmd = "env GIT_EDITOR=$EDITOR gitui"
    vim.api.nvim_create_user_command(
      "Gitui",
      [[call vimrc#tui#run('float', ']] .. base_gitui_cmd .. [[ '.<q-args>)]],
      { nargs = "*" }
    )
    vim.api.nvim_create_user_command(
      "GituiSplit",
      [[call vimrc#tui#run('new', ']] .. base_gitui_cmd .. [[ '.<q-args>)]],
      { nargs = "*" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Gitui", ":Gitui", 1 },
      { "GituiSplit", ":GituiSplit", 1 },
    })

    vim.keymap.set("n", "<Leader>gi", [[:Gitui<CR>]])
  end

  if plugin_utils.is_executable("bandwhich") then
    vim.api.nvim_create_user_command(
      "Bandwhich",
      [[call vimrc#tui#run('float', 'bandwhich '.<q-args>)]],
      { nargs = "*" }
    )
    vim.api.nvim_create_user_command(
      "BandwhichSplit",
      [[call vimrc#tui#run('new', 'bandwhich '.<q-args>)]],
      { nargs = "*" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Bandwhich", ":Bandwhich", 1 },
      { "BandwhichSplit", ":BandwhichSplit", 1 },
    })
  end

  if plugin_utils.is_executable("jless") then
    vim.api.nvim_create_user_command(
      "Jless",
      [[call vimrc#tui#run('float', 'jless '.<q-args>)]],
      { nargs = "*", complete = "file" }
    )
    vim.api.nvim_create_user_command(
      "JlessSplit",
      [[call vimrc#tui#run('new', 'jless '.<q-args>)]],
      { nargs = "*", complete = "file" }
    )
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Jless", ":Jless", 1 },
      { "JlessSplit", ":JlessSplit", 1 },
    })
  end

  if plugin_utils.is_executable("mprocs") then
    vim.api.nvim_create_user_command("Mprocs", [[call vimrc#tui#run('float', 'mprocs '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("MprocsSplit", [[call vimrc#tui#run('new', 'mprocs '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Mprocs", ":Mprocs", 1 },
      { "MprocsSplit", ":MprocsSplit", 1 },
      { "Mprocs --npm", ":Mprocs --npm", 1 },
      { "MprocsSplit --npm", ":MprocsSplit --npm", 1 },
    })

    vim.keymap.set("n", "<Leader>mp", [[:Mprocs<CR>]])
    vim.keymap.set("n", "<Leader>mP", [[:MprocsSplit<CR>]])
    vim.keymap.set("n", "<Leader>mn", [[:Mprocs --npm<CR>]])
    vim.keymap.set("n", "<Leader>mN", [[:MprocsSplit --npm<CR>]])
  end

  -- TODO: Add tig

  -- Shells
  if plugin_utils.is_executable("fish") then
    vim.api.nvim_create_user_command("Fish", [[call vimrc#tui#run('float', 'fish '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("FishSplit", [[call vimrc#tui#run('new', 'fish '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Fish", ":Fish", 1 },
      { "FishSplit", ":FishSplit", 1 },
    })
  end

  if plugin_utils.is_executable("zsh") then
    vim.api.nvim_create_user_command("Zsh", [[call vimrc#tui#run('float', 'zsh '.<q-args>)]], { nargs = "*" })
    vim.api.nvim_create_user_command("ZshSplit", [[call vimrc#tui#run('new', 'zsh '.<q-args>)]], { nargs = "*" })
    require("vimrc.plugins.command_palette").insert_commands("TUI", {
      { "Zsh", ":Zsh", 1 },
      { "ZshSplit", ":ZshSplit", 1 },
    })
  end
end

return tui
