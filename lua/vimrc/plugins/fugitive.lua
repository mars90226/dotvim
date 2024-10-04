local utils = require("vimrc.utils")

local fugitive = {}

-- TODO: Make `:Git push` asynchronous
fugitive.setup = function()
  -- Commands
  vim.cmd([[command! -nargs=1 GitGotoBlameLine call vimrc#fugitive#goto_blame_line(<f-args>)]])
  vim.cmd([[command! GitCloseFugitiveBuffers call vimrc#fugitive#close_all_fugitive_buffers()]])

  -- Mappings
  -- For execute git command
  vim.keymap.set("n", [[<Space>gg]], [[:Git<Space>]])
  vim.keymap.set("n", [[<Space>gG]], [[:Git --paginate<Space>]])
  vim.keymap.set("n", [[<Space>g<Space>]], [[:Git!<Space>]])

  vim.keymap.set("n", [[<Leader>gs]], [[<Cmd>Git<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gS]], [[<Cmd>call vimrc#fugitive#diff_staged_file('%')<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gd]], [[<Cmd>Gdiffsplit<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gD]], [[<Cmd>Gdiffsplit!<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gc]], [[<Cmd>GitGotoBlameLine split<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gC]], [[<Cmd>GitGotoBlameLine edit<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gb]], [[<Cmd>Git blame<CR>]], { silent = true })
  vim.keymap.set("x", [[<Leader>gb]], [[<Cmd>Git blame<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gB]], [[<Cmd>GBrowse<CR>]], { silent = true })
  vim.keymap.set("x", [[<Leader>gB]], [[<Cmd>GBrowse<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>ge]], [[<Cmd>Gedit<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gE]], [[:Gedit<Space>]])
  -- TODO Use :Gllog instead, currently :0Gllog do not work
  vim.keymap.set("n", [[<Leader>gl]], [[<Cmd>Gclog<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gL]], [[<Cmd>0Gclog<CR>]], { silent = true })
  vim.keymap.set(
    "x",
    [[<Leader>gl]],
    [[:<C-U>execute 'Git log -L '.getpos("'<")[1].','.getpos("'>")[1].':%'<CR>]],
    { silent = true }
  )
  vim.keymap.set("n", [[<Leader>gP]], [[<Cmd>Git log -p -- %<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gr]], [[<Cmd>Gread<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gR]], [[:Gread<Space>]])
  vim.keymap.set("n", [[<Leader>gu]], [[<Cmd>Gsplit HEAD<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gw]], [[<Cmd>Gwrite<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gW]], [[<Cmd>Gwrite!<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gq]], [[<Cmd>Gwq<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gQ]], [[<Cmd>Gwq!<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>gM]], [[<Cmd>Merginal<CR>]], { silent = true })
  vim.keymap.set("n", [[<Leader>g<Tab>]], [[<Cmd>execute 'Gsplit '.vimrc#fugitive#commit_sha()<CR>]], { silent = true })

  vim.keymap.set("n", [[<Leader>g`]], [[<Cmd>call vimrc#fugitive#review_last_commit()<CR>]], { silent = true })

  vim.cmd([[augroup fugitive_settings]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd BufReadPost fugitive://* call vimrc#fugitive#fugitive_buffer_settings()]])
  vim.cmd([[augroup END]])

  vim.g.fugitive_gitlab_domains = {}
  if vim.g.fugitive_gitlab_secret_domains ~= nil then
    vim.g.fugitive_gitlab_domains =
      utils.table_concat(vim.g.fugitive_gitlab_domains, vim.g.fugitive_gitlab_secret_domains)
  end

  -- Borrowed and modified from vim-fugitive s:Dispatch
  vim.cmd([[command! -nargs=* GitDispatch call vimrc#fugitive#git_dispatch(<q-args>)]])
end

return fugitive
