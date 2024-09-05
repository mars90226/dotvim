local choose = require("vimrc.choose")
local plugin_utils = require("vimrc.plugin_utils")

local has_secret_mapping, secret_mapping = pcall(require, "secret.mapping")

local mapping = {}

mapping.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  -- TODO: Check mini.basics mappings
  use_config({
    "mars90226/mapping",
    config = function()
      vim.api.nvim_create_user_command("HelptagsAll", [[lua require('vimrc.utils').helptags_all()]], {})

      -- Quick tab actions
      vim.keymap.set("n", "<Space><Tab>l", [[<Cmd>tablast<CR>]], { desc = "Goto last tab" })
      vim.keymap.set("n", "<Space><Tab>o", [[<Cmd>tabonly<CR>]], { desc = "Close other tabs" })
      vim.keymap.set("n", "<Space><Tab>f", [[<Cmd>tabfirst<CR>]], { desc = "Goto first tab" })
      vim.keymap.set("n", "<Space><Tab><Tab>", [[<Cmd>tabnew<CR>]], { desc = "New tab" })
      vim.keymap.set("n", "<Space><Tab>]", [[<Cmd>tabnext<CR>]], { desc = "Goto next tab" })
      vim.keymap.set("n", "<Space><Tab>[", [[<Cmd>tabprevious<CR>]], { desc = "Goto previous tab" })
      vim.keymap.set("n", "<Space><Tab>d", [[<Cmd>tabclose<CR>]], { desc = "Close tab" })
      vim.keymap.set("n", "<Space><Tab>)", [[<Cmd>tabmove +1<CR>]], { desc = "Move tab to next" })
      vim.keymap.set("n", "<Space><Tab>(", [[<Cmd>tabmove -1<CR>]], { desc = "Move tab to previous" })

      -- Quickly leave insert mode
      vim.keymap.set("i", "kj", [[<Esc>]], { desc = "Leave insert mode" })

      -- Alternative way to scroll half page
      vim.keymap.set("n", "<M-[>", [[<C-U>]], { desc = "Scroll half page up" })
      vim.keymap.set("x", "<M-[>", [[<C-U>]], { desc = "Scroll half page up" })
      vim.keymap.set("n", "<M-]>", [[<C-D>]], { desc = "Scroll half page down" })
      vim.keymap.set("x", "<M-]>", [[<C-D>]], { desc = "Scroll half page down" })
      
      -- Quick editor actions
      vim.keymap.set("n", "<Leader>ee", [[<Cmd>edit<CR>]], { desc = "Edit" })

      -- diagraph
      vim.keymap.set("i", "<M-K>", [[<C-K>]], { desc = "Insert diagraph" })

      -- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
      -- so that you can undo CTRL-U after inserting a line break.
      vim.keymap.set("i", "<C-U>", [[<C-G>u<C-U>]])

      -- CTRL-L with nvim default behavior & dismiss notifications
      -- NOTE: This may break after reloading config
      local default_ctrl_l = vim.fn.maparg("<C-L>", "n", false, true)
      vim.keymap.set("n", "<C-L>", default_ctrl_l.rhs .. [[<Cmd>lua vim.notify.dismiss()<CR>]], { silent = true })

      -- Add key mapping for suspend
      vim.keymap.set("n", "<Space><C-Z>", [[:suspend<CR>]], { desc = "Suspend" })

      -- Quickly switch window {{{
      vim.keymap.set("n", "<M-h>", [[<C-W>h]], { desc = "Switch to left window" })
      vim.keymap.set("n", "<M-j>", [[<C-W>j]], { desc = "Switch to below window" })
      vim.keymap.set("n", "<M-k>", [[<C-W>k]], { desc = "Switch to above window" })
      vim.keymap.set("n", "<M-l>", [[<C-W>l]], { desc = "Switch to right window" })
      -- }}}

      -- Saner command-line history {{{
      vim.keymap.set("c", "<M-n>", [[<Down>]], { desc = "Next command-line history" })
      vim.keymap.set("c", "<M-p>", [[<Up>]], { desc = "Previous command-line history" })
      -- }}}

      -- Tab key mapping {{{
      -- Move to previous/next
      vim.keymap.set("n", "<C-J>", [[gT]], { desc = "Previous tab" })
      vim.keymap.set("n", "<C-K>", [[gt]], { desc = "Next tab" })

      -- Re-order to previous/next
      vim.keymap.set("n", "<Leader>t<", [[:tabmove -1<CR>]], { desc = "Move tab to previous" })
      vim.keymap.set("n", "<Leader>t>", [[:tabmove +1<CR>]], { desc = "Move tab to next" })

      -- Goto buffer in position
      vim.keymap.set("n", "g4", [[:tablast<CR>]], { desc = "Goto last tab" })
      -- }}}

      -- Quickly adjust window size
      vim.keymap.set("n", "<C-W><Space>-", [[<C-W>10-]], { desc = "Decrease window height by 10" })
      vim.keymap.set("n", "<C-W><Space>+", [[<C-W>10+]], { desc = "Increase window height by 10" })
      vim.keymap.set("n", "<C-W><Space><", [[<C-W>10<]], { desc = "Decrease window width by 10" })
      vim.keymap.set("n", "<C-W><Space>>", [[<C-W>10>]], { desc = "Increase window width by 10" })
      vim.keymap.set("n", "<C-W><Space>=", [[:call vimrc#utility#window_equal()<CR>]], { desc = "Make all windows equal" })
      vim.keymap.set("n", "<C-W><Space>x", [[<C-W>_<C-W><Bar>]], { desc = "Maximize current window" })
      vim.keymap.set("x", "<C-W><Space>_", [[:call vimrc#utility#resize_height_to_selected()<CR>]], { desc = "Resize height to selected text lines" })
      vim.keymap.set("x", "<C-W><Space><Bar>", [[:call vimrc#utility#resize_width_to_selected()<CR>]], { desc = "Resize width to selected text columns" })
      vim.keymap.set("x", "<C-W><Space>x", [[:call vimrc#utility#resize_to_selected()<CR>]], { desc = "Resize to selected text lines & columns" })
      vim.keymap.set("n", "<C-W><Space>s", [[:call vimrc#utility#reset_sidebar_size()<CR>]], { desc = "Reset sidebar size" })

      -- Create new line in insert mode
      vim.keymap.set("i", "<M-o>", [[<C-O>o]], { desc = "Create new line below" })
      vim.keymap.set("i", "<M-S-o>", [[<C-O>O]], { desc = "Create new line above" })

      -- Go to matched bracket in insert mode
      imap("<M-5>", [[<C-O>%]], { desc = "Go to matched bracket" })

      -- Go to WORD end in insert mode
      vim.keymap.set("i", "<M-E>", [[<Esc>Ea]], { desc = "Go to WORD end" })

      -- Create new line without indent & prefix
      vim.keymap.set("n", "<M-o>", [[o <C-U>]], { desc = "Create new line below and remove indent & prefix" })
      vim.keymap.set("n", "<M-S-o>", [[O <C-U>]], { desc = "Create new line above and remove indent & prefix" })

      -- Save
      vim.keymap.set("n", "<C-S>", [[:update<CR>]], { desc = "Save" })
      vim.keymap.set("n", "<Space><C-S>", [[:wall<CR>]], { desc = "Save all" })
      vim.keymap.set("n", "<Leader><C-S>", [[:noautocmd write<CR>]], { desc = "Save without triggering autocommand" })

      -- Quit
      vim.keymap.set("n", "<Space>q", [[:quit<CR>]], { desc = "Quit" })
      vim.keymap.set("n", "<Space>Q", [[:call vimrc#utility#quit_tab()<CR>]], { desc = "Quit tab" })
      vim.keymap.set("n", "<Space><C-Q>", [[:qall!<CR>]], { desc = "Quit all" })

      -- Easier file status
      vim.keymap.set("n", "<Space><C-G>", [[2<C-G>]], { desc = "Show file status" })

      -- Change current window working directory to parent folder
      vim.keymap.set("n", "<Leader>du", [[:lcd ..<CR>]], { desc = "Change current window working directory to parent folder" })

      -- Change current window working directory to folder containing current buffer
      vim.keymap.set("n", "<Leader>d5", [[:lcd %:h<CR>]], { desc = "Change current window working directory to folder containing current buffer" })

      -- Change current window working directory to git root folder
      vim.keymap.set("n", "<Leader>dg", function()
        if vim.fn["FugitiveIsGitDir"]() == 0 then
          vim.notify("Not in a git repository: "..vim.fn.expand('%:p'))
          return
        end

        local git_root_folder = vim.fn["FugitiveWorkTree"]()
        vim.cmd.lcd(git_root_folder)
      end, { desc = "Change current window working directory to git root folder"})

      -- Horizontally scroll to center of window, like horizontal 'zz'
      vim.keymap.set("n", "zc", [[zszH]], { desc = "Horizontally scroll to center of window" })

      -- Scroll to 1/4 top/bottom of window
      vim.keymap.set("n", "zT", [['zt' . float2nr(winheight(0) * 0.25) . "\<C-Y>"]], { expr = true, desc = "Scroll to 1/4 top of window" })
      vim.keymap.set("n", "zB", [['zb' . float2nr(winheight(0) * 0.25) . "\<C-E>"]], { expr = true, desc = "Scroll to 1/4 bottom of window" })

      -- Operator mapping for current word
      vim.keymap.set("n", "sx", [[ciw]], { desc = "Change current word" })
      vim.keymap.set("n", "sX", [[ciW]], { desc = "Change current WORD" })

      -- Quick yank cursor word
      -- TODO This overrides jump to mark
      vim.keymap.set("n", "y'", [[""yiw]], { desc = "Yank current word" })
      vim.keymap.set("n", [[y"]], [[""yiW]], { desc = "Yank current WORD" })
      vim.keymap.set("n", "y=", [["+yiw]], { desc = "Yank current word to system clipboard" })
      vim.keymap.set("n", "y+", [["+yiW]], { desc = "Yank current WORD to system clipboard" })

      -- TODO: Check mini-bracketed issue thread: https://github.com/echasnovski/mini.nvim/issues/235

      -- Add empty lines before and after cursor line
      -- Ref: https://github.com/echasnovski/mini.nvim/blob/c65901227e5a3671dbcb054745566a1c78f9f0c8/lua/mini/basics.lua#L558-L559
      vim.keymap.set("n", '[<Space>', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = 'Put empty line above' })
      vim.keymap.set("n", ']<Space>', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>", { desc = 'Put empty line below' })

      -- Quick paste above/below
      -- TODO: Make this respect indent
      -- Ref: https://github.com/echasnovski/mini.nvim/issues/235#issuecomment-1458079353
      vim.keymap.set({ 'n', 'x' }, '[p', '<Cmd>exe "put! " . v:register<CR>', { desc = 'Paste Above' })
      vim.keymap.set({ 'n', 'x' }, ']p', '<Cmd>exe "put "  . v:register<CR>', { desc = 'Paste Below' })

      -- Quick yank/paste to/from system clipboard
      -- TODO This overrides jump to mark
      vim.keymap.set("n", "=y", [["+y]], { desc = "Yank to system clipboard" })
      vim.keymap.set("x", "=y", [["+y]], { desc = "Yank to system clipboard" })
      vim.keymap.set("n", "=Y", [["+y$]], { desc = "Yank to the line end to system clipboard" }) -- NOTE: Follow Nvim builtin map of `Y` to `y$`
      vim.keymap.set("n", "+p", [["+p]], { desc = "Paste after from system clipboard" })
      vim.keymap.set("x", "+p", [["+p]], { desc = "Paste after from system clipboard" })
      vim.keymap.set("n", "+P", [["+P]], { desc = "Paste before from system clipboard" })
      vim.keymap.set("x", "+P", [["+P]], { desc = "Paste before from system clipboard" })
      vim.keymap.set("n", "+gp", [["+gp]], { desc = "Paste after from system clipboard and leave cursor after new text" })
      vim.keymap.set("x", "+gp", [["+gp]], { desc = "Paste after from system clipboard and leave cursor after new text" })
      vim.keymap.set("n", "+gP", [["+gP]], { desc = "Paste before from system clipboard and leave cursor after new text" })
      vim.keymap.set("x", "+gP", [["+gP]], { desc = "Paste before from system clipboard and leave cursor after new text" })
      -- TODO Previous key mappings not work in vimwiki as it use '=' & '+'
      nmap("<p", [["+[p]], { desc = "Paste before from system clipboard and adjust indent" })
      nmap(">p", [["+]p]], { desc = "Paste after from system clipboard and adjust indent" })

      -- Quick yank filename
      vim.keymap.set("n", "<Leader>y6", [[:let @" = expand('%:t')<CR>]], { desc = "Yank current filename" })
      vim.keymap.set("n", "<Leader>y5", [[:let @" = expand('%:t:r')<CR>]], { desc = "Yank current filename without extension" })
      vim.keymap.set("n", "<Leader>y%", [[:let @" = @%<CR>]], { desc = "Yank current filename with relative path to current working directoy" })
      vim.keymap.set("n", "<Leader>y4", [[:let @" = expand('%:p')<CR>]], { desc = "Yank current filename with full path" })

      -- Quick yank current directory
      vim.keymap.set("n", "<Leader>yd", [[:let @" = getcwd()<CR>]], { desc = "Yank current directory" })

      -- Quick split
      vim.keymap.set("n", "<Leader>yt", [[:tab split<CR>]], { desc = "Split in new tab" })
      vim.keymap.set("n", "<Leader>ys", [[:split<CR>]], { desc = "Split in new window" })
      vim.keymap.set("n", "<Leader>yv", [[:vertical split<CR>]], { desc = "Split in new vertical window" })

      -- Copy unnamed register to system clipboard
      vim.keymap.set("n", "<Space>sr", [[:let @+ = @"<CR>]], { desc = "Copy unnamed register to system clipboard" })
      vim.keymap.set("n", "<Space>sR", [[:let @" = @+<CR>]], { desc = "Copy system clipboard to unnamed register" })

      -- Trim system clipboard to 7 chars (for git commit sha)
      vim.keymap.set("n", "<Space>s7", [[:let @+ = @+[0:6]<CR>]], { desc = "Trim system clipboard to 7 chars" })

      -- Command line & Insert mode mapping
      vim.keymap.set("c", "<C-G><C-G>", [[<C-G>]], { desc = "Insert <C-G>" })
      vim.keymap.set("i", "<C-G><C-G>", [[<C-G>]], { desc = "Insert <C-G>" })
      vim.keymap.set("c", "<C-G><C-F>", [[vimrc#fzf#files_in_commandline()]], { expr = true,  desc = "Fill files" })
      vim.keymap.set("i", "<C-G><C-F>", [[vimrc#fzf#files_in_commandline()]], { expr = true,  desc = "Fill files" })
      -- <BS> and <C-H> are the same key when $TERM is 'xterm'
      vim.keymap.set("c", "<C-G><BS>", [[vimrc#fzf#mru#mru_in_commandline()]], { expr = true,  desc = "Fill MRU" })
      vim.keymap.set("i", "<C-G><BS>", [[vimrc#fzf#mru#mru_in_commandline()]], { expr = true,  desc = "Fill MRU" })
      vim.keymap.set("c", "<C-G><C-H>", [[vimrc#fzf#mru#mru_in_commandline()]], { expr = true,  desc = "Fill MRU" })
      vim.keymap.set("i", "<C-G><C-H>", [[vimrc#fzf#mru#mru_in_commandline()]], { expr = true,  desc = "Fill MRU" })
      vim.keymap.set("c", "<C-G><C-M>", [[vimrc#fzf#mru#directory_mru_in_commandline()]], { expr = true,  desc = "Fill directory MRU" })
      vim.keymap.set("i", "<C-G><C-M>", [[vimrc#fzf#mru#directory_mru_in_commandline()]], { expr = true,  desc = "Fill directory MRU" })
      vim.keymap.set("c", "<C-G><C-P>", [[vimrc#rg#current_type_option()]], { expr = true,  desc = "Fill current type option for ripgrep" })
      vim.keymap.set("i", "<C-G><C-P>", [[vimrc#rg#current_type_option()]], { expr = true,  desc = "Fill current type option for ripgrep" })
      vim.keymap.set("c", "<C-G><C-L>", [[vimrc#rg#types_in_commandline()]], { expr = true,  desc = "Fill types for ripgrep" })
      vim.keymap.set("i", "<C-G><C-L>", [[vimrc#rg#types_in_commandline()]], { expr = true,  desc = "Fill types for ripgrep" })
      -- Expand filename
      -- TODO: Use one key to invoke fzf and expand to different filenames
      vim.keymap.set("c", "<C-G><C-^>", [[expand('%:t')]], { expr = true,  desc = "Expand filename" })
      vim.keymap.set("i", "<C-G><C-^>", [[expand('%:t')]], { expr = true,  desc = "Expand filename" })
      -- <C-]> and <C-%> are the same key
      vim.keymap.set("c", "<C-G><C-]>", [[expand('%:t:r')]], { expr = true,  desc = "Expand filename without extension" })
      vim.keymap.set("i", "<C-G><C-]>", [[expand('%:t:r')]], { expr = true,  desc = "Expand filename without extension" })
      -- <C-\> and <C-$> are the same key
      vim.keymap.set("c", [[<C-G><C-\>]], [[expand('%:p')]], { expr = true,  desc = "Expand buffer folder with full path" })
      vim.keymap.set("i", [[<C-G><C-\>]], [[expand('%:p')]], { expr = true,  desc = "Expand buffer folder with full path" })
      -- Expand buffer folder
      vim.keymap.set("c", "<C-G><C-R>", [[expand('%:h')]], { expr = true,  desc = "Expand buffer folder" })
      vim.keymap.set("i", "<C-G><C-R>", [[expand('%:h')]], { expr = true,  desc = "Expand buffer folder" })
      -- For grepping word
      vim.keymap.set("c", "<C-G><C-W>", [["\\b" . expand('<cword>') . "\\b"]], { expr = true,  desc = "Expand word with regex boundary" })
      vim.keymap.set("c", "<C-G><C-A>", [["\\b" . expand('<cWORD>') . "\\b"]], { expr = true,  desc = "Expand WORD with regex boundary" })
      vim.keymap.set("c", "<C-G>b", [["\<C-B>\\b\<C-E>\\b"]], { expr = true,  desc = "Wrap word with regex boundary" })
      vim.keymap.set("c", "<C-G>B", [["\<C-B>\\<\<C-E>\\>"]], { expr = true,  desc = "Wrap word with vim boundary" })
      -- Fugitive commit sha
      vim.keymap.set("c", "<C-G><C-Y>", [[vimrc#fugitive#commit_sha()]], { expr = true,  desc = "Fill commit sha" })
      vim.keymap.set("i", "<C-G><C-Y>", [[vimrc#fugitive#commit_sha()]], { expr = true,  desc = "Fill commit sha" })
      -- Fill commit
      vim.keymap.set("c", "<C-G><C-I>", [[vimrc#fzf#git#commits_in_commandline(0, [])]], { expr = true,  desc = "Fill commits" })
      vim.keymap.set("i", "<C-G><C-I>", [[vimrc#fzf#git#commits_in_commandline(0, [])]], { expr = true,  desc = "Fill commits" })
      -- FIXME: Currently, use bcommits command with fzf-tmux will cause error
      -- Vim(let):E684: list index out of range: 1
      vim.keymap.set("c", "<C-G><C-O>", [[vimrc#fzf#git#commits_in_commandline(1, [])]], { expr = true,  desc = "Fill buffer commits"})
      vim.keymap.set("i", "<C-G><C-O>", [[vimrc#fzf#git#commits_in_commandline(1, [])]], { expr = true,  desc = "Fill buffer commits"})
      -- Fill branches
      vim.keymap.set("c", "<C-X>b", [[vimrc#git#get_current_branch()]], { expr = true,  desc = "Fill current branch" })
      vim.keymap.set("i", "<C-X>b", [[vimrc#git#get_current_branch()]], { expr = true,  desc = "Fill current branch" })
      vim.keymap.set("c", "<C-G><C-B>", [[vimrc#fzf#git#branches_in_commandline()]], { expr = true,  desc = "Fill branches" })
      vim.keymap.set("i", "<C-G><C-B>", [[vimrc#fzf#git#branches_in_commandline()]], { expr = true,  desc = "Fill branches" })
      vim.keymap.set("c", "<C-G><C-T>", [[vimrc#fzf#git#tags_in_commandline()]], { expr = true,  desc = "Fill tags" })
      vim.keymap.set("i", "<C-G><C-T>", [[vimrc#fzf#git#tags_in_commandline()]], { expr = true,  desc = "Fill tags" })
      vim.keymap.set("c", "<C-G><C-X>", [[vimrc#fzf#git#diff_files_in_commandline()]], { expr = true,  desc = "Fill diff files" })
      vim.keymap.set("i", "<C-G><C-X>", [[vimrc#fzf#git#diff_files_in_commandline()]], { expr = true,  desc = "Fill diff files" })
      -- Fill git email
      vim.keymap.set("c", "<C-G><C-E>", [[vimrc#git#get_email()]], { expr = true,  desc = "Fill git email" })
      vim.keymap.set("i", "<C-G><C-E>", [[vimrc#git#get_email()]], { expr = true,  desc = "Fill git email" })
      -- Get visual selection
      vim.keymap.set("c", "<C-G><C-V>", [[vimrc#utility#get_visual_selection()]], { expr = true,  desc = "Get visual selection" })
      -- Trim command line content (Use <Space> to separate `<C-\>e` and function)
      vim.keymap.set("c", "<C-G>t", [[<C-\>e<Space>vimrc#insert#trim_cmdline()<CR>]], { desc = "Trim command line content" })
      -- Delete whole word (Use <Space> to separate `<C-\>e` and function)
      vim.keymap.set("c", "<C-G>w", [[<C-\>e<Space>vimrc#insert#delete_whole_word()<CR>]], { desc = "Delete whole word" })
      -- Delete subword (Use <Space> to separate `<C-\>e` and function)
      vim.keymap.set("c", "<C-X><C-B>", [[<C-\>e<Space>v:lua.require("vimrc.cmdline").delete_subword()<CR>]], { desc = "Delete subword" })
      -- Company related data
      vim.keymap.set("c", "<C-G>d", [[g:company_domain]], { expr = true,  desc = "Insert company domain" })
      vim.keymap.set("c", "<C-G>e", [[g:company_email]], { expr = true,  desc = "Insert company email" })
      -- Manipulate register content
      vim.keymap.set("c", "<C-G>4", [[<C-R>=fnamemodify(@", ':p')<CR>]], { desc = "Insert register content with full path" })
      vim.keymap.set("i", "<C-G>4", [[<C-R>=fnamemodify(@", ':p')<CR>]], { desc = "Insert register content with full path" })
      vim.keymap.set("c", "<C-G>5", [[<C-R>=fnamemodify(@", ':t:r')<CR>]], { desc = "Insert register content without extension" })
      vim.keymap.set("i", "<C-G>5", [[<C-R>=fnamemodify(@", ':t:r')<CR>]], { desc = "Insert register content without extension" })
      vim.keymap.set("c", "<C-G>6", [[<C-R>=fnamemodify(@", ':t')<CR>]], { desc = "Insert register content filename" })
      vim.keymap.set("i", "<C-G>6", [[<C-R>=fnamemodify(@", ':t')<CR>]], { desc = "Insert register content filename" })
      vim.keymap.set("c", "<C-G>r", [[<C-R>=fnamemodify(@", ':h')<CR>]], { desc = "Insert register content folder" })
      vim.keymap.set("i", "<C-G>r", [[<C-R>=fnamemodify(@", ':h')<CR>]], { desc = "Insert register content folder" })
      -- Insert date
      vim.keymap.set("c", "<C-G>D", [[<C-R>=systemlist('env LC_ALL=C date +"%Y/%m/%d"')[0]<CR>]], { desc = "Insert date" })
      vim.keymap.set("i", "<C-G>D", [[<C-R>=systemlist('env LC_ALL=C date +"%Y/%m/%d"')[0]<CR>]], { desc = "Insert date" })
      -- Insert shell output
      vim.keymap.set("c", "<C-X><C-X>", [[vimrc#fzf#shell_outputs_in_commandline()]], { expr = true,  desc = "Insert shell output" })
      vim.keymap.set("i", "<C-X><C-X>", [[vimrc#fzf#shell_outputs_in_commandline()]], { expr = true,  desc = "Insert shell output" })

      -- Ex mode for special buffer that map 'q' as ':quit'
      vim.keymap.set("n", [[\q:]], [[q:]], { desc = "Ex mode for command line history" })
      vim.keymap.set("n", [[\q/]], [[q/]] , { desc = "Ex mode for forward search history" })
      vim.keymap.set("n", [[\q?]], [[q?]], { desc = "Ex mode for backward search history" })

      -- <Leader><F10> for syncing syntax highlight from start
      vim.keymap.set("n", "<Leader><F10>", [[:syntax sync fromstart<CR>]], { desc = "Sync syntax highlight from start" })

      -- Execute last command
      -- Note: @: should execute last command, but didn't work when using
      -- vimrc#execute_and_save()
      vim.keymap.set("n", "<M-x><M-x>", [[:<C-P><CR>]], { desc = "Execute last command" })

      -- Substitute visual selection
      vim.keymap.set("x", "<M-s>", [[:s/\%V]], { desc = "Substitute visual selection" })

      -- Find non-ASCII character
      vim.keymap.set("", "<M-x>", [[<Plug>(non-ascii-find)]], { remap = true })
      vim.keymap.set("", "<Plug>(non-ascii-find)", [[<NOP>]])
      vim.keymap.set("n", "<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>:nohlsearch<CR>]], { silent = true })
      vim.keymap.set("x", "<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>]], { silent = true })
      vim.keymap.set("o", "<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>]], { silent = true })
      vim.keymap.set("n", "<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>:nohlsearch<CR>]], { silent = true })
      vim.keymap.set("x", "<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>]], { silent = true })
      vim.keymap.set("o", "<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>]], { silent = true })
      vim.keymap.set("x", "<Plug>(non-ascii-find)<M-s>", [[?[^\x00-\x7F]<CR>lo/[^\x00-\x7F]<CR>]], { silent = true })
      vim.keymap.set("o", "<Plug>(non-ascii-find)<M-s>", [[:<C-U>call vimrc#textobj#inner_surround_unicode()<CR>]], { silent = true })
      vim.keymap.set("x", "<Plug>(non-ascii-find)<M-S>", [[?[^\x00-\x7F]<CR>o/[^\x00-\x7F]<CR>l]], { silent = true })
      vim.keymap.set("o", "<Plug>(non-ascii-find)<M-S>", [[:<C-U>call vimrc#textobj#around_surround_unicode()<CR>]], { silent = true })

      -- Find character past specified character
      vim.keymap.set("n", "<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:true)<CR>]], { silent = true })
      vim.keymap.set("x", "<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:true)<CR>]], { silent = true })
      vim.keymap.set("o", "<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:true)<CR>]], { silent = true })
      vim.keymap.set("n", "<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:false)<CR>]], { silent = true })
      vim.keymap.set("x", "<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:false)<CR>]], { silent = true })
      vim.keymap.set("o", "<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:false)<CR>]], { silent = true })

      -- Text Objects
      -- ie = inner entire buffer
      vim.keymap.set("o", "ie", ':exec "normal! ggVG"<CR>')
      vim.keymap.set("x", "ie", ':<C-U>exec "normal! ggVG"<CR>')

      -- iV = current viewable text in the buffer
      vim.keymap.set("o", "iV", ':exec "normal! HVL"<CR>')
      vim.keymap.set("x", "iV", ':<C-U>exec "normal! HVL"<CR>')

      -- Search
      -- TODO: Extract to search.vim?
      nmap("<M-s>", "<Plug>(search-prefix)")
      vim.keymap.set("n", "<M-s><M-s>", [[<M-s>]])
      vim.keymap.set("", "<Plug>(search-prefix)", [[<NOP>]])
      vim.keymap.set("n", "<Plug>(search-prefix)f", [[<Cmd>call vimrc#search#search_file(0)<CR>]])
      vim.keymap.set("n", "<Plug>(search-prefix)y", [[<Cmd>call vimrc#search#search_hash(0)<CR>]])
      vim.keymap.set("n", "<Plug>(search-prefix)u", [[<Cmd>call vimrc#search#search_url(0)<CR>]])
      vim.keymap.set("n", "<Plug>(search-prefix)i", [[<Cmd>call vimrc#search#search_ip(0)<CR>]])

      -- Search within visual selection
      vim.keymap.set("x", "<M-/>", [[<Esc>/\%V]])
      vim.keymap.set("x", "<M-?>", [[<Esc>?\%V]])

      -- Search in function
      vim.keymap.set("", "<Space>sF", "vaf<M-/>", { remap = true })

      -- Diff
      -- Use <M-d> as prefix
      vim.keymap.set("n", "<M-d>t", [[:windo diffthis<CR>]])
      vim.keymap.set("n", "<M-d>o", [[:windo diffoff<CR>]])
      vim.keymap.set("n", "<M-d>h", [[:diffthis<CR>:wincmd l<CR>:diffthis<CR>:2wincmd h<CR>:diffthis<CR>]])
      vim.keymap.set("n", "<M-d>v", [[:diffthis<CR>:wincmd j<CR>:diffthis<CR>:2wincmd k<CR>:diffthis<CR>]])
      if choose.is_enabled_plugin('vim-floaterm') then
        vim.keymap.set("n", "<M-d>f", [[<Cmd>lua require('vimrc.diff').diff_in_delta()<CR>]])
      end

      -- Sort
      vim.keymap.set("x", "<Space>ss", [[d:execute 'normal i'.vimrc#utility#sort_copied_words()<CR>]], { silent = true })

      -- Retab
      vim.keymap.set("n", "<Space>r5", [[:%retab!<CR>]])

      -- Select Mode
      vim.keymap.set("s", "<CR>", [[<C-O>c]])
      vim.keymap.set("s", "<M-a>", [[<Esc>A]])
      vim.keymap.set("s", "<M-i>", [[<C-O>o<Esc>i]])

      -- Smart dd
      -- Ref: https://www.reddit.com/r/neovim/comments/w0jzzv/smart_dd/
      vim.keymap.set("n", "dd", [[v:lua.require("vimrc.mapping").smart_dd()]], { expr = true })

      -- Man
      -- :Man is defined in $VIMRUNTIME/plugin/man.vim which is loaded after .vimrc
      -- TODO Move this to 'after' folder
      -- TODO Detect goyo mode and use normal :Man
      vim.keymap.set("n", "<Leader><F1>", [[:Man<Space>]])
      vim.keymap.set("n", "<Leader><F2>", [[:VimrcFloatNew! Man<Space>]])

      -- Inspect
      vim.keymap.set("n", "<Space>hi", [[<Cmd>Inspect<CR>]])
      vim.keymap.set("n", "<Space>ht", [[<Cmd>InspectTree<CR>]])

      -- Print visual selection info
      -- TODO: Do not leave visual mode, use nvim-notify
      vim.keymap.set("x", "g<C-G>", "g<C-G>:<C-U>lua vim.notify(vim.v.statusmsg)<CR>")

      -- Repeat or execute macro on all visually selected lines
      vim.keymap.set("x", "<Leader>.", [[:normal .<CR>]])
      vim.keymap.set("x", "<Leader>@", [[:normal Q<CR>]])

      -- Custom function {{{
      vim.api.nvim_create_user_command("ToggleIndent", [[call vimrc#toggle#toggle#indent()]], {})
      vim.api.nvim_create_user_command("ToggleFold", [[call vimrc#toggle#fold_method()]], {})
      vim.keymap.set("n", "cof", [[:ToggleFold<CR>]])

      -- LastTab
      vim.api.nvim_create_user_command("LastTab", [[call vimrc#last_tab#jump(<count>)]], { count = true, bar = true })
      vim.keymap.set("n", "<M-1>", [[:call vimrc#last_tab#jump(v:count)<CR>]])

      local last_tab_augroup_id = vim.api.nvim_create_augroup("last_tab_settings", {})
      vim.api.nvim_create_autocmd({ "TabLeave" }, {
        group = last_tab_augroup_id,
        pattern = "*",
        callback = function()
          local tabpage = vim.api.nvim_get_current_tabpage()
          vim.fn["vimrc#last_tab#insert"](vim.api.nvim_tabpage_get_number(tabpage))
        end,
      })
      vim.api.nvim_create_autocmd({ "TabClosed" }, {
        group = last_tab_augroup_id,
        pattern = "*",
        callback = function()
          vim.fn["vimrc#last_tab#clear_invalid"]()
        end,
      })

      -- Toggle parent folder tag
      vim.api.nvim_create_user_command("ToggleParentFolderTag", [[call vimrc#toggle#parent_folder_tag()]], {})
      vim.keymap.set("n", "yoP", [[:ToggleParentFolderTag<CR>]], { silent = true })

      -- Display file size
      vim.api.nvim_create_user_command(
        "FileSize",
        [[call vimrc#utility#file_size(<q-args>)]],
        { nargs = 1, complete = "file" }
      )

      -- Set tab size
      vim.api.nvim_create_user_command("SetTabSize", [[call vimrc#utility#set_tab_size(<q-args>)]], { nargs = 1 })

      vim.api.nvim_create_user_command("GetCursorSyntax", [[echo vimrc#utility#get_cursor_syntax()]], {})

      -- Find the cursor
      vim.api.nvim_create_user_command("FindCursor", [[call vimrc#utility#blink_cursor_location()]], {})

      vim.api.nvim_create_user_command("ClearWinfixsize", [[call vimrc#clear_winfixsize()]], {})

      vim.api.nvim_create_user_command(
        "ClearRegisters",
        [[call vimrc#utility#clear_registers(<q-args>)]],
        { nargs = 1 }
      )

      vim.api.nvim_create_user_command("MakeTodo", function(opts)
        require("vimrc.todo").make_todo(opts.line1, opts.line2)
      end, { range = true })
      -- }}}

      -- Custom command {{{
      -- Convenient command to see the difference between the current buffer and the
      -- file it was loaded from, thus the changes you made.
      -- Only define it when not defined already.
      if vim.fn.exists(":DiffOrig") ~= 2 then
        vim.api.nvim_create_user_command("DiffOrig", [[call vimrc#utility#diff_original()]], {})
      end

      -- Delete inactive buffers
      vim.api.nvim_create_user_command("Bdi", function(opts)
        local args = opts.fargs
        if opts.bang then
          table.insert(args, "bang")
        end

        require("vimrc.buffer").delete_inactive_buffers(unpack(args))
      end, { bang = true, nargs = "*" })
      vim.keymap.set("n", "Zd", [[:Bdi<CR>]])
      vim.keymap.set("n", "ZD", [[:Bdi!<CR>]])
      vim.keymap.set("n", "Z<C-D>", [[:Bdi! include_modified<CR>]])
      vim.keymap.set("n", "Zw", [[:Bdi wipeout<CR>]])
      vim.keymap.set("n", "ZW", [[:Bdi! wipeout<CR>]])
      vim.keymap.set("n", "Z<C-W>", [[:Bdi! wipeout include_modified<CR>]])

      -- Delete scratch buffers
      vim.api.nvim_create_user_command("Bds", function()
        require("vimrc.buffer").delete_hidden_scratch_buffers()
      end, {})
      vim.keymap.set("n", "Zs", [[<Cmd>Bds<CR>]])

      vim.api.nvim_create_user_command("TrimWhitespace", [[call vimrc#utility#trim_whitespace()]], {})

      vim.api.nvim_create_user_command("DisplayChar", [[lua require("vimrc.utils").display_char()]], {})

      vim.api.nvim_create_user_command("ReloadVimrc", [[call vimrc#reload#reload()]], {})

      vim.api.nvim_create_user_command(
        "QuickfixOutput",
        [[call vimrc#quickfix#execute(<f-args>)]],
        { nargs = 1, complete = "command" }
      )
      vim.keymap.set("n", "<Leader>oq", [[:execute 'QuickfixOutput '.input('OuickfixOutput: ', '', 'command')<CR>]])
      vim.api.nvim_create_user_command(
        "LocationOutput",
        [[call vimrc#quickfix#loc_execute(<f-args>)]],
        { nargs = 1, complete = "command" }
      )
      vim.keymap.set("n", "<Leader>ol", [[:execute 'LocationOutput '.input('LocationOutput: ', '', 'command')<CR>]])

      vim.api.nvim_create_user_command(
        "QuickfixFromCurrentBuffer",
        [[call vimrc#quickfix#build_from_buffer(bufnr())]],
        {}
      )
      vim.api.nvim_create_user_command(
        "QuickfixFromBuffer",
        [[call vimrc#quickfix#build_from_buffer(<f-args>)]],
        { nargs = 1 }
      )

      if not plugin_utils.os_is("windows") then
        vim.api.nvim_create_user_command("Args", [[echo system("ps -o command= -p " . getpid())]], {})
      end

      vim.api.nvim_create_user_command(
        "Switch",
        [[call vimrc#open#switch(<q-args>, 'edit')]],
        { nargs = 1, complete = "file" }
      )
      vim.api.nvim_create_user_command(
        "TabSwitch",
        [[call vimrc#open#switch(<q-args>, 'tabedit')]],
        { nargs = 1, complete = "file" }
      )
      vim.api.nvim_create_user_command("TabOpen", [[call vimrc#open#tab(<q-args>)]], { nargs = 1, complete = "file" })
      vim.api.nvim_create_user_command("InspectObject", function(opts)
        require("vimrc.inspect").inspect(vim.fn.luaeval(opts.args))
      end, { nargs = "*", complete = "lua" })
      vim.api.nvim_create_user_command("InspectEvalString", function(opts)
        local inspect = require("vimrc.inspect")
        inspect.inspect_eval_string(opts.args)
      end, { nargs = "*", complete = "lua" })
      vim.api.nvim_create_user_command("InspectLsp", function(opts)
        local lsp_server_name = opts.args
        local inspect = require("vimrc.inspect")
        inspect.inspect_eval_string("vim.lsp.get_clients({name='"..lsp_server_name.."'})")
      end, { nargs = 1 })

      vim.api.nvim_create_user_command("ToggleOpenUrlForceLocal", function()
        require("vimrc.mapping").toggle_open_url_force_local()
      end, {})

      local initial_working_directory = vim.fn.getcwd()
      vim.api.nvim_create_user_command("ResetWorkingDirectory", function()
        vim.cmd.cd(initial_working_directory)
      end, {})
      -- }}}

      if has_secret_mapping then
        secret_mapping.setup()
      end

      -- Add space between English word and Chinese word
      vim.api.nvim_create_user_command("AddSpaceBetweenEnglishAndChinese", function()
        -- NOTE: English word: [\da-zA-Z]
        -- NOTE: Chinese word: [\u4E00-\u9FA5]
        vim.cmd([[%s/[\da-zA-Z]\zs\ze[\u4E00-\u9FA5]/ /g]]) -- Add space between English word and Chinese word
        vim.cmd([[%s/[\u4E00-\u9FA5]\zs\ze[\da-zA-Z]/ /g]]) -- Add space between Chinese word and English word
      end, {})
    end,
  })
end

return mapping
