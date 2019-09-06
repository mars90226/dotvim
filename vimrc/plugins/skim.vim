command! SkimMru call skim#run(skim#wrap({
      \ 'source':  vimrc#fzf#mru#mru_files(),
      \ 'options': '-m',
      \ 'down':    '40%' }))

nnoremap <Space>sm :SkimMru<CR>
