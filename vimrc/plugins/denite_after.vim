" Use fd for file/rec and ripgrep for grep
if executable('fd')
  call denite#custom#var('file/rec', 'command',
        \ ['fd', '--type', 'file', '--follow', '--hidden', '--exclude', '.git', ''])
elseif executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
elseif executable('ag')
  call denite#custome#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

if executable('rg')
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading', '-S'])
endif

" Denite options
call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
call denite#custom#source('default', 'sorters', ['sorter/rank'])
call denite#custom#source('grep', 'converters', ['converter/abbr_word'])

call denite#custom#option('_', {
      \ 'auto_accel': v:true,
      \ 'reversed': 1,
      \ 'prompt': '❯',
      \ 'prompt_highlight': 'Function',
      \ 'highlight_mode_normal': 'Visual',
      \ 'highlight_mode_insert': 'CursorLine',
      \ 'highlight_matched_char': 'Special',
      \ 'highlight_matched_range': 'Normal',
      \ 'vertical_preview': 1,
      \ 'start_filter': 1,
      \ })
