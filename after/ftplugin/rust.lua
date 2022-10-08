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
nnoremap("<Space>a<CR>", [[:Make build<CR>]], "<silent>", "<buffer>")
nnoremap("<Space>ax", [[:Make run<CR>]], "<silent>", "<buffer>")
nnoremap("<Space>ac", [[:Make clippy<CR>]], "<silent>", "<buffer>")
