local lspsaga = {
  show_doc = function()
    if vim.o.filetype == 'help' then
      vim.cmd([[help ]]..vim.fn.expand('<cword>'))
    else
      vim.cmd [[Lspsaga hover_doc]]
    end
  end
}

return lspsaga
