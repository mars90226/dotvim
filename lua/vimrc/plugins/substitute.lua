local substitute = {}

substitute.setup = function()
  require("substitute").setup({
    preserve_cursor_position = true,
    range = {
      complete_word = false,
    },
  })

  -- Substitute
  vim.keymap.set("n", "ss", "<Cmd>lua require('substitute').operator()<CR>")
  vim.keymap.set("n", "sS", "<Cmd>lua require('substitute').line()<CR>")
  vim.keymap.set("n", "sl", "<Cmd>lua require('substitute').eol()<CR>")
  vim.keymap.set("x", "ss", "<Cmd>lua require('substitute').visual()<CR>")

  -- Substitute using system clipboard
  vim.keymap.set("n", "=ss", "<Cmd>lua require('substitute').operator({ register = '+' })<CR>")
  vim.keymap.set("n", "=sS", "<Cmd>lua require('substitute').line({ register = '+' })<CR>")
  vim.keymap.set("n", "=sl", "<Cmd>lua require('substitute').eol({ register = '+' })<CR>")
  vim.keymap.set("x", "=ss", "<Cmd>lua require('substitute').visual({ register = '+' })<CR>")

  -- Substitute over range
  vim.keymap.set("n", "<Leader>s", "<Cmd>lua require('substitute.range').operator()<CR>")
  vim.keymap.set("x", "<Leader>s", "<Cmd>lua require('substitute.range').visual()<CR>")
  vim.keymap.set("n", "<Leader>ss", "<Cmd>lua require('substitute.range').word()<CR>") -- FIXME: This is conflict with which-key.nvim

  -- Substitute over range confirm
  vim.keymap.set("n", "scr", "<Cmd>lua require('substitute.range').operator({ confirm = true })<CR>")
  vim.keymap.set("x", "scr", "<Cmd>lua require('substitute.range').visual({ confirm = true })<CR>")
  vim.keymap.set("n", "scrr", "<Cmd>lua require('substitute.range').word({ confirm = true })<CR>")

  -- Substitute over range Subvert (depends on vim-abolish)
  vim.keymap.set("n", "<Leader><Leader>s", "<Cmd>lua require('substitute.range').operator({ prefix = 'S' })<CR>")
  vim.keymap.set("x", "<Leader><Leader>s", "<Cmd>lua require('substitute.range').visual({ prefix = 'S' })<CR>")
  vim.keymap.set("n", "<Leader><Leader>ss", "<Cmd>lua require('substitute.range').word({ prefix = 'S' })<CR>")

  -- Exchange
  vim.keymap.set("n", "cx", "<Cmd>lua require('substitute.exchange').operator()<CR>")
  vim.keymap.set("n", "cxx", "<Cmd>lua require('substitute.exchange').line()<CR>")
  vim.keymap.set("x", "X", "<Cmd>lua require('substitute.exchange').visual()<CR>")
  vim.keymap.set("n", "cxc", "<Cmd>lua require('substitute.exchange').cancel()<CR>")
end

return substitute
