# Vim config

Carefully crafted vim/neovim config.

## Major plugins

* [lightline.vim](https://github.com/itchyny/lightline.vim) (custom status line)
* [coc.nvim](https://github.com/neoclide/coc.nvim) (auto completion)
* [vista.vim](https://github.com/liuchengxu/vista.vim) (Display tags in sidebar and support LSP)
* [tagbar](https://github.com/majutsushi/tagbar) (Display tags in sidebar and more stable)
* [fzf](https://github.com/junegunn/fzf) (fuzzy finder for almost everything)
* [fzf.vim](https://github.com/junegunn/fzf.vim) (used with fzf)
* [denite.nvim](https://github.com/Shougo/denite.nvim) (same as above but use for some cases that need regexp filter)
* [unite.vim](https://github.com/Shougo/unite.vim) (same as above but has more niche sources)
* [defx.nvim](https://github.com/Shougo/defx.nvim) (file explorer)
* [vim-easymotion](https://github.com/easymotion/vim-easymotion) (quickly move cursor to certain place on screen)
* [incsearch.vim](https://github.com/haya14busa/incsearch.vim) (goto next and previous matched result without leaving search mode)
* [auto-pairs](https://github.com/jiangmiao/auto-pairs) (automatically insert paired brackets)
* [vim-sandwich](https://github.com/machakann/vim-sandwich) (quicly add/delete/replace brackets)
* [far.vim](https://github.com/brooth/far.vim) (find-and-replace globally)
* [ale.vim](https://github.com/w0rp/ale) (asynchronous linter)
* [vim-polyglot](https://github.com/sheerun/vim-polyglot) (syntax files for almost everything filetypes)
* [vim-fugitive](https://github.com/tpope/vim-fugitive) (almost perfect git wrapper)
* [gv.vim](https://github.com/junegunn/gv.vim) (git commit browser)
* [vim-rooter](https://github.com/airblade/vim-rooter) (change working directory to project root)
* [vimwiki](https://github.com/vimwiki/vimwiki) (wiki plugin like orgmode)
* [vim-localvimrc](https://github.com/embear/vim-localvimrc) (for setup project-local vim config, useful for ale)

## Requirements

* [python](https://www.python.org/) 3.6.1+ (required by denite.nvim, and defx.nvim)
* [npm](https://www.npmjs.com/) or [yarn](https://yarnpkg.com) (required by coc.nvim)
* [universal-ctags](https://github.com/universal-ctags/ctags) (required by vista.vim, and tagbar)

## Recommands

* [ripgrep](https://github.com/BurntSushi/ripgrep) (required for grepping files using FZF)
* [fd](https://github.com/sharkdp/fd) (required for goto to directory using FZF)
* [exa](https://github.com/ogham/exa) (required for previewing directory using FZF)
* [bat](https://github.com/sharkdp/bat) (required for various preview commands using FZF)

## Installation

Working in progress.

## Key mappings

`<Leader>` key is `,`.

* FZF key mappings
    * `<Space>fg`: Search and open git files
    * `<Space>ff`: Search and open files
    * `<Space>fw`: Search and switch to windows
    * `<Space>fl`: Search and goto to lines in current buffer
    * `<Space>ft`: Search and goto to tags in current buffer
    * `<Space>fp`: Search and goto to tags in current project
    * `<Space>fr`: Grep and goto files using ripgrep
    * `<Space>fm`: Search and open most recently used files provided by neomru
    * `<Space>fh`: Search and open vim help
* Denite key mappings
    * `<Space>p`: Search and open files
    * `<Space>o`: List and goto outline of current buffer (depends on tags)
    * `<Space>do`: Execute vim command and search output
* Unite key mappings
    * `<Space>O`: List and goto outline of current buffer (depends on regex)
    * `<Space><F1>`: List mappings
    * `<Space><F2>`: List buffer mappings
* Vista key mappings
    * `<F7>`: Toggle Vista that showing tags or LSP outline in sidebar
    * `<Space><F7>`: Start Vista finder that goto tags or LSP symbols
* Tagbar key mappings
    * `<F8>`: Toggle Tagbar that showing tags in sidebar
* Coc key mappings
    * `gd`: Goto definition
    * `gy`: Goto type definition
    * `gi`: Goto implementation
    * `gr`: Goto references
    * `[c`: Goto previous Coc diagnostic error
    * `]c`: Goto next Coc diagnostic error
    * `<Space>cf`: Format selected code
    * `<Space>co`: List and goto outline of current buffer (depends on LSP)
    * `<Space>c;`: Execute Coc command
* Defx key mappings
    * `-`: Open current buffer folder in Defx
    * `<Space>-`: Open current buffer folder in split in Defx
    * `<F4>`: Toggle Defx as sidebar file explorer
    * `<Space><F4>`: Toggle Defx as sidebar file explorer and find current buffer
* Easymotion key mappings
    * `<Space>w`: Goto word start using easymotion
    * `;`: Goto inserted two characters using easymotion
    * `<Leader>f`: Goto inserted character using easymotion
    * `<Space>j`: Goto below lines using easymotion
    * `<Space>k`: Goto above lines using easymotion
* ALE key mappings
    * `[a`: Goto previous ALE lint error
    * `]a`: Goto next ALE lint error
    * `<Leader>ad`: Show ALE detail
    * `<Leader>af`: Fix ALE lint error
* fugitive key mappings
    * `<Leader>gs`: Show git status
    * `<Leader>gd`: Compare current buffer with git indexed file using vimdiff
    * `<Leader>gb`: Show git blame of current buffer
    * `<Leader>gl`: Show git log in quickfix and display most recent commit
    * `<Leader>gL`: Show git log of current buffer in quickfix and display most recent commit
* GV key mappings
    * `<Leader>gd`: Search and open diff files in current git commit using FZF
    * `<Leader>gd` on visual selection: Search and open diff files in between last git commit and first git commit using FZF
    * `<Leader>gf`: Search and open git files in current git commit using FZF
    * `<Leader>gg`: Grep and goto git files in current git commit using FZF and ripgrep
* Rooter key mappings
    * `<Leader>r`: Change current window working directory to project root
* Custom key mappings
    * `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>`: Move between windows, like `<C-W>h`, `<C-W>j`, `<C-W>k`, and `<C-W>l`
    * `<C-J>`, `<C-K>`: Move between tabs, like `gT` and `gt`
    * `<Space>q`: Close window, like `:q<CR>`
    * `<Leader>cb`: Change current window working directory to folder containing current current buffer
    * `<M-1>`: Switch to last tab
    * `<Leader>ts`: Open terminal in split
    * `<Leader>tt`: Open terminal in new tab
* Terminal key mappings
    * `<M-F1>`: Escape terminal mode to normal mode
    * `<M-1>`: Switch to last tab
    * `<M-r>`: Paste from register

## TODO

* [ ] Add full plugin dependencies
* [ ] Add provider plugin for dependencies

## Screenshots

![fzf_and_vista](https://user-images.githubusercontent.com/1523214/75095594-8e2c1180-55d1-11ea-8370-dd8bde86170d.png)
