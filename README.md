# Neovim config

Carefully crafted neovim config. Use 
[lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

Vim specific config is removed, but you can use `vim` branch to access them.
Packer specific config is removed, but you can use `packer` branch to access them.

## Major plugins

### Neovim
* [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) (fast custom status line)
* [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (auto completion)
* [symbols-outline.nvim](https://github.com/simrat39/symbols-outline.nvim) (Display symbols in sidebar using LSP)
* [fzf](https://github.com/junegunn/fzf) (fuzzy finder for almost everything)
* [fzf.vim](https://github.com/junegunn/fzf.vim) (used with fzf)
* [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (fuzzy finder written in Lua and support LSP)
* [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) (lua file explorer)
* [oil.nvim](https://github.com/stevearc/oil.nvim) (buffer-based file explorer with folder synchronization)
* [defx.nvim](https://github.com/Shougo/defx.nvim) (buffer-based file explorer for better multiple project folder)
* [flash.nvim](https://github.com/folke/flash.nvim) (quickly move cursor to certain place on screen)
* [lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim) (quickly move cursor by search)
* [nvim-autopairs](https://github.com/windwp/nvim-autopairs) (automatically insert paired brackets)
* [nvim-surround](https://github.com/kylechui/nvim-surround) (quickly add/delete/replace brackets)
* [nvim-spectre](https://github.com/windwp/nvim-spectre) (find-and-replace globally)
* [lspsaga.nvim](https://github.com/glepnir/lspsaga.nvim) (lsp UI and lsp context for winbar)
* [trouble.nvim](https://github.com/folke/trouble.nvim) (diagnostics UI)
* [conform.nvim](https://github.com/stevearc/conform.nvim) (on-demand formatter)
* [nvim-lint](https://github.com/mfussenegger/nvim-lint) (on-demand linter)
* [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (fast semantic syntax highlighting)
* [syntax-tree-surfer](https://github.com/ziontee113/syntax-tree-surfer) (text navigation and manipulation based on treesitter)
* [vim-fugitive](https://github.com/tpope/vim-fugitive) (almost perfect git wrapper)
* [vim-flog](https://github.com/rbong/vim-flog) (git commit browser)
* [vim-floaterm](https://github.com/voldikss/vim-floaterm) (open terminal buffer in floating window)
* [vimwiki](https://github.com/vimwiki/vimwiki) (wiki plugin like orgmode)
* [vim-localvimrc](https://github.com/embear/vim-localvimrc) (for setup project-local vim config, useful for LSP)
* [statuscol.nvim](https://github.com/luukvbaal/statuscol.nvim) (customizable predefined 'statuscolumn')
* [diffview.nvim](https://github.com/sindrets/diffview.nvim) (git diff viewer & git history viewer)
* [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim#requirements) (vscode-like winbar)

## Requirements

### Neovim
* [neovim](https://neovim.io/) 0.9.2+ (stable), 0.10.0 (nightly, required by 'dropbar.nvim')
* [python](https://www.python.org/) 3.6.1+ (required by defx.nvim)
* [universal-ctags](https://github.com/universal-ctags/ctags) (required by fzf)
* C compiler and libstdc++ (required by nvim-treesitter)
* [git](https://git-scm.com/) 2.13.0 (basic), 2.19.0 (for column in `git grep`)

## Recommands

* [ripgrep](https://github.com/BurntSushi/ripgrep) (required for grepping files using FZF)
* [fd](https://github.com/sharkdp/fd) (required for goto to directory using FZF)
* [eza](https://github.com/eza-community/eza) (required for previewing directory using FZF)
* [bat](https://github.com/sharkdp/bat) (required for various preview commands using FZF)

## Installation

### Neovim

Clone the project as `~/.config/nvim`.
```
git clone https://github.com/mars90226/dotvim ~/.config/nvim
```

Open neovim and wait for `lazy.nvim` to finish the job.

## Key mappings

### Neovim
`<Leader>` key is `,`.

* FZF key mappings
    * `<Space>fg`: Search and open git files
    * `<Space>ff`: Search and open files
    * `<Space>fw`: Search and switch to windows
    * `<Space>fl`: Search and goto to lines in current buffer
    * `<Space>ft`: Search and goto to tags in current buffer
    * `<Space>fp`: Search and goto to tags in current project
    * `<Space>fi`: Live grep and goto files using ripgrep
    * `<Space>fr`: Grep and goto files using ripgrep
    * `<Space>fm`: Search and open most recently used files provided by neomru
    * `<Space>fh`: Search and open vim help
* Telescope key mappings
    * `<Space>tg`: Search and open git files
    * `<Space>tf`: Search and open files
    * `<Space>tw`: Search and switch to windows
    * `<Space>tl`: Search and goto to lines in current buffer
    * `<Space>ti`: Live grep and goto files using ripgrep
    * `<Space>tr`: Grep and goto files using ripgrep
    * `<Space>tm`: Search and open most recently used files
    * `<Space>th`: Search and open vim help
    * `<Space>ld`: Search and goto LSP definitions
    * `<Space>lr`: Search and goto LSP references
    * `<Space>lo`: Search and goto LSP document symbols
    * `<Space>ls`: Search and goto LSP workspace symbols
    * `<Space>lx`: Search and execute LSP code actions
* symbols-outline.nvim key mappings
    * `<F7>`: Toggle symbols-outline.nvim that showing LSP symbols outline in sidebar
* LSP key mappings
    * `gd`: Open LSP definition/references UI
    * `gy`: Show signature help
    * `gi`: Goto implementation
    * `gr`: LSP Rename
    * `[c`: Goto previous LSP diagnostic error
    * `]c`: Goto next LSP diagnostic error
    * `<Leader>lf`: Format selected code
    * `<Leader>lf` on visual selection: Range format selected code
* Defx key mappings
    * `-`: Open current buffer folder in Defx
    * `<Space>-`: Open current buffer folder in split in Defx
    * `<F4>`: Toggle Defx as sidebar file explorer
    * `<Space><F4>`: Toggle Defx as sidebar file explorer and find current buffer
* Hop key mappings
    * `<Space>w`: Goto word start
    * `<Space>;`: Search and goto pattern
    * `<Space>j`: Goto below lines
    * `<Space>k`: Goto above lines
* Lightspeed key mappings
    * `f`: Forward search and goto 1 characters
    * `F`: Backward search and goto 1 characters
    * `;`: Forward search and goto 2 characters
    * `<M-;>`: Backward search and goto 2 characters
* Trouble key mappings
    * `<Space>xx`: Toggle Trouble UI
    * `<Space>xd`: Show LSP document diagnostics in Trouble UI
    * `<Space>xw`: Show LSP workspace diagnostics in Trouble UI
* nvim-lint key mappings
    * `<Leader>ll`: Execute linter
* Treesitter key mappings
    * `af` for textobject: outer function textobject
    * `if` for textobject: inner function textobject
    * `af` for textobject: outer class textobject
    * `ic` for textobject: inner class textobject
    * `]m`: Goto next function start
    * `[m`: Goto previous function start
    * `]]`: Goto next class start
    * `[]`: Goto previous class start
    * `<F6>`: Toggle context
    * `<CR>`: Select node
    * `<CR>` in visual mode: scope incremental
    * `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>` in visual mode: navigate node
    * `<M-S-j>`, `<M-S-k>` in visual mode: swap node
* fugitive key mappings
    * `<Leader>gs`: Show git status
    * `<Leader>gc`: Show git blame commit of current line
    * `<Leader>gd`: Compare current buffer with git indexed file using vimdiff
    * `<Leader>gb`: Show git blame of current buffer
    * `<Leader>gl`: Show git log in quickfix and display most recent commit
    * `<Leader>gL`: Show git log of current buffer in quickfix and display most recent commit
* Flog key mappings
    * `<Space>gf`: Open Flog UI
    * `<Leader>gf`: Show current file in Flog UI
    * `<Leader>gd` in Flog UI: Search and open diff files in current git commit using FZF
    * `<Leader>gd` on visual selection in Flog UI: Search and open diff files in between last git commit and first git commit using FZF
    * `<Leader>gf` in Flog UI: Search and open git files in current git commit using FZF
    * `<Leader>gg` in Flog UI: Grep and goto git files in current git commit using FZF and ripgrep
* Floaterm key mappings
    * `<M-2>`: Toggle Floaterm terminal
    * `<M-3>`: Goto previous Floaterm terminal
    * `<M-4>`: Goto next Floaterm terminal
    * `<M-5>`: Open new Floaterm terminal
* Custom key mappings
    * `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>`: Move between windows, like `<C-W>h`, `<C-W>j`, `<C-W>k`, and `<C-W>l`
    * `<C-J>`, `<C-K>`: Move between tabs, like `gT` and `gt`
    * `<Space>q`: Close window, like `:q<CR>`
    * `<Leader>db`: Change current window working directory to folder containing current current buffer. Equivalent of `:lcd %:h<CR>`.
    * `<M-1>`: Switch to last tab
    * `<Leader>ts`: Open terminal in split
    * `<Leader>tt`: Open terminal in new tab
* Terminal key mappings
    * `<M-F1>`: Escape terminal mode to normal mode
    * `<M-r>`: Paste from register

## TODO

* [ ] Add full plugin dependencies
* [ ] Add provider plugin for dependencies
* [ ] Add [nvim-dap](https://github.com/mfussenegger/nvim-dap) and related plugins.
* [ ] Add description to key mappings
* [ ] Add description to LuaSnip snippets
* [ ] Add noice.nvim

## Screenshots

![normal](https://user-images.githubusercontent.com/1523214/141642117-9660db2d-b116-48af-83f1-af93184b2bd8.png)
![lsp](https://user-images.githubusercontent.com/1523214/141642118-fbf887c8-6939-4818-977a-132a41071e21.png)
![telescope](https://user-images.githubusercontent.com/1523214/141642124-4342b201-6589-40d9-9959-fd937fe3de49.png)

## Resources

* [rockerBOO/awesome-neovim Collections of awesome neovim plugins.](https://github.com/rockerBOO/awesome-neovim)
* [Dotfyle | Neovim Plugins & Neovim News](https://dotfyle.com/)
