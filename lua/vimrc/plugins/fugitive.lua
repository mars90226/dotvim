local utils = require("vimrc.utils")

local fugitive = {}

fugitive.setup = function()
  -- Commands
  vim.cmd([[command! -nargs=1 GitGotoBlameLine call vimrc#fugitive#goto_blame_line(<f-args>)]])
  vim.cmd([[command! GitCloseFugitiveBuffers call vimrc#fugitive#close_all_fugitive_buffers()]])

  -- Mappings
  -- For execute git command
  nnoremap([[<Space>gg]], [[:Git<Space>]])
  nnoremap([[<Space>gG]], [[:Git --paginate<Space>]])

  nnoremap([[<Leader>gs]], [[:Git<CR>]], { silent = true })
  nnoremap([[<Leader>gS]], [[:call vimrc#fugitive#diff_staged_file('%')<CR>]], { silent = true })
  nnoremap([[<Leader>gd]], [[:Gdiffsplit<CR>]], { silent = true })
  nnoremap([[<Leader>gD]], [[:Gdiffsplit!<CR>]], { silent = true })
  nnoremap([[<Leader>gc]], [[:GitGotoBlameLine split<CR>]], { silent = true })
  nnoremap([[<Leader>gC]], [[:GitGotoBlameLine edit<CR>]], { silent = true })
  nnoremap([[<Leader>gb]], [[:Git blame<CR>]], { silent = true })
  xnoremap([[<Leader>gb]], [[:Git blame<CR>]], { silent = true })
  nnoremap([[<Leader>gB]], [[:GBrowse<CR>]], { silent = true })
  xnoremap([[<Leader>gB]], [[:GBrowse<CR>]], { silent = true })
  nnoremap([[<Leader>ge]], [[:Gedit<CR>]], { silent = true })
  nnoremap([[<Leader>gE]], [[:Gedit<space>]], { silent = true })
  -- TODO Use :Gllog instead, currently :0Gllog do not work
  nnoremap([[<Leader>gl]], [[:Gclog<CR>]], { silent = true })
  nnoremap([[<Leader>gL]], [[:0Gclog<CR>]], { silent = true })
  xnoremap([[<Leader>gl]], [[:<C-U>execute 'Git log -L '.getpos("'<")[1].','.getpos("'>")[1].':%'<CR>]], { silent = true })
  nnoremap([[<Leader>gP]], [[:Git log -p -- %<CR>]], { silent = true })
  nnoremap([[<Leader>gr]], [[:Gread<CR>]], { silent = true })
  nnoremap([[<Leader>gR]], [[:Gread<Space>]], { silent = true })
  nnoremap([[<Leader>gu]], [[:Gsplit HEAD<CR>]], { silent = true })
  nnoremap([[<Leader>gw]], [[:Gwrite<CR>]], { silent = true })
  nnoremap([[<Leader>gW]], [[:Gwrite!<CR>]], { silent = true })
  nnoremap([[<Leader>gq]], [[:Gwq<CR>]], { silent = true })
  nnoremap([[<Leader>gQ]], [[:Gwq!<CR>]], { silent = true })
  nnoremap([[<Leader>gM]], [[:Merginal<CR>]], { silent = true })
  nnoremap([[<Leader>g<Tab>]], [[:execute 'Gsplit '.vimrc#fugitive#commit_sha()<CR>]], { silent = true })

  nnoremap([[<Leader>g`]], [[:call vimrc#fugitive#review_last_commit()<CR>]], { silent = true })

  vim.cmd([[augroup fugitive_settings]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd BufReadPost fugitive://* call vimrc#fugitive#fugitive_buffer_settings()]])
  vim.cmd([[augroup END]])

  vim.g.fugitive_gitlab_domains = {}
  if vim.g.fugitive_gitlab_secret_domains ~= nil then
    vim.g.fugitive_gitlab_domains = utils.table_concat(vim.g.fugitive_gitlab_domains, vim.g.fugitive_gitlab_secret_domains)
  end

  -- Borrowed and modified from vim-fugitive s:Dispatch
  vim.cmd([[command! -nargs=* GitDispatch call vimrc#fugitive#git_dispatch(<q-args>)]])
end

return fugitive
