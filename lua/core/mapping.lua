local plugin_utils = require("vimrc.plugin_utils")

local mapping = {}

mapping.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/mapping",
    config = function()
      local choose = require("vimrc.choose")
      local plugin_utils = require("vimrc.plugin_utils")

      vim.api.nvim_create_user_command("HelptagsAll", [[lua require('vimrc.utils').helptags_all()]], {})

      -- diagraph
      inoremap("<M-K>", [[<C-K>]])

      -- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
      -- so that you can undo CTRL-U after inserting a line break.
      inoremap("<C-U>", [[<C-G>u<C-U>]])

      -- Add key mapping for suspend
      nnoremap("<Space><C-Z>", [[:suspend<CR>]])

      -- Quickly switch window {{{
      nnoremap("<M-h>", [[<C-W>h]])
      nnoremap("<M-j>", [[<C-W>j]])
      nnoremap("<M-k>", [[<C-W>k]])
      nnoremap("<M-l>", [[<C-W>l]])
      -- }}}

      -- Saner command-line history {{{
      cnoremap("<M-n>", [[<Down>]])
      cnoremap("<M-p>", [[<Up>]])
      -- }}}

      -- Tab key mapping {{{
      -- Move to previous/next
      nnoremap("<C-J>", [[gT]])
      nnoremap("<C-K>", [[gt]])

      -- Re-order to previous/next
      nnoremap("<Leader>t<", [[:tabmove -1<CR>]])
      nnoremap("<Leader>t>", [[:tabmove +1<CR>]])

      -- Goto buffer in position
      nnoremap("g4", [[:tablast<CR>]])
      -- }}}

      -- Quickly adjust window size
      nnoremap("<C-W><Space>-", [[<C-W>10-]])
      nnoremap("<C-W><Space>+", [[<C-W>10+]])
      nnoremap("<C-W><Space><", [[<C-W>10<]])
      nnoremap("<C-W><Space>>", [[<C-W>10>]])
      nnoremap("<C-W><Space>=", [[:call vimrc#utility#window_equal()<CR>]])
      nnoremap("<C-W><Space>x", [[<C-W>_<C-W><Bar>]])
      xnoremap("<C-W><Space>_", [[:call vimrc#utility#resize_height_to_selected()<CR>]])
      xnoremap("<C-W><Space><Bar>", [[:call vimrc#utility#resize_width_to_selected()<CR>]])
      xnoremap("<C-W><Space>x", [[:call vimrc#utility#resize_to_selected()<CR>]])
      nnoremap("<C-W><Space>s", [[:call vimrc#utility#reset_sidebar_size()<CR>]])

      -- Create new line in insert mode
      inoremap("<M-o>", [[<C-O>o]])
      inoremap("<M-S-o>", [[<C-O>O]])

      -- Go to matched bracket in insert mode
      imap("<M-5>", [[<C-O>%]])

      -- Go to WORD end in insert mode
      inoremap("<M-E>", [[<Esc>Ea]])

      -- Create new line without indent & prefix
      nnoremap("<M-o>", [[o <C-U>]])
      nnoremap("<M-S-o>", [[O <C-U>]])

      -- Save
      nnoremap("<C-S>", [[:update<CR>]])
      nnoremap("<Space><C-S>", [[:wall<CR>]])
      nnoremap("<Leader><C-S>", [[:noautocmd write<CR>]])

      -- Quit
      nnoremap("<Space>q", [[:quit<CR>]])
      nnoremap("<Space>Q", [[:call vimrc#utility#quit_tab()<CR>]])
      nnoremap("<Space><C-Q>", [[:qall!<CR>]])

      -- Easier file status
      nnoremap("<Space><C-G>", [[2<C-G>]])

      -- Change current window working directory to parent folder
      nnoremap("<Leader>du", [[:lcd ..<CR>]])

      -- Change current window working directory to folder containing current buffer
      nnoremap("<Leader>dh", [[:lcd %:h<CR>]])

      -- Change current window working directory to git root folder
      nnoremap("<Leader>dg", function()
        if vim.fn["FugitiveIsGitDir"]() == 0 then
          vim.notify("Not in a git repository: "..vim.fn.expand('%:p'))
          return
        end

        local git_root_folder = vim.fn["FugitiveWorkTree"]()
        vim.cmd.lcd(git_root_folder)
      end, { desc = "Change current window working directory to git root folder"})

      -- Horizontally scroll to center of window, like horizontal 'zz'
      nnoremap("zc", [[zszH]])

      -- Scroll to 1/4 top/bottom of window
      nnoremap("zT", [['zt' . float2nr(winheight(0) * 0.25) . "\<C-Y>"]], "<expr>")
      nnoremap("zB", [['zb' . float2nr(winheight(0) * 0.25) . "\<C-E>"]], "<expr>")

      -- Operator mapping for current word
      nnoremap("sx", [[ciw]])
      nnoremap("sX", [[ciW]])

      -- Quick yank cursor word
      -- TODO This overrides jump to mark
      nnoremap("y'", [[""yiw]])
      nnoremap([[y"]], [[""yiW]])
      nnoremap("y=", [["+yiw]])
      nnoremap("y+", [["+yiW]])

      -- Quick yank/paste to/from system clipboard
      -- TODO This overrides jump to mark
      nnoremap("=y", [["+y]])
      xnoremap("=y", [["+y]])
      nnoremap("=Y", [["+y$]]) -- NOTE: Follow Nvim builtin map of `Y` to `y$`
      nnoremap("+p", [["+p]])
      xnoremap("+p", [["+p]])
      nnoremap("+P", [["+P]])
      xnoremap("+P", [["+P]])
      -- TODO Previous key mappings not work in vimwiki as it use '=' & '+'
      nmap("<p", [["+[p]])
      nmap(">p", [["+]p]])

      -- Quick yank filename
      nnoremap("<Leader>y6", [[:let @" = expand('%:t')<CR>]])
      nnoremap("<Leader>y5", [[:let @" = expand('%:t:r')<CR>]])
      nnoremap("<Leader>y%", [[:let @" = @%<CR>]])
      nnoremap("<Leader>y4", [[:let @" = expand('%:p')<CR>]])

      -- Quick yank current directory
      nnoremap("<Leader>yd", [[:let @" = getcwd()<CR>]])

      -- Quick split
      nnoremap("<Leader>yt", [[:tab split<CR>]])
      nnoremap("<Leader>ys", [[:split<CR>]])
      nnoremap("<Leader>yv", [[:vertical split<CR>]])

      -- Copy unnamed register to system clipboard
      nnoremap("<Space>sr", [[:let @+ = @"<CR>]])
      nnoremap("<Space>sR", [[:let @" = @+<CR>]])

      -- Trim system clipboard to 7 chars (for git commit sha)
      nnoremap("<Space>s7", [[:let @+ = @+[0:6]<CR>]])

      -- Command line & Insert mode mapping
      cnoremap("<C-G><C-G>", [[<C-G>]])
      inoremap("<C-G><C-G>", [[<C-G>]])
      cnoremap("<C-G><C-F>", [[vimrc#fzf#files_in_commandline()]], "<expr>")
      inoremap("<C-G><C-F>", [[vimrc#fzf#files_in_commandline()]], "<expr>")
      -- <BS> and <C-H> are the same key when $TERM is 'xterm'
      cnoremap("<C-G><BS>", [[vimrc#fzf#mru#mru_in_commandline()]], "<expr>")
      inoremap("<C-G><BS>", [[vimrc#fzf#mru#mru_in_commandline()]], "<expr>")
      cnoremap("<C-G><C-H>", [[vimrc#fzf#mru#mru_in_commandline()]], "<expr>")
      inoremap("<C-G><C-H>", [[vimrc#fzf#mru#mru_in_commandline()]], "<expr>")
      cnoremap("<C-G><C-M>", [[vimrc#fzf#mru#directory_mru_in_commandline()]], "<expr>")
      inoremap("<C-G><C-M>", [[vimrc#fzf#mru#directory_mru_in_commandline()]], "<expr>")
      cnoremap("<C-G><C-P>", [[vimrc#rg#current_type_option()]], "<expr>")
      inoremap("<C-G><C-P>", [[vimrc#rg#current_type_option()]], "<expr>")
      cnoremap("<C-G><C-L>", [[vimrc#rg#types_in_commandline()]], "<expr>")
      inoremap("<C-G><C-L>", [[vimrc#rg#types_in_commandline()]], "<expr>")
      -- Expand filename
      -- TODO: Use one key to invoke fzf and expand to different filenames
      cnoremap("<C-G><C-^>", [[expand('%:t')]], "<expr>")
      inoremap("<C-G><C-^>", [[expand('%:t')]], "<expr>")
      -- <C-]> and <C-%> are the same key
      cnoremap("<C-G><C-]>", [[expand('%:t:r')]], "<expr>")
      inoremap("<C-G><C-]>", [[expand('%:t:r')]], "<expr>")
      -- <C-\> and <C-$> are the same key
      cnoremap([[<C-G><C-\>]], [[expand('%:p')]], "<expr>")
      inoremap([[<C-G><C-\>]], [[expand('%:p')]], "<expr>")
      -- Expand buffer folder
      cnoremap("<C-G><C-R>", [[expand('%:h')]], "<expr>")
      inoremap("<C-G><C-R>", [[expand('%:h')]], "<expr>")
      -- For grepping word
      cnoremap("<C-G><C-W>", [["\\b" . expand('<cword>') . "\\b"]], "<expr>")
      cnoremap("<C-G><C-A>", [["\\b" . expand('<cWORD>') . "\\b"]], "<expr>")
      cnoremap("<C-G>b", [["\<C-B>\\b\<C-E>\\b"]], "<expr>")
      cnoremap("<C-G>B", [["\<C-B>\\<\<C-E>\\>"]], "<expr>")
      -- Fugitive commit sha
      cnoremap("<C-G><C-Y>", [[vimrc#fugitive#commit_sha()]], "<expr>")
      inoremap("<C-G><C-Y>", [[vimrc#fugitive#commit_sha()]], "<expr>")
      -- Fill commit
      cnoremap("<C-G><C-I>", [[vimrc#fzf#git#commits_in_commandline(0, [])]], "<expr>")
      inoremap("<C-G><C-I>", [[vimrc#fzf#git#commits_in_commandline(0, [])]], "<expr>")
      -- FIXME: Currently, use bcommits command with fzf-tmux will cause error
      -- Vim(let):E684: list index out of range: 1
      cnoremap("<C-G><C-O>", [[vimrc#fzf#git#commits_in_commandline(1, [])]], "<expr>")
      inoremap("<C-G><C-O>", [[vimrc#fzf#git#commits_in_commandline(1, [])]], "<expr>")
      -- Fill branches
      cnoremap("<C-X>b", [[vimrc#git#get_current_branch()]], "<expr>")
      inoremap("<C-X>b", [[vimrc#git#get_current_branch()]], "<expr>")
      cnoremap("<C-G><C-B>", [[vimrc#fzf#git#branches_in_commandline()]], "<expr>")
      inoremap("<C-G><C-B>", [[vimrc#fzf#git#branches_in_commandline()]], "<expr>")
      cnoremap("<C-G><C-T>", [[vimrc#fzf#git#tags_in_commandline()]], "<expr>")
      inoremap("<C-G><C-T>", [[vimrc#fzf#git#tags_in_commandline()]], "<expr>")
      cnoremap("<C-G><C-X>", [[vimrc#fzf#git#diff_files_in_commandline()]], "<expr>")
      inoremap("<C-G><C-X>", [[vimrc#fzf#git#diff_files_in_commandline()]], "<expr>")
      -- Fill git email
      cnoremap("<C-G><C-E>", [[vimrc#git#get_email()]], "<expr>")
      inoremap("<C-G><C-E>", [[vimrc#git#get_email()]], "<expr>")
      -- Get visual selection
      cnoremap("<C-G><C-V>", [[vimrc#utility#get_visual_selection()]], "<expr>")
      -- Trim command line content (Use <Space> to separate `<C-\>e` and function)
      cnoremap("<C-G>t", [[<C-\>e<Space>vimrc#insert#trim_cmdline()<CR>]])
      -- Delete whole word (Use <Space> to separate `<C-\>e` and function)
      cnoremap("<C-G>w", [[<C-\>e<Space>vimrc#insert#delete_whole_word()<CR>]])
      -- Delete subword (Use <Space> to separate `<C-\>e` and function)
      cnoremap("<C-X><C-B>", [[<C-\>e<Space>v:lua.require("vimrc.cmdline").delete_subword()<CR>]])
      -- Company related data
      cnoremap("<C-G>d", [[<C-R>=g:company_domain<CR>]])
      cnoremap("<C-G>e", [[<C-R>=g:company_email<CR>]])
      -- Manipulate register content
      cnoremap("<C-G>4", [[<C-R>=fnamemodify(@", ':p')<CR>]])
      inoremap("<C-G>4", [[<C-R>=fnamemodify(@", ':p')<CR>]])
      cnoremap("<C-G>5", [[<C-R>=fnamemodify(@", ':t:r')<CR>]])
      inoremap("<C-G>5", [[<C-R>=fnamemodify(@", ':t:r')<CR>]])
      cnoremap("<C-G>6", [[<C-R>=fnamemodify(@", ':t')<CR>]])
      inoremap("<C-G>6", [[<C-R>=fnamemodify(@", ':t')<CR>]])
      cnoremap("<C-G>r", [[<C-R>=fnamemodify(@", ':h')<CR>]])
      inoremap("<C-G>r", [[<C-R>=fnamemodify(@", ':h')<CR>]])
      -- Insert date
      cnoremap("<C-G>D", [[<C-R>=systemlist('env LC_ALL=C date +"%Y/%m/%d"')[0]<CR>]])
      inoremap("<C-G>D", [[<C-R>=systemlist('env LC_ALL=C date +"%Y/%m/%d"')[0]<CR>]])
      -- Insert shell output
      cnoremap("<C-X><C-X>", [[vimrc#fzf#shell_outputs_in_commandline()]], "<expr>")
      inoremap("<C-X><C-X>", [[vimrc#fzf#shell_outputs_in_commandline()]], "<expr>")
      -- Command palette
      cnoremap("<C-X><C-Z>", [[<C-C><Cmd>Telescope command_palette<CR>]])
      cnoremap("<C-X><C-S>", [[<C-C><Cmd>CommandPalette<CR>]])

      -- Ex mode for special buffer that map("'q'", [[as ':quit']])
      nnoremap([[\q:]], [[q:]])
      nnoremap([[\q/]], [[q/]])
      nnoremap([[\q?]], [[q?]])

      -- <Leader><F10> for syncing syntax highlight from start
      nnoremap("<Leader><F10>", [[:syntax sync fromstart<CR>]])

      -- Execute last command
      -- Note: @: should execute last command, but didn't work when using
      -- vimrc#execute_and_save()
      nnoremap("<M-x><M-x>", [[:<C-P><CR>]])

      -- Substitute visual selection
      xnoremap("<M-s>", [[:s/\%V]])

      -- Find non-ASCII character
      map("<M-x>", [[<Plug>(non-ascii-find)]])
      noremap("<Plug>(non-ascii-find)", [[<NOP>]])
      nnoremap("<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>:nohlsearch<CR>]], "<silent>")
      xnoremap("<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>]], "<silent>")
      onoremap("<Plug>(non-ascii-find)<M-n>", [[/[^\x00-\x7F]<CR>]], "<silent>")
      nnoremap("<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>:nohlsearch<CR>]], "<silent>")
      xnoremap("<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>]], "<silent>")
      onoremap("<Plug>(non-ascii-find)<M-p>", [[?[^\x00-\x7F]<CR>]], "<silent>")
      xnoremap("<Plug>(non-ascii-find)<M-s>", [[?[^\x00-\x7F]<CR>lo/[^\x00-\x7F]<CR>]], "<silent>")
      onoremap("<Plug>(non-ascii-find)<M-s>", [[:<C-U>call vimrc#textobj#inner_surround_unicode()<CR>]], "<silent>")
      xnoremap("<Plug>(non-ascii-find)<M-S>", [[?[^\x00-\x7F]<CR>o/[^\x00-\x7F]<CR>l]], "<silent>")
      onoremap("<Plug>(non-ascii-find)<M-S>", [[:<C-U>call vimrc#textobj#around_surround_unicode()<CR>]], "<silent>")

      -- Find character past specified character
      nnoremap("<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:true)<CR>]], "<silent>")
      xnoremap("<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:true)<CR>]], "<silent>")
      onoremap("<M-p>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:true)<CR>]], "<silent>")
      nnoremap("<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'n', v:false)<CR>]], "<silent>")
      xnoremap("<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'v', v:false)<CR>]], "<silent>")
      onoremap("<M-P>", [[:<C-U>call vimrc#textobj#past_character(v:count1, 'o', v:false)<CR>]], "<silent>")

      -- Text Objects
      -- ie = inner entire buffer
      onoremap("ie", ':exec "normal! ggVG"<CR>')
      xnoremap("ie", ':<C-U>exec "normal! ggVG"<CR>')

      -- iV = current viewable text in the buffer
      onoremap("iV", ':exec "normal! HVL"<CR>')
      xnoremap("iV", ':<C-U>exec "normal! HVL"<CR>')

      -- Search
      -- TODO: Extract to search.vim?
      nmap("<M-s>", "<Plug>(search-prefix)")
      nnoremap("<M-s><M-s>", [[<M-s>]])
      noremap("<Plug>(search-prefix)", [[<NOP>]])
      nnoremap("<Plug>(search-prefix)f", [[<Cmd>call vimrc#search#search_file(0)<CR>]])
      nnoremap("<Plug>(search-prefix)y", [[<Cmd>call vimrc#search#search_hash(0)<CR>]])
      nnoremap("<Plug>(search-prefix)u", [[<Cmd>call vimrc#search#search_url(0)<CR>]])
      nnoremap("<Plug>(search-prefix)i", [[<Cmd>call vimrc#search#search_ip(0)<CR>]])

      -- Search within visual selection
      xnoremap("<M-/>", [[<Esc>/\%V]])
      xnoremap("<M-?>", [[<Esc>?\%V]])

      -- Diff
      -- Use <M-d> as prefix
      nnoremap("<M-d>t", [[:windo diffthis<CR>]])
      nnoremap("<M-d>o", [[:windo diffoff<CR>]])
      nnoremap("<M-d>h", [[:diffthis<CR>:wincmd l<CR>:diffthis<CR>:2wincmd h<CR>:diffthis<CR>]])
      nnoremap("<M-d>v", [[:diffthis<CR>:wincmd j<CR>:diffthis<CR>:2wincmd k<CR>:diffthis<CR>]])
      if choose.is_enabled_plugin('vim-floaterm') then
        nnoremap("<M-d>f", [[<Cmd>lua require('vimrc.diff').diff_in_delta()<CR>]])
      end

      -- Sort
      xnoremap("<Space>ss", [[d:execute 'normal i'.vimrc#utility#sort_copied_words()<CR>]], "<silent>")

      -- Retab
      nnoremap("<Space>r5", [[:%retab!<CR>]])

      -- Select Mode
      snoremap("<CR>", [[<C-O>c]])
      snoremap("<M-a>", [[<Esc>A]])
      snoremap("<M-i>", [[<C-O>o<Esc>i]])

      -- Smart dd
      -- Ref: https://www.reddit.com/r/neovim/comments/w0jzzv/smart_dd/
      nnoremap("dd", [[v:lua.require("vimrc.mapping").smart_dd()]], "<expr>")

      -- Man
      -- :Man is defined in $VIMRUNTIME/plugin/man.vim which is loaded after .vimrc
      -- TODO Move this to 'after' folder
      -- TODO Detect goyo mode and use normal :Man
      nnoremap("<Leader><F1>", [[:Man<Space>]])
      nnoremap("<Leader><F2>", [[:VimrcFloatNew! Man<Space>]])

      -- Inspect
      nnoremap("<Space>hi", [[<Cmd>Inspect<CR>]])

      -- Print visual selection info
      -- TODO: Do not leave visual mode, use nvim-notify
      xnoremap("g<C-G>", "g<C-G>:<C-U>lua vim.notify(vim.v.statusmsg)<CR>")

      -- Custom function {{{
      vim.api.nvim_create_user_command("ToggleIndent", [[call vimrc#toggle#toggle#indent()]], {})
      vim.api.nvim_create_user_command("ToggleFold", [[call vimrc#toggle#fold_method()]], {})
      nnoremap("cof", [[:ToggleFold<CR>]])

      -- LastTab
      vim.api.nvim_create_user_command("LastTab", [[call vimrc#last_tab#jump(<count>)]], { count = true, bar = true })
      nnoremap("<M-1>", [[:call vimrc#last_tab#jump(v:count)<CR>]])

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
      nnoremap("yoP", [[:ToggleParentFolderTag<CR>]], "<silent>")

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
      nnoremap("Zd", [[:Bdi<CR>]])
      nnoremap("ZD", [[:Bdi!<CR>]])
      nnoremap("Z<C-D>", [[:Bdi! include_modified<CR>]])
      nnoremap("Zw", [[:Bdi wipeout<CR>]])
      nnoremap("ZW", [[:Bdi! wipeout<CR>]])
      nnoremap("Z<C-W>", [[:Bdi! wipeout include_modified<CR>]])

      vim.api.nvim_create_user_command("TrimWhitespace", [[call vimrc#utility#trim_whitespace()]], {})

      vim.api.nvim_create_user_command("DisplayChar", [[lua require("vimrc.utils").display_char()]], {})

      vim.api.nvim_create_user_command("ReloadVimrc", [[call vimrc#reload#reload()]], {})

      vim.api.nvim_create_user_command(
        "QuickfixOutput",
        [[call vimrc#quickfix#execute(<f-args>)]],
        { nargs = 1, complete = "command" }
      )
      nnoremap("<Leader>oq", [[:execute 'QuickfixOutput '.input('OuickfixOutput: ', '', 'command')<CR>]])
      vim.api.nvim_create_user_command(
        "LocationOutput",
        [[call vimrc#quickfix#loc_execute(<f-args>)]],
        { nargs = 1, complete = "command" }
      )
      nnoremap("<Leader>ol", [[:execute 'LocationOutput '.input('LocationOutput: ', '', 'command')<CR>]])

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

      vim.api.nvim_create_user_command("ToggleOpenUrlForceLocal", function()
        require("vimrc.mapping").toggle_open_url_force_local()
      end, {})

      local initial_working_directory = vim.fn.getcwd()
      vim.api.nvim_create_user_command("ResetWorkingDirectory", function()
        vim.cmd.cd(initial_working_directory)
      end, {})
      -- }}}
    end,
  })
end

return mapping
