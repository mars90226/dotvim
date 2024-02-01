local plugin_utils = require("vimrc.plugin_utils")

local tui = {}

tui.setup = function()
  local use_config = function(plugin_spec)
    -- TODO: Lazy load config
    plugin_spec.config()
  end

  -- Search keyword with Google using surfraw
  if vim.fn.executable("sr") == 1 then
    use_config({
      "mars90226/tui-sr",
      config = function()
        vim.api.nvim_create_user_command("GoogleKeyword", [[call vimrc#tui#google_keyword(<q-args>)]], { nargs = 1 })
        nnoremap("<Leader>gk", [[:execute 'GoogleKeyword ' . expand('<cword>')<CR>]])
      end,
    })
  end

  if vim.fn.executable("htop") == 1 then
    use_config({
      "mars90226/tui-htop",
      config = function()
        vim.api.nvim_create_user_command("Htop", [[call vimrc#tui#run('float', 'htop '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("HtopSplit", [[call vimrc#tui#run('new', 'htop '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Htop", ":Htop", 1 },
          { "HtopSplit", ":HtopSplit", 1 },
        })

        nnoremap("<Leader>ht", [[:Htop<CR>]])
      end,
    })
  end

  if vim.fn.executable("atop") == 1 then
    use_config({
      "mars90226/tui-atop",
      config = function()
        vim.api.nvim_create_user_command("Atop", [[call vimrc#tui#run('float', 'atop '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("AtopSplit", [[call vimrc#tui#run('new', 'atop '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Atop", ":Atop", 1 },
          { "AtopSplit", ":AtopSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("btm") == 1 then
    use_config({
      "mars90226/tui-btm",
      config = function()
        vim.api.nvim_create_user_command("Btm", [[call vimrc#tui#run('float', 'btm '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("BtmSplit", [[call vimrc#tui#run('new', 'btm '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Btm", ":Btm", 1 },
          { "BtmSplit", ":BtmSplit", 1 },
        })

        nnoremap("<Leader>bt", [[:Btm<CR>]])
      end,
    })
  end

  if vim.fn.executable("broot") == 1 then
    use_config({
      "mars90226/tui-broot",
      config = function()
        -- NOTE: vim-floaterm wrapper for broot need to update
        -- Change `broot --conf "/path/configs" --out "path/temp/file"`
        -- to `broot --conf "/path/configs" >> "path/temp/file"`
        -- Ref: https://github.com/voldikss/vim-floaterm/issues/364
        vim.api.nvim_create_user_command(
          "Broot",
          [[call vimrc#tui#run('float', 'broot -p '.<q-args>)]],
          { nargs = "*" }
        )
        vim.api.nvim_create_user_command(
          "BrootSplit",
          [[call vimrc#tui#run('vnew', 'broot -p '.<q-args>)]],
          { nargs = "*" }
        )
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Broot", ":Broot", 1 },
          { "BrootSplit", ":BrootSplit", 1 },
        })

        nnoremap("<Leader>br", [[:Broot<CR>]])
      end,
    })
  end

  if vim.fn.executable("ranger") == 1 then
    use_config({
      "mars90226/tui-ranger",
      config = function()
        vim.api.nvim_create_user_command("Ranger", [[call vimrc#tui#run('float', 'ranger '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command(
          "RangerSplit",
          [[call vimrc#tui#run('new', 'ranger '.<q-args>)]],
          { nargs = "*" }
        )
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Ranger", ":Ranger", 1 },
          { "RangerSplit", ":RangerSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("nnn") == 1 then
    use_config({
      "mars90226/tui-nnn",
      config = function()
        vim.api.nvim_create_user_command("Nnn", [[call vimrc#tui#run('float', 'nnn '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("NnnSplit", [[call vimrc#tui#run('new', 'nnn '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Nnn", ":Nnn", 1 },
          { "NnnSplit", ":NnnSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("vifm") == 1 then
    use_config({
      "mars90226/tui-vifm",
      config = function()
        -- NOTE: vifm.vim use :Vifm command
        vim.api.nvim_create_user_command(
          "VifmFloat",
          [[call vimrc#tui#run('float', 'vifm '.<q-args>)]],
          { nargs = "*" }
        )
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

        nnoremap("<Leader>vi", [[:VifmFloat<CR>]])
        nnoremap("<Leader>vd", [[:VifmDirFloat<CR>]])
        nnoremap("<Leader>vm", [[:VifmDirBMarks<CR>]])
      end,
    })
  end

  if vim.fn.executable("fff") == 1 then
    use_config({
      "mars90226/tui-fff",
      config = function()
        vim.api.nvim_create_user_command("Fff", [[call vimrc#tui#run('float', 'fff '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("FffSplit", [[call vimrc#tui#run('new', 'fff '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Fff", ":Fff", 1 },
          { "FffSplit", ":FffSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("lf") == 1 then
    use_config({
      "mars90226/tui-lf",
      config = function()
        vim.api.nvim_create_user_command("Lf", [[call vimrc#tui#run('float', 'lf '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("LfSplit", [[call vimrc#tui#run('new', 'lf '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Lf", ":Lf", 1 },
          { "LfSplit", ":LfSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("xplr") == 1 then
    use_config({
      "mars90226/tui-xplr",
      config = function()
        vim.api.nvim_create_user_command("Xplr", [[call vimrc#tui#run('float', 'xplr '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("XplrSplit", [[call vimrc#tui#run('new', 'xplr '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Xplr", ":Xplr", 1 },
          { "XplrSplit", ":XplrSplit", 1 },
        })

        nnoremap("<Leader>xp", [[:Xplr<CR>]])
      end,
    })
  end
  if vim.fn.executable("yazi") == 1 then
    use_config({
      "mars90226/tui-yazi",
      config = function()
        vim.api.nvim_create_user_command("Yazi", [[call vimrc#tui#run('float', 'yazi '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("YaziSplit", [[call vimrc#tui#run('new', 'yazi '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Yazi", ":Yazi", 1 },
          { "YaziSplit", ":YaziSplit", 1 },
        })

        nnoremap("<Leader>za", [[:Yazi<CR>]])
        nnoremap("<Leader>zA", [[:YaziSplit<CR>]])
      end,
    })
  end

  if vim.fn.executable("lazygit") == 1 then
    use_config({
      "mars90226/tui-lazygit",
      config = function()
        vim.api.nvim_create_user_command(
          "LazyGit",
          [[call vimrc#tui#run('float', 'lazygit '.<q-args>)]],
          { nargs = "*" }
        )
        vim.api.nvim_create_user_command(
          "LazyGitSplit",
          [[call vimrc#tui#run('new', 'lazygit '.<q-args>)]],
          { nargs = "*" }
        )
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "LazyGit", ":LazyGit", 1 },
          { "LazyGitSplit", ":LazyGitSplit", 1 },
        })

        nnoremap("<Leader>gz", [[:LazyGit<CR>]])
      end,
    })
  end

  if vim.fn.executable("gitui") == 1 then
    use_config({
      "mars90226/tui-gitui",
      config = function()
        local base_gitui_cmd = 'env GIT_EDITOR=$EDITOR gitui'
        vim.api.nvim_create_user_command("Gitui", [[call vimrc#tui#run('float', ']] .. base_gitui_cmd .. [[ '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command(
          "GituiSplit",
          [[call vimrc#tui#run('new', ']] .. base_gitui_cmd .. [[ '.<q-args>)]],
          { nargs = "*" }
        )
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Gitui", ":Gitui", 1 },
          { "GituiSplit", ":GituiSplit", 1 },
        })

        nnoremap("<Leader>gi", [[:Gitui<CR>]])
      end,
    })
  end

  if vim.fn.executable("bandwhich") == 1 then
    use_config({
      "mars90226/tui-bandwhich",
      config = function()
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
      end,
    })
  end

  if vim.fn.executable("jless") == 1 then
      use_config({
        "mars90226/tui-jless",
        config = function()
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
        end,
      })
    end

  -- TODO: Add tig

  -- Shells
  if vim.fn.executable("fish") == 1 then
    use_config({
      "mars90226/tui-fish",
      config = function()
        vim.api.nvim_create_user_command("Fish", [[call vimrc#tui#run('float', 'fish '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("FishSplit", [[call vimrc#tui#run('new', 'fish '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Fish", ":Fish", 1 },
          { "FishSplit", ":FishSplit", 1 },
        })
      end,
    })
  end

  if vim.fn.executable("zsh") == 1 then
    use_config({
      "mars90226/tui-zsh",
      config = function()
        vim.api.nvim_create_user_command("Zsh", [[call vimrc#tui#run('float', 'zsh '.<q-args>)]], { nargs = "*" })
        vim.api.nvim_create_user_command("ZshSplit", [[call vimrc#tui#run('new', 'zsh '.<q-args>)]], { nargs = "*" })
        require("vimrc.plugins.command_palette").insert_commands("TUI", {
          { "Zsh", ":Zsh", 1 },
          { "ZshSplit", ":ZshSplit", 1 },
        })
      end,
    })
  end
end

return tui
