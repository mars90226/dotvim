vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- pydoc.vim mappings
nnoremap([[<Leader>pw]], [[:call vimrc#pydoc#show_pydoc('<C-R><C-W>', 1)<CR>]], { silent = true, buffer = true })
nnoremap([[<Leader>pW]], [[:call vimrc#pydoc#show_pydoc('<C-R><C-A>', 1)<CR>]], { silent = true, buffer = true })
nnoremap([[<Leader>pk]], [[:call vimrc#pydoc#show_pydoc('<C-R><C-W>', 0)<CR>]], { silent = true, buffer = true })
nnoremap([[<Leader>pK]], [[:call vimrc#pydoc#show_pydoc('<C-R><C-A>', 0)<CR>]], { silent = true, buffer = true })
nnoremap(
  [[gK]],
  [[:call vimrc#pydoc#show_pydoc(vimrc#pydoc#replace_module_alias(), 1)<CR>]],
  { silent = true, buffer = true }
)

if vim.fn.executable("black-macchiato") == 1 then
  vim.bo.formatprg = "black-macchiato"
elseif vim.fn.executable("autopep8") == 1 then
  vim.bo.formatprg = "autopep8"
end

if vim.fn.executable("isort") == 1 then
  vim.cmd([[command -range SortImport :<line1>,<line2>!isort -]])
end
