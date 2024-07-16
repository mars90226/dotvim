local substitute = {}

substitute.setup = function()
  require("substitute").setup({
    preserve_cursor_position = true,
    range = {
      complete_word = false,
    },
  })

  -- Substitute
  nnoremap("ss", "<Cmd>lua require('substitute').operator()<CR>")
  nnoremap("sS", "<Cmd>lua require('substitute').line()<CR>")
  nnoremap("sl", "<Cmd>lua require('substitute').eol()<CR>")
  xnoremap("ss", "<Cmd>lua require('substitute').visual()<CR>")

  -- Substitute using system clipboard
  nnoremap("=ss", "<Cmd>lua require('substitute').operator({ register = '+' })<CR>")
  nnoremap("=sS", "<Cmd>lua require('substitute').line({ register = '+' })<CR>")
  nnoremap("=sl", "<Cmd>lua require('substitute').eol({ register = '+' })<CR>")
  xnoremap("=ss", "<Cmd>lua require('substitute').visual({ register = '+' })<CR>")

  -- Substitute over range
  nnoremap("<Leader>s", "<Cmd>lua require('substitute.range').operator()<CR>")
  xnoremap("<Leader>s", "<Cmd>lua require('substitute.range').visual()<CR>")
  nnoremap("<Leader>ss", "<Cmd>lua require('substitute.range').word()<CR>")

  -- Substitute over range confirm
  nnoremap("scr", "<Cmd>lua require('substitute.range').operator({ confirm = true })<CR>")
  xnoremap("scr", "<Cmd>lua require('substitute.range').visual({ confirm = true })<CR>")
  nnoremap("scrr", "<Cmd>lua require('substitute.range').word({ confirm = true })<CR>")

  -- Substitute over range Subvert (depends on vim-abolish)
  nnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').operator({ prefix = 'S' })<CR>")
  xnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').visual({ prefix = 'S' })<CR>")
  nnoremap("<Leader><Leader>ss", "<Cmd>lua require('substitute.range').word({ prefix = 'S' })<CR>")

  -- Exchange
  nnoremap("cx", "<Cmd>lua require('substitute.exchange').operator()<CR>")
  nnoremap("cxx", "<Cmd>lua require('substitute.exchange').line()<CR>")
  xnoremap("X", "<Cmd>lua require('substitute.exchange').visual()<CR>")
  nnoremap("cxc", "<Cmd>lua require('substitute.exchange').cancel()<CR>")
end

return substitute
