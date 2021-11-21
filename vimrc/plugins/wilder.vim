call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('use_python_remote_plugin', 0)

call wilder#set_option('pipeline', [
      \   wilder#branch(
      \     wilder#cmdline_pipeline({
      \       'fuzzy': 1,
      \       'fuzzy_filter': wilder#lua_fzy_filter(),
      \       'set_pcre2_pattern': has('nvim'),
      \     }),
      \     wilder#vim_search_pipeline(),
      \   ),
      \ ])

let s:highlighters = [
      \ wilder#lua_pcre2_highlighter(),
      \ wilder#lua_fzy_highlighter(),
      \ ]
let s:hl = wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#f4468f'}])

call wilder#set_option('renderer', wilder#renderer_mux({
      \ ':': wilder#popupmenu_renderer({
      \   'highlighter': s:highlighters,
      \   'highlights': {
      \     'accent': s:hl,
      \   },
      \   'left': [
      \     ' ',
      \     wilder#popupmenu_devicons(),
      \   ],
      \   'right': [
      \     ' ',
      \     wilder#popupmenu_scrollbar(),
      \   ],
      \ }),
      \ '/': wilder#wildmenu_renderer({
      \   'highlighter': s:highlighters,
      \   'highlights': {
      \     'accent': s:hl,
      \   },
      \ }),
      \ }))

nnoremap <Leader>w :call wilder#toggle()<CR>
