local neoterm = {}

neoterm.setup = function()
  vim.g.neoterm_default_mod = "botright"
  vim.g.neoterm_automap_keys = "<Leader>T"
  vim.g.neoterm_size = vim.go.lines / 2

  nnoremap("<Space>`", [[:execute 'T ' . input('Terminal: ', '', 'shellcmd')<CR>]], "<silent>")
  nnoremap("<Leader>`", [[:Ttoggle<CR>]], "<silent>")
  nnoremap("<Space><F3>", [[:TREPLSendFile<CR>]], "<silent>")
  nnoremap("<F3>", [[:TREPLSendLine<CR>]], "<silent>")
  xnoremap("<F3>", [[:TREPLSendSelection<CR>]], "<silent>")

  -- Useful maps
  -- hide/close terminal
  nnoremap("<Leader>th", [[:Tclose<CR>]], "<silent>")
  -- clear terminal
  nnoremap("<Leader>tl", [[:Tclear<CR>]], "<silent>")
  -- kills the current job (send a <c-c>)
  nnoremap("<Leader>tc", [[:Tkill<CR>]], "<silent>")
end

return neoterm
