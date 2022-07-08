local autocmd = {}

autocmd.setup = function()
  -- Input Method autocmd
  vim.cmd([[augroup input_method_settings]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd InsertEnter * setlocal iminsert=1]])
  vim.cmd([[  autocmd InsertLeave * setlocal iminsert=0]])
  vim.cmd([[augroup END]])

  -- Prompt buffer settings
  -- FIXME: not work
  -- augroup prompt_buffer_settings
  --   autocmd!
  --
  --   autocmd BufNewFile,BufReadPost * if &buftype ==# 'prompt' | inoremap <buffer> <C-W> <C-S-W> | endif
  --   autocmd BufNewFile,BufReadPost * if &buftype ==# 'prompt' | inoremap <buffer> <A-w> <C-W> | endif
  -- augroup END

  -- Command-line window settings
  vim.cmd([[augroup cmdline_window_settings]])
  vim.cmd([[  autocmd!]])
  -- Removing any key mapping for <CR> in cmdline-window
  vim.cmd([[  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>]])
  vim.cmd([[augroup END]])

  -- Highlight yank
  vim.cmd([[augroup highlight_yank]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 200 })]])
  vim.cmd([[augroup END]])

  -- Since NVIM v0.4.0-464-g5eaa45547, commit 5eaa45547975c652e594d0d6dbe34c1316873dc7
  -- 'secure' is set when 'modeline' is set, which will cause a lot of commands
  -- cannot run in autocmd when opening help page.
  vim.cmd([[augroup secure_modeline_conflict_workaround]])
  vim.cmd([[  autocmd!]])
  vim.cmd([[  autocmd FileType help setlocal nomodeline]])
  vim.cmd([[augroup END]])

  -- Secret project local settings
  if vim.fn.exists('*VimSecretProjectLocalSettings') ~= 0 then
    vim.fn['VimSecretProjectLocalSettings']()
  end

  -- Machine-local project local settings
  if vim.fn.exists('*VimLocalProjectLocalSettings') ~= 0 then
    vim.fn['VimLocalProjectLocalSettings']()
  end
end

return autocmd
