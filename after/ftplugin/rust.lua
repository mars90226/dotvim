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

nnoremap("gK", [[:call vimrc#rust_doc#search_under_cursor(expand('<cword>'))<CR>]], "<silent>", "<buffer>")
xnoremap("gK", [[:<C-U>call vimrc#rust_doc#search_under_cursor(vimrc#utility#get_visual_selection())<CR>]], "<silent>", "<buffer>")
nnoremap("<C-X><C-K>", [[:call vimrc#rust_doc#open_rustup_doc(vimrc#rust_doc#get_cursor_word())<CR>]], "<silent>", "<buffer>")
nnoremap("<C-X><C-Q>", [[:RustFmt<CR>]], "<silent>", "<buffer>")
nnoremap("<C-X><C-S>", [[:execute 'RustupDoc '.input('topic: ')<CR>]], "<silent>", "<buffer>")

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

nnoremap("<Space>a<CR>", [[:Make build<CR>]], "<silent>", "<buffer>")
nnoremap("<Space>ax", [[:Make run<CR>]], "<silent>", "<buffer>")
nnoremap("<Space>ac", [[:Make clippy<CR>]], "<silent>", "<buffer>")
