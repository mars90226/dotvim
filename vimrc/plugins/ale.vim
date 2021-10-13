" let g:ale_linters = {
"       \ 'c': ['gcc', 'ccls'],
"       \ 'cpp': ['g++', 'ccls'],
"       \ 'javascript': ['eslint', 'jshint', 'flow', 'flow-language-server']
"       \}
" Disable language server in ale, prefer coc.nvim
let g:ale_linters = {
      \ 'c': ['gcc'],
      \ 'cpp': ['g++'],
      \ 'javascript': ['eslint', 'jshint'],
      \ 'python': ['pylint', 'flake8'],
      \ 'ruby': ['standardrb'],
      \ 'sh': ['shell', 'shellcheck']
      \}
let g:ale_fixers = {
      \ 'c': [
      \   'clang-format',
      \   'clangtidy'
      \ ],
      \ 'cpp': [
      \   'clang-format',
      \   'clangtidy'
      \ ],
      \ 'javascript': [
      \   'eslint',
      \   'prettier'
      \ ],
      \ 'css': [
      \   'prettier',
      \   'stylelint'
      \ ],
      \ 'lua': [
      \   'lua-format'
      \ ],
      \ 'python': ['black'],
      \ 'ruby': ['standardrb'],
      \ 'rust': ['rustfmt'],
      \ 'scss': [
      \   'prettier',
      \   'stylelint'
      \ ],
      \ 'sh': ['shfmt']
      \}
" Depend on project whether to use flow locally
" let g:ale_javascript_flow_use_global = 1
" let g:ale_javascript_flow_ls_use_global = 1
let g:ale_pattern_options = extend({
      \ 'configure': {
      \   'ale_enabled': 0
      \ }
      \}, get(g:, 'ale_secret_pattern_options', {}))
" Default using bash dialect for shellcheck
let g:ale_sh_shellcheck_options = '-s bash'

" Default using gcc instead of clang++
let g:ale_cpp_cc_executable = 'gcc'

" Check if clippy is installed
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

nmap ]a <Plug>(ale_next_wrap)
nmap [a <Plug>(ale_previous_wrap)
nmap ]A <Plug>(ale_first)
nmap [A <Plug>(ale_last)
nmap <Leader>ad <Plug>(ale_detail)
nmap <Leader>af <Plug>(ale_fix)
nmap <Leader>ag <Plug>(ale_go_to_definition)
nmap <Leader>aG <Plug>(ale_go_to_definition_in_tab)
nmap <Leader>ah <Plug>(ale_hover)
nmap <Leader>ai :ALEInfo<CR>
nmap <Leader>aL <Plug>(ale_lint)
nmap <Leader>ar <Plug>(ale_find_references)
nmap <Leader>as :execute 'ALESymbolSearch ' . input('Symbol: ')<CR>
nmap <Leader>aS :ALEStopAllLSPs<CR>
nmap <Leader>at <Plug>(ale_go_to_type_definition)
nmap <Leader>aT <Plug>(ale_go_to_type_definition_in_tab)
nmap <Leader>ay <Plug>(ale_toggle_buffer)
nmap <Leader>aY <Plug>(ale_toggle)
