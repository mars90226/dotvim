local plugin_utils = require("vimrc.plugin_utils")

local tui = {}

tui.startup = function(use)
  local use_config = function(plugin_spec)
    plugin_utils.use_config(use, plugin_spec)
  end

  -- Search keyword with Google using surfraw
  if vim.fn.executable("sr") == 1 then
    use_config({
      "mars90226/tui-sr",
      config = function()
        vim.cmd([[command! -nargs=1 GoogleKeyword call vimrc#tui#google_keyword(<q-args>)]])
        nnoremap("<Leader>gk", [[:execute 'GoogleKeyword ' . expand('<cword>')<CR>]])
      end,
    })
  end

  if vim.fn.executable("htop") == 1 then
    use_config({
      "mars90226/tui-hop",
      config = function()
        vim.cmd([[command! -nargs=* Htop        call vimrc#tui#run('float', 'htop '.<q-args>)]])
        vim.cmd([[command! -nargs=* HtopSplit   call vimrc#tui#run('new', 'htop '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Htop", { exec = "Htop" })
        vim.fn["vimrc#fuzzymenu#try_add"]("HtopSplit", { exec = "HtopSplit" })

        nnoremap("<Leader>ht", [[:Htop<CR>]])
      end,
    })
  end

  if vim.fn.executable("atop") == 1 then
    use_config({
      "mars90226/tui-atop",
      config = function()
        vim.cmd([[command! -nargs=* Atop        call vimrc#tui#run('float', 'atop '.<q-args>)]])
        vim.cmd([[command! -nargs=* AtopSplit   call vimrc#tui#run('new', 'atop '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Atop", { exec = "Atop" })
        vim.fn["vimrc#fuzzymenu#try_add"]("AtopSplit", { exec = "AtopSplit" })
      end,
    })
  end

  if vim.fn.executable("btm") == 1 then
    use_config({
      "mars90226/tui-btm",
      config = function()
        vim.cmd([[command! -nargs=* Btm         call vimrc#tui#run('float', 'btm '.<q-args>)]])
        vim.cmd([[command! -nargs=* BtmSplit    call vimrc#tui#run('new', 'btm '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Btm", { exec = "Btm" })
        vim.fn["vimrc#fuzzymenu#try_add"]("BtmSplit", { exec = "BtmSplit" })

        nnoremap("<Leader>bt", [[:Btm<CR>]])
      end,
    })
  end

  if vim.fn.executable("broot") == 1 then
    use_config({
      "mars90226/tui-broot",
      config = function()
        vim.cmd([[command! -nargs=* Broot       call vimrc#tui#run('float', 'broot -p '.<q-args>)]])
        vim.cmd([[command! -nargs=* BrootSplit  call vimrc#tui#run('vnew', 'broot -p '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Broot", { exec = "Broot" })
        vim.fn["vimrc#fuzzymenu#try_add"]("BrootSplit", { exec = "BrootSplit" })

        nnoremap("<Leader>br", [[:Broot<CR>]])
      end,
    })
  end

  if vim.fn.executable("ranger") == 1 then
    use_config({
      "mars90226/tui-ranger",
      config = function()
        vim.cmd([[command! -nargs=* Ranger      call vimrc#tui#run('float', 'ranger '.<q-args>)]])
        vim.cmd([[command! -nargs=* RangerSplit call vimrc#tui#run('new', 'ranger '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Ranger", { exec = "Ranger" })
        vim.fn["vimrc#fuzzymenu#try_add"]("RangerSplit", { exec = "RangerSplit" })
      end,
    })
  end

  if vim.fn.executable("nnn") == 1 then
    use_config({
      "mars90226/tui-nnn",
      config = function()
        vim.cmd([[command! -nargs=* Nnn         call vimrc#tui#run('float', 'nnn '.<q-args>)]])
        vim.cmd([[command! -nargs=* NnnSplit    call vimrc#tui#run('new', 'nnn '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Nnn", { exec = "Nnn" })
        vim.fn["vimrc#fuzzymenu#try_add"]("NnnSplit", { exec = "NnnSplit" })
      end,
    })
  end

  if vim.fn.executable("vifm") == 1 then
    use_config({
      "mars90226/tui-vifm",
      config = function()
        vim.cmd([[command! -nargs=* Vifm        call vimrc#tui#run('float', 'vifm '.<q-args>)]])
        vim.cmd([[command! -nargs=* VifmSplit   call vimrc#tui#run('new', 'vifm '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Vifm", { exec = "Vifm" })
        vim.fn["vimrc#fuzzymenu#try_add"]("VifmSplit", { exec = "VifmSplit" })
      end,
    })
  end

  if vim.fn.executable("fff") == 1 then
    use_config({
      "mars90226/tui-fff",
      config = function()
        vim.cmd([[command! -nargs=* Fff         call vimrc#tui#run('float', 'fff '.<q-args>)]])
        vim.cmd([[command! -nargs=* FffSplit    call vimrc#tui#run('new', 'fff '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Fff", { exec = "Fff" })
        vim.fn["vimrc#fuzzymenu#try_add"]("FffSplit", { exec = "FffSplit" })
      end,
    })
  end

  if vim.fn.executable("lf") == 1 then
    use_config({
      "mars90226/tui-lf",
      config = function()
        vim.cmd([[command! -nargs=* Lf          call vimrc#tui#run('float', 'lf '.<q-args>)]])
        vim.cmd([[command! -nargs=* LfSplit     call vimrc#tui#run('new', 'lf '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Lf", { exec = "Lf" })
        vim.fn["vimrc#fuzzymenu#try_add"]("LfSplit", { exec = "LfSplit" })
      end,
    })
  end

  if vim.fn.executable("xplr") == 1 then
    use_config({
      "mars90226/tui-xplr",
      config = function()
        vim.cmd([[command! -nargs=* Xplr          call vimrc#tui#run('float', 'xplr '.<q-args>)]])
        vim.cmd([[command! -nargs=* XplrSplit     call vimrc#tui#run('new', 'xplr '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Xplr", { exec = "Xplr" })
        vim.fn["vimrc#fuzzymenu#try_add"]("XplrSplit", { exec = "XplrSplit" })
      end,
    })
  end

  if vim.fn.executable("lazygit") == 1 then
    use_config({
      "mars90226/tui-lazygit",
      config = function()
        vim.cmd([[command! -nargs=* LazyGit      call vimrc#tui#run('float', 'lazygit '.<q-args>)]])
        vim.cmd([[command! -nargs=* LazyGitSplit call vimrc#tui#run('new', 'lazygit '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("LazyGit", { exec = "LazyGit" })
        vim.fn["vimrc#fuzzymenu#try_add"]("LazyGitSplit", { exec = "LazyGitSplit" })

        nnoremap("<Leader>gz", [[:LazyGit<CR>]])
      end,
    })
  end

  if vim.fn.executable("gitui") == 1 then
    use_config({
      "mars90226/tui-gitui",
      config = function()
        vim.cmd([[command! -nargs=* Gitui       call vimrc#tui#run('float', 'gitui '.<q-args>)]])
        vim.cmd([[command! -nargs=* GituiSplit  call vimrc#tui#run('new', 'gitui '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Gitui", { exec = "Gitui" })
        vim.fn["vimrc#fuzzymenu#try_add"]("GituiSplit", { exec = "GituiSplit" })

        nnoremap("<Leader>gi", [[:Gitui<CR>]])
      end,
    })
  end

  if vim.fn.executable("bandwhich") == 1 then
    use_config({
      "mars90226/tui-bandwhich",
      config = function()
        vim.cmd([[command! -nargs=* Bandwhich      call vimrc#tui#run('float', 'bandwhich '.<q-args>)]])
        vim.cmd([[command! -nargs=* BandwhichSplit call vimrc#tui#run('new', 'bandwhich '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Bandwhich", { exec = "Bandwhich" })
        vim.fn["vimrc#fuzzymenu#try_add"]("BandwhichSplit", { exec = "BandwhichSplit" })
      end,
    })
  end

  -- TODO: Add tig

  -- Shells
  if vim.fn.executable("fish") == 1 then
    use_config({
      "mars90226/tui-fish",
      config = function()
        vim.cmd([[command! -nargs=* Fish        call vimrc#tui#run('float', 'fish '.<q-args>)]])
        vim.cmd([[command! -nargs=* FishSplit   call vimrc#tui#run('new', 'fish '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Fish", { exec = "Fish" })
        vim.fn["vimrc#fuzzymenu#try_add"]("FishSplit", { exec = "FishSplit" })
      end,
    })
  end

  if vim.fn.executable("zsh") == 1 then
    use_config({
      "mars90226/tui-zsh",
      config = function()
        vim.cmd([[command! -nargs=* Zsh         call vimrc#tui#run('float', 'zsh '.<q-args>)]])
        vim.cmd([[command! -nargs=* ZshSplit    call vimrc#tui#run('new', 'zsh '.<q-args>)]])
        vim.fn["vimrc#fuzzymenu#try_add"]("Zsh", { exec = "Zsh" })
        vim.fn["vimrc#fuzzymenu#try_add"]("ZshSplit", { exec = "ZshSplit" })
      end,
    })
  end
end

return tui
