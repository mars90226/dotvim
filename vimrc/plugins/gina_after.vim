call gina#custom#mapping#nmap(
        \ '/\%(blame\|commit\|status\|branch\|ls\|grep\|changes\|tag\)',
        \ 'q', ':<C-U> q<CR>', {'noremap': 1, 'silent': 1},
        \)

call extend(g:gina#command#browse#translation_patterns, {
      \ 'git.synology.com': [
      \   [
      \     '\vhttps?://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit://(%domain)/(.{-})/(.{-})%(\.git)?$',
      \     '\vgit\@(%domain):(.{-})/(.{-})%(\.git)?$',
      \     '\vssh://git\@(%domain)/(.{-})/(.{-})%(\.git)?$',
      \   ], {
      \     'root':  'https://\1/\2/\3/tree/%r1/',
      \     '_':     'https://\1/\2/\3/blob/%r1/%pt%{#L|}ls%{-}le',
      \     'exact': 'https://\1/\2/\3/blob/%h1/%pt%{#L|}ls%{-}le',
      \   },
      \ ],
      \})
