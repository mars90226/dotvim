local lspsaga = {}

lspsaga.on_attach = function(client)
  -- TODO: ignore some key mapping if it's null-ls.nvim lsp
  nnoremap("gd", "<Cmd>Lspsaga lsp_finder<CR>", "silent", "buffer")
  nnoremap("gi", "<Cmd>Lspsaga implement<CR>", "silent", "buffer")
  nnoremap("gpp", "<Cmd>Lspsaga peek_definition<CR>", "silent", "buffer")
  nnoremap("gr", "<Cmd>Lspsaga rename<CR>", "silent", "buffer")
  nnoremap("gx", "<Cmd>Lspsaga code_action<CR>", "silent", "buffer")
  xnoremap("gx", ":<C-U>Lspsaga range_code_action<CR>", "silent", "buffer")
  nnoremap("go", "<Cmd>Lspsaga show_line_diagnostics<CR>", "silent", "buffer")
  nnoremap("gC", "<Cmd>Lspsaga show_cursor_dianostics<CR>", "silent", "buffer")
  nnoremap("<Plug>(diff-prev)", "[c", "silent", "buffer")
  nnoremap("<Plug>(diff-next)", "]c", "silent", "buffer")
  nmap("[c", [[&diff ? "\<Plug>(diff-prev)" : "\<Cmd>Lspsaga diagnostic_jump_prev\<CR>"]], "silent", "buffer", "expr")
  nmap("]c", [[&diff ? "\<Plug>(diff-next)" : "\<Cmd>Lspsaga diagnostic_jump_next\<CR>"]], "silent", "buffer", "expr")

  -- Remap for K
  local maparg
  maparg = vim.fn.maparg("gK", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("gK", "K", "buffer")
  end
  -- Remap for gi
  maparg = vim.fn.maparg("gI", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("gI", "gi", "buffer")
  end
  -- Remap for gI
  maparg = vim.fn.maparg("g<C-I>", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("g<C-I>", "gI", "buffer")
  end
end

return lspsaga
