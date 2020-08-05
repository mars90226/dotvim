" Script Encoding: UTF-8
scriptencoding utf-8

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
  call denite#custom#var('grep,line/external', {
        \ 'command': ['rg'],
        \ 'recursive_opts': [],
        \ 'final_opts': [],
        \ 'separator': ['--'],
        \ 'default_opts': ['--vimgrep', '--no-heading', '--smart-case'],
        \ })
endif

" Denite options
if vimrc#denite#use_clap()
  call denite#custom#source('_', 'matchers', ['matcher/clap'])
  call denite#custom#filter('matcher/clap', 'clap_path', vimrc#get_vim_plug_dir().'/vim-clap')
else
  call denite#custom#source('_', 'matchers', ['matcher/fruzzy'])
end

call denite#custom#source('default', 'sorters', ['sorter/rank'])
call denite#custom#source('grep', 'converters', ['converter/abbr_word'])

call denite#custom#option('_', {
      \ 'auto_accel': v:true,
      \ 'split': 'floating',
      \ 'winwidth': g:denite_width,
      \ 'winheight': g:denite_height,
      \ 'wincol': g:denite_left,
      \ 'winrow': g:denite_top,
      \ 'filter_split_direction': 'floating',
      \ 'floating_preview': v:true,
      \ 'vertical_preview': v:true,
      \ 'preview_width': g:denite_preview_width,
      \ 'preview_height': g:denite_preview_height,
      \ 'direction': 'topleft',
      \ 'start_filter': v:true,
      \ 'prompt': '❯',
      \ 'prompt_highlight': 'Function',
      \ 'highlight_mode_normal': 'Visual',
      \ 'highlight_mode_insert': 'CursorLine',
      \ 'highlight_matched_char': 'Special',
      \ 'highlight_matched_range': 'Normal'
      \ })
