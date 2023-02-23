local vimwiki = {}

vimwiki.pre_setup = function()
  -- disable vimwiki on markdown file
  vim.g.vimwiki_ext2syntax = { [".wiki"] = "default" }
  -- disable <Tab> & <S-Tab> mappings in insert mode
  vim.g.vimwiki_key_mappings = { lists_return = 1, table_mappings = 0 }
  -- Toggle after vim
  vim.g.vimwiki_folding = "expr:quick"

  -- NOTE: For lazy load vimwiki as it doesn't use ftdetect
  vim.cmd([[augroup vimwiki_filetypedetect]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd BufRead,BufNewFile *.wiki setfiletype vimwiki]])
  vim.cmd([[augroup END]])
end

vimwiki.setup = function()
  vim.cmd([[command! VimwikiToggleFolding    call vimrc#vimwiki#toggle_folding()]])
  vim.cmd([[command! VimwikiToggleAllFolding call vimrc#vimwiki#toggle_all_folding()]])
  vim.cmd([[command! VimwikiManualFolding    call vimrc#vimwiki#manual_folding()]])
  vim.cmd([[command! VimwikiManualAllFolding call vimrc#vimwiki#manual_all_folding()]])
  vim.cmd([[command! VimwikiExprFolding      call vimrc#vimwiki#expr_folding()]])
  vim.cmd([[command! VimwikiExprAllFolding   call vimrc#vimwiki#expr_all_folding()]])

  vim.cmd([[augroup vimwiki_settings]])
  vim.cmd([[  autocmd!]])
  -- TODO: Need to check if this is needed
  vim.cmd([[  autocmd VimEnter *.wiki  VimwikiManualAllFolding]])
  vim.cmd([[augroup END]])
end

return vimwiki
