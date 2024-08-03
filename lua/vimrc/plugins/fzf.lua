local choose = require("vimrc.choose")

local fzf = {}

fzf.setup_config = function()
  if not vim.g.original_fzf_default_opts then
    vim.g.original_fzf_default_opts = vim.env.FZF_DEFAULT_OPTS
  end
  vim.env.FZF_DEFAULT_OPTS = vim.g.original_fzf_default_opts
    .. " "
    .. vim.fn.join(vim.fn["vimrc#fzf#get_default_options"]().options)

  vim.g.fzf_colors = {
    ["fg"] = { "fg", "Normal" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", "Comment" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Statement" },
    ["info"] = { "fg", "PreProc" },
    ["border"] = { "fg", "Ignore" },
    ["prompt"] = { "fg", "Conditional" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Keyword" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
  }

  vim.g.fzf_layout = { window = { width = vim.g.float_width_ratio, height = vim.g.float_height_ratio } }
  vim.g.fzf_tmux_layout = { tmux = "90%,80%" }

  vim.g.fzf_history_dir = vim.env.HOME .. "/.local/share/fzf-history"

  vim.g.misc_fzf_action = {
    ["ctrl-q"] = vim.fn["vimrc#fzf#build_quickfix_list"],
    ["alt-c"] = vim.fn["vimrc#fzf#copy_results"],
    ["alt-e"] = "cd",
    ["alt-t"] = vim.fn["vimrc#fzf#open_terminal"],
    ["f4"] = "diffsplit",
  }
  vim.g.default_fzf_action = vim.fn["vimrc#fzf#wrap_actions_for_trigger"](vim.fn.extend({
    ["ctrl-t"] = "tab split",
    ["ctrl-s"] = "split",
    ["ctrl-x"] = "split",
    ["alt-g"] = "rightbelow split",
    ["ctrl-v"] = "vsplit",
    ["alt-v"] = "rightbelow vsplit",
    ["alt-z"] = "VimrcFloatNew split",
    ["alt-l"] = "Switch",
  }, vim.g.misc_fzf_action))
  vim.g.fzf_action = vim.g.default_fzf_action

  -- TODO: Generalize vim.g.fzf_action_type
  -- Currently, this is only used in vimrc#fzf#line#lines_sink() which used in
  -- :Lines
  vim.g.fzf_action_type = {
    ['alt-l'] = {
      type = 'file',
      need_argument = true
    }
  }
end

fzf.setup_command = function()
  -- stylua: ignore start
  -- fzf functions & commands {{{
  vim.cmd([[command! -bar  -bang                  Helptags call vimrc#fzf#helptags(<bang>0)]])
  vim.cmd([[command! -bang -nargs=? -complete=dir Files    call vimrc#fzf#files(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=?               GFiles   call vimrc#fzf#gitfiles(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=+ -complete=dir Locate   call vimrc#fzf#locate(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=*               History  call vimrc#fzf#history(<q-args>, <bang>0)]])
  vim.cmd([[command! -bar  -bang                  Windows  call fzf#vim#windows(vimrc#fzf#preview#windows(), <bang>0)]])
  vim.cmd([[command! -bar  -nargs=* -bang         BLines   call vimrc#fzf#line#buffer_lines(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=*               Lines    call vimrc#fzf#line#lines(<q-args>, vimrc#fzf#with_default_options(), <bang>0)]])

  -- Rg
  vim.cmd([[command! -bang -nargs=* Rg call vimrc#fzf#rg#grep(<q-args>, <bang>0)]])

  -- Rg with option, using ':' to separate folder, option and query
  vim.cmd([[command! -bang -nargs=* RgWithOption call vimrc#fzf#rg#grep_with_option(<q-args>, <bang>0)]])

  -- RgFzf - Ripgrep with reload on change
  vim.cmd([[command! -bang -nargs=* RgFzf call vimrc#fzf#rg#grep_on_change(<q-args>, <bang>0)]])

  -- Rga - Ripgrep-all with custom command, using ':' to separate folder, option and query
  vim.cmd([[command! -bang -nargs=* Rga call vimrc#fzf#rg#rga(<q-args>, <bang>0)]])

  -- Matched files
  vim.cmd([[command! -bang -nargs=? -complete=dir MatchedFiles call vimrc#fzf#rg#matched_files(<q-args>, <bang>0)]])

  -- Fd all files
  vim.cmd([[command! -bang -nargs=? -complete=dir AllFiles call vimrc#fzf#dir#all_files(<q-args>, <bang>0)]])

  -- Fd custom files
  vim.cmd([[command! -bang -nargs=? -complete=dir CustomFiles call vimrc#fzf#dir#custom_files(<q-args>, <bang>0)]])

  -- Git diff
  vim.cmd([[command! -bang -nargs=* -complete=dir GitDiffFiles call vimrc#fzf#git#diff_tree(<bang>0, <f-args>)]])
  vim.cmd([[command! -bang -nargs=* -complete=dir RgGitDiffFiles call vimrc#fzf#git#rg_diff(<bang>0, <f-args>)]])

  -- Mru
  vim.cmd([[command! Mru        call vimrc#fzf#mru#mru()]])
  vim.cmd([[command! ProjectMru call vimrc#fzf#mru#project_mru()]])

  -- DirectoryMru
  vim.cmd([[command! -bang DirectoryMru      call vimrc#fzf#mru#directory_mru(<bang>0)]])
  vim.cmd([[command! -bang DirectoryMruFiles call vimrc#fzf#mru#directory_mru_files(<bang>0)]])
  vim.cmd([[command! -bang DirectoryMruRg    call vimrc#fzf#mru#directory_mru_rg(<bang>0)]])

  -- Directory
  vim.cmd([[command! -bang -nargs=? -complete=dir Directories    call vimrc#fzf#dir#directories(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=? -complete=dir DirectoryFiles call vimrc#fzf#dir#directory_files(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=? -complete=dir DirectoryRg    call vimrc#fzf#dir#directory_rg(<q-args>, <bang>0)]])

  -- Tselect
  vim.cmd([[command! -nargs=1 Tselect        call vimrc#fzf#tag#tselect(<q-args>)]])
  vim.cmd([[command! -nargs=1 ProjectTselect call vimrc#fzf#tag#project_tselect(<q-args>)]])

  -- Jumps
  vim.cmd([[command! Jumps call vimrc#fzf#jumps()]])

  -- Registers
  if vim.fn.exists(':Registers') ~= 2 then
    vim.cmd([[command! Registers call vimrc#fzf#registers()]])
  end

  -- DirectoryAncestors
  vim.cmd([[command! DirectoryAncestors call vimrc#fzf#dir#directory_ancestors()]])

  -- Range
  vim.cmd([[command! -nargs=? -range SelectLines call vimrc#fzf#range#range_lines('SelectLines', 1, <line1>, <line2>, <q-args>)]])
  vim.cmd([[command! -nargs=?        ScreenLines call vimrc#fzf#range#screen_lines(<q-args>)]])

  -- FilesWithQuery
  vim.cmd([[command! -nargs=1 FilesWithQuery call vimrc#fzf#files_with_query(<q-args>)]])

  -- CurrentPlacedSigns
  vim.cmd([[command! CurrentPlacedSigns call vimrc#fzf#current_placed_signs()]])

  -- Functions
  vim.cmd([[command! Functions call vimrc#fzf#functions()]])

  -- Punctuations
  vim.cmd([[command! Punctuations call vimrc#fzf#chinese#punctuations()]])

  -- Compilers
  vim.cmd([[command! -bang Compilers call vimrc#fzf#compilers(<bang>0)]])

  -- Outputs
  vim.cmd([[command! -nargs=* Outputs call vimrc#fzf#outputs(<q-args>)]])

  -- Git commit command {{{
  -- GitGrepCommit
  vim.cmd([[command! -nargs=+ -complete=customlist,fugitive#CompleteObject GitGrepCommit call vimrc#fzf#git#grep_commit(<f-args>)]])
  vim.cmd([[command! -nargs=* GitGrep call vimrc#fzf#git#grep_commit('', <q-args>)]])
  vim.cmd([[command! -nargs=* GitGrepAllCommits call vimrc#fzf#git#grep_all_commits(<q-args>)]])
  vim.cmd([[command! -nargs=* GitGrepBranches call vimrc#fzf#git#grep_branches(<q-args>)]])
  vim.cmd([[command! -nargs=* GitGrepCurrentBranch call vimrc#fzf#git#grep_current_branch(<q-args>)]])

  -- GitDiffCommit
  vim.cmd([[command! -nargs=? -complete=customlist,fugitive#CompleteObject GitDiffCommit call vimrc#fzf#git#diff_commit(<f-args>)]])

  -- GitDiffCommits
  vim.cmd([[command! -nargs=+ -complete=customlist,fugitive#CompleteObject GitDiffCommits call vimrc#fzf#git#diff_commits(<f-args>)]])

  -- GitFilesCommit
  vim.cmd([[command! -nargs=1 -complete=customlist,fugitive#CompleteObject GitFilesCommit call vimrc#fzf#git#files_commit(<q-args>)]])
  -- }}}

  -- Keywords
  vim.cmd([[command! -nargs=* Keywords call vimrc#fzf#git#keywords(<q-args>)]])
  vim.cmd([[command! -nargs=* Todos    call vimrc#fzf#git#keywords('TODO:?\s*'.<q-args>)]])
  vim.cmd([[command! -nargs=* Fixmes   call vimrc#fzf#git#keywords('FIXME:?\s*'.<q-args>)]])

  -- KeywordsByMe
  vim.cmd([[command! -nargs=* KeywordsByMe call vimrc#fzf#git#keywords_by_me(<q-args>)]])
  vim.cmd([[command! -nargs=* TodosByMe    call vimrc#fzf#git#keywords_by_me('TODO:?\s*'.<q-args>)]])
  vim.cmd([[command! -nargs=* FixmesByMe   call vimrc#fzf#git#keywords_by_me('FIXME:?\s*'.<q-args>)]])

  -- TodosInDisk & FixmesInDisk
  vim.cmd([[command! TodosInDisk  RgWithOption :-w:TODO]])
  vim.cmd([[command! FixmesInDisk RgWithOption :-w:FIXME]])

  -- LastTabs
  vim.cmd([[command! LastTabs call vimrc#fzf#last_tab#last_tabs()]])

  -- Command Palette
  vim.cmd([[command! CommandPalette lua require("vimrc.plugins.command_palette").open_with_fzf()]])

  -- Tags
  -- Too bad fzf cannot toggle case sensitive interactively
  vim.cmd([[command! -bang -nargs=* ProjectTags              call vimrc#fzf#tag#project_tags(<q-args>, <bang>0)]])
  vim.cmd([[command! -bang -nargs=* BTagsCaseSentitive       call fzf#vim#buffer_tags(<q-args>, vimrc#fzf#preview#buffer_tags_options({ 'options': ['+i'] }), <bang>0)]])
  vim.cmd([[command! -bang -nargs=* TagsCaseSentitive        call fzf#vim#tags(<q-args>,               { 'options': ['+i'] }, <bang>0)]])
  vim.cmd([[command! -bang -nargs=* ProjectTagsCaseSentitive call vimrc#fzf#tag#project_tags(<q-args>, { 'options': ['+i'] }, <bang>0)]])

  -- WorkTreeFiles
  vim.cmd([[command! -bang -nargs=? WorkTreeFiles call vimrc#fzf#work_tree_files(<bang>0)]])

  if choose.is_enabled_plugin('defx.nvim') then
    vim.cmd([[command! -bang -nargs=? -complete=dir Files        call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#files(<q-args>, <bang>0) })]])
    vim.cmd([[command! -bang -nargs=?               GFiles       call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#gitfiles(<q-args>, <bang>0) })]])
    vim.cmd([[command! -bang -nargs=+ -complete=dir Locate       call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#locate(<q-args>, <bang>0) })]])

    -- Mru
    vim.cmd([[command!                              Mru          call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#mru#mru() })]])
    vim.cmd([[command!                              ProjectMru   call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#mru#project_mru() })]])

    -- DirectoryMru
    vim.cmd([[command! -bang                        DirectoryMru call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#mru#directory_mru(<bang>0) })]])
    vim.cmd([[command! -bang -nargs=?               Directories  call vimrc#fzf#defx#use_defx_fzf_action({ -> vimrc#fzf#dir#directories(<q-args>, <bang>0) })]])

    -- WorkTreeFiles
    vim.cmd([[command! -bang -nargs=?               WorkTreeFiles call vimrc#fzf#work_tree_files(<bang>0)]])
  end
  -- }}}
  -- stylua: ignore end
end

fzf.setup_mapping = function()
  local fzf_prefix = [[<Space>f]]
  local fzf_misc_prefix = [[<Space>s]]
  local fzf_git_prefix = [[<Space>g]]
  local fzf_cscope_prefix = [[\c]]

  -- stylua: ignore start
  -- Mapping selecting mappings
  nmap(fzf_prefix .. [[<Tab>]], [[<Plug>(fzf-maps-n)]])
  imap([[<M-`><M-`>]],    [[<Plug>(fzf-maps-i)]])
  xmap(fzf_prefix .. [[<Tab>]], [[<Plug>(fzf-maps-x)]])
  omap(fzf_prefix .. [[<Tab>]], [[<Plug>(fzf-maps-o)]])

  -- Insert mode completion
  imap([[<C-X><C-K>]], [[<Plug>(fzf-complete-word)]])
  inoremap([[<C-X><C-F>]], [[fzf#vim#complete#path('fd -t f --strip-cwd-prefix')]], { expr = true })

  -- <C-J> is <NL>
  imap([[<C-X><C-L>]], [[<Plug>(fzf-complete-line)]])
  inoremap([[<C-X><C-D>]], [[fzf#vim#complete#path('fd -t d --strip-cwd-prefix')]], { expr = true })
  inoremap([[<M-x><M-p>]], [[vimrc#fzf#chinese#punctuations_in_insert_mode()]],     { expr = true })

  -- fzf key mappings {{{
  nnoremap(fzf_prefix .. [[A]],     [[:call      vimrc#execute_and_save('AllFiles')<CR>]])
  nnoremap(fzf_prefix .. [[1]],     [[:call      vimrc#execute_and_save('CustomFiles ::' . input('Fd: '))<CR>]])
  nnoremap(fzf_prefix .. [[!]],     [[:call      vimrc#execute_and_save('CustomFiles ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Fd: '))<CR>]])
  nnoremap(fzf_prefix .. [[2]],     [[:call      vimrc#execute_and_save('MatchedFiles ::' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[@]],     [[:call      vimrc#execute_and_save('MatchedFiles ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[b]],     [[:call      vimrc#execute_and_save('Buffers')<CR>]])
  nnoremap(fzf_prefix .. [[B]],     [[:call      vimrc#execute_and_save('Files %:h')<CR>]])
  nnoremap(fzf_prefix .. [[c]],     [[:call      vimrc#execute_and_save('BCommits')<CR>]])
  nnoremap(fzf_prefix .. [[C]],     [[:call      vimrc#execute_and_save('Commits')<CR>]])
  nnoremap(fzf_prefix .. [[d]],     [[:call      vimrc#execute_and_save('Directories')<CR>]])
  nnoremap(fzf_prefix .. [[D]],     [[:call      vimrc#execute_and_save('DirectoryFiles')<CR>]])
  nnoremap(fzf_prefix .. [[<C-D>]], [[:call      vimrc#execute_and_save('RgGitDiffFiles ' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[e]],     [[:call      vimrc#execute_and_save('RgWithOption ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[E]],     [[:call      vimrc#execute_and_save('RgWithOption! ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[3]],     [[:call      vimrc#execute_and_save('RgWithOption ' . expand('%') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[f]],     [[:call      vimrc#execute_and_save('Files')<CR>]])
  nnoremap(fzf_prefix .. [[F]],     [[:call      vimrc#execute_and_save('DirectoryRg')<CR>]])
  nnoremap(fzf_prefix .. [[<C-F>]], [[:call      vimrc#execute_and_save('FilesWithQuery ' . expand('<cfile>'))<CR>]])
  nnoremap(fzf_prefix .. [[g]],     [[:call      vimrc#execute_and_save('GFiles -co --exclude-standard')<CR>]])
  nnoremap(fzf_prefix .. [[G]],     [[:call      vimrc#execute_and_save('GitGrep ' . input('Git grep: '))<CR>]])
  nnoremap(fzf_prefix .. [[<C-G>]], [[:call      vimrc#execute_and_save('GitGrepCommit ' . input('Commit: ') . ' ' . input('Git grep: '))<CR>]])
  nnoremap(fzf_prefix .. [[h]],     [[:call      vimrc#execute_and_save('Helptags')<CR>]])
  nnoremap(fzf_prefix .. [[H]],     [[:call      vimrc#execute_and_save('GitFilesCommit ' . input('Commit: '))<CR>]])
  nnoremap(fzf_prefix .. [[i]],     [[:call      vimrc#execute_and_save('RgFzf')<CR>]])
  nnoremap(fzf_prefix .. [[I]],     [[:call      vimrc#execute_and_save('RgFzf!')<CR>]])
  nnoremap(fzf_prefix .. [[9]],     [[:call      vimrc#execute_and_save('RgFzf ' . input('RgFzf: '))<CR>]])
  nnoremap(fzf_prefix .. [[(]],     [[:call      vimrc#execute_and_save('RgFzf! ' . input('RgFzf!: '))<CR>]])
  nnoremap(fzf_prefix .. [[j]],     [[:call      vimrc#execute_and_save('Jumps')<CR>]])
  nnoremap(fzf_prefix .. [[k]],     [[:call      vimrc#execute_and_save('Rg ' . expand('<cword>'))<CR>]])
  nnoremap(fzf_prefix .. [[K]],     [[:call      vimrc#execute_and_save('Rg ' . expand('<cWORD>'))<CR>]])
  nnoremap(fzf_prefix .. [[8]],     [[:call      vimrc#execute_and_save('Rg \b' . expand('<cword>') . '\b')<CR>]])
  nnoremap(fzf_prefix .. [[*]],     [[:call      vimrc#execute_and_save('Rg \b' . expand('<cWORD>') . '\b')<CR>]])
  xnoremap(fzf_prefix .. [[k]],     [[:<C-U>call vimrc#execute_and_save('Rg ' . vimrc#utility#get_visual_selection())<CR>]])
  xnoremap(fzf_prefix .. [[8]],     [[:<C-U>call vimrc#execute_and_save('Rg \b' . vimrc#utility#get_visual_selection() . '\b')<CR>]])
  nnoremap(fzf_prefix .. [[l]],     [[:call      vimrc#execute_and_save('BLines')<CR>]])
  nnoremap(fzf_prefix .. [[L]],     [[:call      vimrc#execute_and_save('Lines')<CR>]])
  nnoremap(fzf_prefix .. [[<C-L>]], [[:call      vimrc#execute_and_save('BLines ' . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. [[<C-L>]], [[:<C-U>call vimrc#execute_and_save('BLines ' . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[m]],     [[:call      vimrc#execute_and_save('Mru')<CR>]])
  nnoremap(fzf_prefix .. [[M]],     [[:call      vimrc#execute_and_save('DirectoryMru')<CR>]])
  nnoremap(fzf_prefix .. [[<C-M>]], [[:call      vimrc#execute_and_save('ProjectMru')<CR>]])
  nnoremap(fzf_prefix .. [[n]],     [[:call      vimrc#execute_and_save('FilesWithQuery ' . expand('<cword>'))<CR>]])
  nnoremap(fzf_prefix .. [[N]],     [[:call      vimrc#execute_and_save('FilesWithQuery ' . expand('<cWORD>'))<CR>]])
  nnoremap(fzf_prefix .. [[%]],     [[:call      vimrc#execute_and_save('FilesWithQuery ' . expand('%:t:r'))<CR>]])
  nnoremap(fzf_prefix .. [[^]],     [[:call      vimrc#execute_and_save('FilesWithQuery ' . expand('%:t'))<CR>]])
  xnoremap(fzf_prefix .. [[n]],     [[:<C-U>call vimrc#execute_and_save('FilesWithQuery ' . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[o]],     [[:call      vimrc#execute_and_save('History')<CR>]])
  nnoremap(fzf_prefix .. [[O]],     [[:call      vimrc#execute_and_save('Locate ' . input('Locate: '))<CR>]])
  nnoremap(fzf_prefix .. [[<M-p>]], [[:call      vimrc#execute_and_save('Punctuations')<CR>]])
  -- TODO: Add :silent to silent E10 error from cmp-cmdline when input pattern is not proper lua string
  nnoremap(fzf_prefix .. [[r]],     [[:call      vimrc#execute_and_save('Rg ' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[R]],     [[:call      vimrc#execute_and_save('Rg! ' . input('Rg!: '))<CR>]])
  nnoremap(fzf_prefix .. [[<C-R>]], [[:call      vimrc#execute_and_save('Rg ' . getreg(v:lua.require("vimrc.utils").get_char_string()))<CR>]])
  nnoremap(fzf_prefix .. [[4]],     [[:call      vimrc#execute_and_save('RgWithOption .:' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[$]],     [[:call      vimrc#execute_and_save('RgWithOption! .:' . input('Option: ') . ':' . input('Rg!: '))<CR>]])
  xnoremap(fzf_prefix .. [[4]],     [[:<C-U>call vimrc#execute_and_save('RgWithOption .:' . input('Option: ') . ':' . vimrc#utility#get_visual_selection())<CR>]])
  xnoremap(fzf_prefix .. [[$]],     [[:<C-U>call vimrc#execute_and_save('RgWithOption! .:' . input('Option: ') . ':\b' . vimrc#utility#get_visual_selection() . '\b')<CR>]])
  nnoremap(fzf_prefix .. [[?]],     [[:call      vimrc#execute_and_save('RgWithOption .:' . vimrc#rg#current_type_option() . ':' . input('Rg: '))<CR>]])
  xnoremap(fzf_prefix .. [[?]],     [[:<C-U>call vimrc#execute_and_save('RgWithOption .:' . vimrc#rg#current_type_option() . ':' . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[5]],     [[:call      vimrc#execute_and_save('RgWithOption ' . expand('%:h') . '::' . input('Rg: '))<CR>]])
  -- TODO: Fix error if not in git repo
  nnoremap(fzf_prefix .. [[6]],     [[:call      vimrc#execute_and_save('RgWithOption ' . FugitiveWorkTree() . '::' . input('Rg: '))<CR>]])
  nnoremap(fzf_prefix .. [[s]],     [[:call      vimrc#execute_and_save('GFiles?')<CR>]])
  nnoremap(fzf_prefix .. [[S]],     [[:call      vimrc#execute_and_save('CurrentPlacedSigns')<CR>]])
  nnoremap(fzf_prefix .. [[t]],     [[:call      vimrc#execute_and_save('BTags')<CR>]])
  nnoremap(fzf_prefix .. [[T]],     [[:call      vimrc#execute_and_save('Tags')<CR>]])
  nnoremap(fzf_prefix .. [[u]],     [[:call      vimrc#execute_and_save('DirectoryAncestors')<CR>]])
  nnoremap(fzf_prefix .. [[U]],     [[:call      vimrc#execute_and_save('DirectoryFiles ..')<CR>]])
  nnoremap(fzf_prefix .. [[<C-U>]], [[:call      vimrc#execute_and_save('DirectoryRg ..')<CR>]])
  nnoremap(fzf_prefix .. [[v]],     [[:call      vimrc#execute_and_save('Colors')<CR>]])
  nnoremap(fzf_prefix .. [[w]],     [[:call      vimrc#execute_and_save('WorkTreeFiles')<CR>]])
  nnoremap(fzf_prefix .. [[W]],     [[:call      vimrc#execute_and_save('Windows')<CR>]])
  nnoremap(fzf_prefix .. [[y]],     [[:call      vimrc#execute_and_save('Filetypes')<CR>]])
  nnoremap(fzf_prefix .. [[Y]],     [[:call      vimrc#execute_and_save('GitFilesCommit ' . vimrc#fugitive#commit_sha())<CR>]])
  nnoremap(fzf_prefix .. [[<C-Y>]], [[:call      vimrc#execute_and_save('GitGrepCommit ' . vimrc#fugitive#commit_sha() . ' ' . input('Git grep: '))<CR>]])
  nnoremap(fzf_prefix .. [[']],     [[:call      vimrc#execute_and_save('Registers')<CR>]])
  nnoremap(fzf_prefix .. [[`]],     [[:call      vimrc#execute_and_save('Marks')<CR>]])
  nnoremap(fzf_prefix .. [[:]],     [[:call      vimrc#execute_and_save('History:')<CR>]])
  xnoremap(fzf_prefix .. [[:]],     [[:<C-U>call vimrc#execute_and_save('History:')<CR>]])
  nnoremap(fzf_prefix .. [[;]],     [[:call      vimrc#execute_and_save('Commands')<CR>]])
  xnoremap(fzf_prefix .. [[;]],     [[:<C-U>call vimrc#execute_and_save('Commands')<CR>]])
  nnoremap(fzf_prefix .. [[/]],     [[:call      vimrc#execute_and_save('History/')<CR>]])
  nnoremap(fzf_prefix .. "]",       [[:call      vimrc#execute_and_save("BTags '" . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. "]",       [[:<C-U>call vimrc#execute_and_save("BTags '" . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[}]],     [[:call      vimrc#execute_and_save("Tags '" . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. [[}]],     [[:<C-U>call vimrc#execute_and_save("Tags '" . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[<C-]>]], [[:call      vimrc#execute_and_save('ProjectTselect ' . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. [[<C-]>]], [[:<C-U>call vimrc#execute_and_save('ProjectTselect ' . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_prefix .. [[<M-]>]], [[:call      vimrc#execute_and_save('Tselect ' . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. [[<M-]>]], [[:<C-U>call vimrc#execute_and_save('Tselect ' . vimrc#utility#get_visual_selection())<CR>]])

  -- Output
  nnoremap([[<Space><F1>]], [[:call vimrc#execute_and_save('Outputs ' . input('Output: ', '', 'command'))<CR>]])
  nnoremap([[<Space><F2>]], [[:call vimrc#execute_and_save("Outputs :map <buffer>")<CR>]])

  -- DirectoryMru
  nnoremap([[<Space><C-D><C-D>]], [[:call vimrc#execute_and_save('DirectoryMru')<CR>]])
  nnoremap([[<Space><C-D><C-F>]], [[:call vimrc#execute_and_save('DirectoryMruFiles')<CR>]])
  nnoremap([[<Space><C-D><C-R>]], [[:call vimrc#execute_and_save('DirectoryMruRg')<CR>]])

  -- Misc
  nnoremap(fzf_misc_prefix .. [[f]], [[:call      vimrc#fzf#range#select_operator('af')<CR>]])
  xnoremap(fzf_misc_prefix .. [[f]], [[:<C-U>call vimrc#execute_and_save("'<,'>SelectLines")<CR>]])
  nnoremap(fzf_misc_prefix .. [[l]], [[:call      vimrc#execute_and_save('ScreenLines')<CR>]])
  nnoremap(fzf_misc_prefix .. [[L]], [[:call      vimrc#execute_and_save('ScreenLines ' . expand('<cword>'))<CR>]])
  xnoremap(fzf_misc_prefix .. [[L]], [[:<C-U>call vimrc#execute_and_save('ScreenLines ' . vimrc#utility#get_visual_selection())<CR>]])
  nnoremap(fzf_misc_prefix .. [[1]], [[:call      vimrc#execute_and_save('LastTabs')<CR>]])

  nnoremap(fzf_misc_prefix .. [[s]], [[:History:<CR>'mks 'vim-sessions<Space>]])

  nnoremap(fzf_misc_prefix .. [[ga]], [[:call vimrc#execute_and_save('GitGrepAllCommits ' . input('Git grep all commits: '))<CR>]])
  nnoremap(fzf_misc_prefix .. [[gA]], [[:call vimrc#execute_and_save('GitGrepAllCommits ' . input('Git grep all commits: ') . ' -- ' . input('File: ', '', 'file'))<CR>]])
  nnoremap(fzf_misc_prefix .. [[gb]], [[:call vimrc#execute_and_save('GitGrepBranches ' . input('Git grep branches: '))<CR>]])
  nnoremap(fzf_misc_prefix .. [[gB]], [[:call vimrc#execute_and_save('GitGrepBranches ' . input('Git grep branches: ') . ' -- ' . input('File: ', '', 'file'))<CR>]])
  nnoremap(fzf_misc_prefix .. [[gc]], [[:call vimrc#execute_and_save('GitGrepCurrentBranch ' . input('Git grep current branch: '))<CR>]])
  nnoremap(fzf_misc_prefix .. [[gC]], [[:call vimrc#execute_and_save('GitGrepCurrentBranch ' . input('Git grep current branch: ') . ' -- ' . input('File: ', '', 'file'))<CR>]])

  nnoremap(fzf_misc_prefix .. [[a]], [[:call vimrc#execute_and_save('Rga ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])
  nnoremap(fzf_misc_prefix .. [[A]], [[:call vimrc#execute_and_save('Rga! ' . input('Folder: ', '', 'dir') . ':' . input('Option: ') . ':' . input('Rg: '))<CR>]])

  -- fzf-checkout
  nnoremap(fzf_git_prefix .. [[c]], [[:GBranches<CR>]])
  nnoremap(fzf_git_prefix .. [[t]], [[:GTag<CR>]])

  if choose.is_enabled_plugin('vim-floaterm') then
    nnoremap([[<Space><M-2>]], [[:call vimrc#execute_and_save('Floaterms')<CR>]])
  end

  -- ProjectTags
  nnoremap(fzf_prefix .. [[p]],   [[:call      vimrc#execute_and_save('ProjectTags')<CR>]])
  nnoremap(fzf_misc_prefix .. [[p]],   [[:call      vimrc#execute_and_save('ProjectTagsCaseSentitive')<CR>]])
  nnoremap(fzf_prefix .. [[P]],   [[:call      vimrc#execute_and_save("ProjectTags " . expand('<cword>'))<CR>]])
  xnoremap(fzf_prefix .. [[P]],   [[:<C-U>call vimrc#execute_and_save("ProjectTags " . vimrc#utility#get_visual_selection())<CR>]])

  -- Command Palette
  nnoremap([[<Space>M]], [[:call vimrc#execute_and_save('CommandPalette')<CR>]])

  -- fzf & cscope key mappings {{{
  nnoremap(fzf_cscope_prefix .. 's', [[:call vimrc#fzf#cscope#cscope("0", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'g', [[:call vimrc#fzf#cscope#cscope("1", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'd', [[:call vimrc#fzf#cscope#cscope("2", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'c', [[:call vimrc#fzf#cscope#cscope("3", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 't', [[:call vimrc#fzf#cscope#cscope("4", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'e', [[:call vimrc#fzf#cscope#cscope("6", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'f', [[:call vimrc#fzf#cscope#cscope("7", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'i', [[:call vimrc#fzf#cscope#cscope("8", expand("<cword>"))<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'a', [[:call vimrc#fzf#cscope#cscope("9", expand("<cword>"))<CR>]], { silent = true })

  xnoremap(fzf_cscope_prefix .. 's', [[:<C-U>call vimrc#fzf#cscope#cscope("0", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'g', [[:<C-U>call vimrc#fzf#cscope#cscope("1", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'd', [[:<C-U>call vimrc#fzf#cscope#cscope("2", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'c', [[:<C-U>call vimrc#fzf#cscope#cscope("3", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 't', [[:<C-U>call vimrc#fzf#cscope#cscope("4", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'e', [[:<C-U>call vimrc#fzf#cscope#cscope("6", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'f', [[:<C-U>call vimrc#fzf#cscope#cscope("7", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'i', [[:<C-U>call vimrc#fzf#cscope#cscope("8", vimrc#utility#get_visual_selection())<CR>]], { silent = true })
  xnoremap(fzf_cscope_prefix .. 'a', [[:<C-U>call vimrc#fzf#cscope#cscope("9", vimrc#utility#get_visual_selection())<CR>]], { silent = true })

  nnoremap(fzf_cscope_prefix .. 'S', [[:call vimrc#fzf#cscope#cscope_query("0")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'G', [[:call vimrc#fzf#cscope#cscope_query("1")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'D', [[:call vimrc#fzf#cscope#cscope_query("2")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'C', [[:call vimrc#fzf#cscope#cscope_query("3")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'T', [[:call vimrc#fzf#cscope#cscope_query("4")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'E', [[:call vimrc#fzf#cscope#cscope_query("6")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'F', [[:call vimrc#fzf#cscope#cscope_query("7")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'I', [[:call vimrc#fzf#cscope#cscope_query("8")<CR>]], { silent = true })
  nnoremap(fzf_cscope_prefix .. 'A', [[:call vimrc#fzf#cscope#cscope_query("9")<CR>]], { silent = true })
  -- }}}
  -- stylua: ignore end
end

fzf.setup_autocmd = function()
  vim.cmd([[augroup fzf_statusline]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd User FzfStatusLine call vimrc#fzf#statusline()]])
  vim.cmd([[augroup END]])
end

fzf.setup = function()
  fzf.setup_config()
  fzf.setup_command()
  fzf.setup_mapping()
  fzf.setup_autocmd()
end

return fzf
