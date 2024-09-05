vim.b.AutoPairsJumps = { ">" }

vim.api.nvim_create_user_command("RustupDoc", [[call vimrc#rust_doc#open_rustup_doc(<f-args>)]], { nargs = "+" })
vim.api.nvim_create_user_command(
  "RustupDocCore",
  [[call vimrc#rust_doc#open_rustup_doc('--core', <f-args>)]],
  { nargs = "*" }
)
vim.api.nvim_create_user_command(
  "RustupDocStd",
  [[call vimrc#rust_doc#open_rustup_doc('--std', <f-args>)]],
  { nargs = "*" }
)

vim.keymap.set("n", "gK", [[:call vimrc#rust_doc#search_under_cursor(expand('<cword>'))<CR>]], { silent = true, buffer = true })
vim.keymap.set("x", "gK", [[:<C-U>call vimrc#rust_doc#search_under_cursor(vimrc#utility#get_visual_selection())<CR>]], { silent = true, buffer = true })
vim.keymap.set("n", "<C-X><C-K>", [[:call vimrc#rust_doc#open_rustup_doc(vimrc#rust_doc#get_cursor_word())<CR>]], { silent = true, buffer = true })
vim.keymap.set("n", "<C-X><C-Q>", [[:RustFmt<CR>]], { silent = true, buffer = true })
vim.keymap.set("n", "<C-X><C-S>", [[:execute 'RustupDoc '.input('topic: ')<CR>]], { silent = true, buffer = true })

-- Cargo
local cargo_makeprg = 'cargo $*'
local rust_backtrace_cargo = {
  no = cargo_makeprg,
  yes = 'RUST_BACKTRACE=1 '..cargo_makeprg,
  full = 'RUST_BACKTRACE=full '..cargo_makeprg,
}
local switch_cargo_rust_backtrace = function(rust_backtrace)
  local new_cargo_makeprg = vim.F.if_nil(rust_backtrace_cargo[rust_backtrace], cargo_makeprg)

  vim.bo.makeprg = new_cargo_makeprg
end
vim.api.nvim_create_user_command("SwitchCargoRustBacktrace", function(opts)
  switch_cargo_rust_backtrace(opts.fargs[1])
end, { nargs = "*" })

vim.keymap.set("n", "<Space>a<CR>", [[:Make build<CR>]], { silent = true, buffer = true })
vim.keymap.set("n", "<Space>ax", [[:Make run<CR>]], { silent = true, buffer = true })
vim.keymap.set("n", "<Space>ac", [[:Make clippy<CR>]], { silent = true, buffer = true })
