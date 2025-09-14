# Mars' Neovim config

Carefully crafted neovim config by me as an vim/neovim user and evangelist for more than 10 years. Use
[lazy.nvim](https://github.com/folke/lazy.nvim) as plugin manager.

## Screenshots

![normal](https://github.com/user-attachments/assets/108d2f71-aafb-41b9-bdb2-8a84ec40f960)
![lsp](https://github.com/user-attachments/assets/84dee5b4-4541-466b-a1e3-a845129ea1eb)
![fzf-lua](https://github.com/user-attachments/assets/196ee8dc-76c8-4b9f-a216-0abb09e85928)

## Major plugins

### Plugin Manager

- [lazy.nvim](https://github.com/folke/lazy.nvim) (lazy loading plugin manager)

### Gems

Well, these plugins are hard to categorize, but they are gems. You will need them.

- [mini.nvim](https://github.com/echasnovski/mini.nvim) (various modules for neovim)
- [snacks.nvim](https://github.com/folke/snacks.nvim) (collection of small QoL plugins)

### UI

- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) (fast custom status line)
- [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim#requirements) (vscode-like winbar)

### Picker

- [fzf](https://github.com/junegunn/fzf) (fuzzy finder for almost everything)
- [fzf.vim](https://github.com/junegunn/fzf.vim) (used with fzf)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (fuzzy finder written in Lua and support LSP)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua) (fzf wrapper in Lua and support LSP and performs well)

### Editor

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) (auto completion)
- [nvim-autopairs](https://github.com/windwp/nvim-autopairs) (automatically insert paired brackets)
- [nvim-surround](https://github.com/kylechui/nvim-surround) (quickly add/delete/replace brackets)
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim) (find-and-replace globally)
- [flash.nvim](https://github.com/folke/flash.nvim) (quickly move cursor to certain place on screen)
- [hop.nvim](https://github.com/smoka7/hop.nvim) (quickly move cursor to certain place on screen, written in Lua)
- [lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim) (quickly move cursor by search)

### LSP

- [outline.nvim](https://github.com/hedyhli/outline.nvim) (Display symbols in sidebar using LSP)
- [trouble.nvim](https://github.com/folke/trouble.nvim) (diagnostics UI)
- [conform.nvim](https://github.com/stevearc/conform.nvim) (on-demand formatter)
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) (on-demand linter)

### File Explorer

- [oil.nvim](https://github.com/stevearc/oil.nvim) (buffer-based file explorer with folder synchronization)
- [defx.nvim](https://github.com/Shougo/defx.nvim) (buffer-based file explorer for better multiple project folder)

### Treesitter

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (fast semantic syntax highlighting)
- [syntax-tree-surfer](https://github.com/ziontee113/syntax-tree-surfer) (text navigation and manipulation based on treesitter)

### Git

- [vim-fugitive](https://github.com/tpope/vim-fugitive) (almost perfect git wrapper)
- [vim-flog](https://github.com/rbong/vim-flog) (git commit browser)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) (git diff viewer & git history viewer)

### Utility

- [vim-floaterm](https://github.com/voldikss/vim-floaterm) (open terminal buffer in floating window)
- [vimwiki](https://github.com/vimwiki/vimwiki) (wiki plugin like orgmode)
- [vim-localvimrc](https://github.com/embear/vim-localvimrc) (for setup project-local vim config, useful for LSP)
- [overseer.nvim](https://github.com/stevearc/overseer.nvim/tree/master) (asynchronous task runner that support `tasks.json` and many task frameworks)
- [markview.nvim](https://github.com/OXY2DEV/markview.nvim) (markdown previewer)

## Requirements

### Neovim

- [neovim](https://neovim.io/) 0.11.4+ (stable), 0.12.0+ (nightly)
- [python](https://www.python.org/) 3.6.1+ (required by defx.nvim), 3.7.0 (required pynvim 0.5.0)
  - Currently, pynvim 0.5.0 need Python 3.9: https://github.com/neovim/pynvim/issues/560
- [universal-ctags](https://github.com/universal-ctags/ctags) (required by fzf)
- C compiler and libstdc++ (required by nvim-treesitter)
- [git](https://git-scm.com/) 2.13.0 (basic), 2.19.0 (for column in `git grep`)

## Recommends

- [ripgrep](https://github.com/BurntSushi/ripgrep) (required for grepping files using FZF)
- [fd](https://github.com/sharkdp/fd) (required for goto to directory using FZF)
- [eza](https://github.com/eza-community/eza) (required for previewing directory using FZF)
- [bat](https://github.com/sharkdp/bat) (required for various preview commands using FZF)

## Installation

### Neovim

Clone the project as `~/.config/nvim`.

```
git clone https://github.com/mars90226/dotvim ~/.config/nvim
```

Open neovim and wait for `lazy.nvim` to finish the job.

## Development

Helper commands are defined in the [`justfile`](justfile).
Make sure [`just`](https://github.com/casey/just) is installed.

- `just test` runs the Lua test suite with [`busted`](https://olivinelabs.com/busted/).
- `just update_plugins` commits updated plugin lock files.

## Key mappings

`<Leader>` key is `,`.

### Picker

- `fzf` key mappings
  - `<Space>zg`: Search and open git files
  - `<Space>zf`: Search and open files
  - `<Space>zw`: Search and switch to windows
  - `<Space>zl`: Search and goto to lines in current buffer
  - `<Space>zt`: Search and goto to tags in current buffer
  - `<Space>zp`: Search and goto to tags in current project
  - `<Space>zi`: Live grep and goto files using ripgrep
  - `<Space>zr`: Grep and goto files using ripgrep
  - `<Space>zm`: Search and open most recently used files provided by neomru
  - `<Space>zh`: Search and open vim help
- `telescope.nvim` key mappings
  - `<Space>tg`: Search and open git files
  - `<Space>tf`: Search and open files
  - `<Space>tw`: Search and switch to windows
  - `<Space>tl`: Search and goto to lines in current buffer
  - `<Space>ti`: Live grep and goto files using ripgrep
  - `<Space>tr`: Grep and goto files using ripgrep
  - `<Space>tm`: Search and open most recently used files
  - `<Space>th`: Search and open vim help
- `fzf-lua` key mappings
  - `<Space>fg`: Search and open git files
  - `<Space>ff`: Search and open files
  - `<Space>fw`: Search and switch to windows
  - `<Space>fl`: Search and goto to lines in current buffer
  - `<Space>ft`: Search and goto to tags in current buffer
  - `<Space>fp`: Search and goto to tags in current project
  - `<Space>fi`: Live grep and goto files using ripgrep
  - `<Space>fr`: Grep and goto files using ripgrep
  - `<Space>fm`: Search and open most recently used files using oldfiles
  - `<Space>fh`: Search and open vim help
  - `<Space>ld`: Search and goto LSP definitions
  - `<Space>lr`: Search and goto LSP references
  - `<Space>lo`: Search and goto LSP document symbols
  - `<Space>ls`: Search and goto LSP workspace symbols
  - `<Space>lS`: Search and goto LSP workspace symbols by live query
  - `<Space>la`: Search and execute LSP code actions
  - `<Space>lx`: Search and goto document diagnostics
  - `<Space>lX`: Search and goto workspace diagnostics

### LSP

- LSP key mappings
  - `gd`: Open LSP definition/references UI
  - `gy`: Show signature help
  - `gi`: Goto implementation
  - `gr`: LSP Rename
  - `[c`: Goto previous LSP diagnostic error
  - `]c`: Goto next LSP diagnostic error
  - `<Leader>lf`: Format selected code
  - `<Leader>lf` on visual selection: Range format selected code
- `outline.nvim` key mappings
  - `<F7>`: Toggle outline.nvim that showing LSP symbols outline in sidebar
- `trouble.nvim` key mappings
  - `<Space>xx`: Show LSP workspace diagnostics in Trouble UI or toggle Trouble UI
  - `<Space>xd`: Show LSP document diagnostics in Trouble UI
  - `<Space>xs`: Show LSP document symbols in Trouble UI
  - `<Space>xl`: Show LSP definitions / references in Trouble UI
- `nvim-lint` key mappings
  - `<Leader>ll`: Execute linter

### File Explorer

- `oil.nvim` key mappings
  - `-`: Open current buffer folder in oil
  - `<Space>-`: Open current buffer folder in split in oil
- `defx.nvim` key mappings
  - `<Space>dd`: Open current buffer folder in Defx
  - `<Space>ds`: Open current buffer folder in split in Defx
  - `<F4>`: Toggle Defx as sidebar file explorer
  - `<Space><F4>`: Toggle Defx as sidebar file explorer and find current buffer

### Editor

- `grug-far.nvim` key mappings
  - `<Space>gw`: Find and replace cursor word/visual selection globally
  - `<Space>g'`: Find and replace cursor word/visual selection in current file
- `hop.nvim` key mappings
  - `<Space>w`: Goto word start
  - `<Space>;`: Search and goto pattern
  - `<Space>j`: Goto below lines
  - `<Space>k`: Goto above lines
- `lightspeed.nvim` key mappings
  - `f`: Forward search and goto 1 characters
  - `F`: Backward search and goto 1 characters
  - `;`: Forward search and goto 2 characters
  - `<M-;>`: Backward search and goto 2 characters

### Treesitter

- Treesitter key mappings
  - `af` for textobject: outer function textobject
  - `if` for textobject: inner function textobject
  - `af` for textobject: outer class textobject
  - `ic` for textobject: inner class textobject
  - `]m`: Goto next function start
  - `[m`: Goto previous function start
  - `]]`: Goto next class start
  - `[]`: Goto previous class start
  - `<F6>`: Toggle context
  - `<CR>`: Select node
  - `<CR>` in visual mode: scope incremental
  - `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>` in visual mode: navigate node
  - `<M-S-j>`, `<M-S-k>` in visual mode: swap node

### Git

- `vim-fugitive` key mappings
  - `<Leader>gs`: Show git status
  - `<Leader>gc`: Show git blame commit of current line
  - `<Leader>gd`: Compare current buffer with git indexed file using vimdiff
  - `<Leader>gb`: Show git blame of current buffer
  - `<Leader>gl`: Show git log in quickfix and display most recent commit
  - `<Leader>gL`: Show git log of current buffer in quickfix and display most recent commit
- `vim-flog` key mappings
  - `<Space>gf`: Open Flog UI
  - `<Leader>gf`: Show current file in Flog UI
  - `<Leader>gd` in Flog UI: Search and open diff files in current git commit using FZF
  - `<Leader>gd` on visual selection in Flog UI: Search and open diff files in between last git commit and first git commit using FZF
  - `<Leader>gf` in Flog UI: Search and open git files in current git commit using FZF
  - `<Leader>gg` in Flog UI: Grep and goto git files in current git commit using FZF and ripgrep

### Utility

- `vim-floaterm` key mappings
  - `<M-2>`: Toggle Floaterm terminal
  - `<M-3>`: Goto previous Floaterm terminal
  - `<M-4>`: Goto next Floaterm terminal
  - `<M-5>`: Open new Floaterm terminal
- `markview.nvim` key mappings
  - `coh` in `markdown` buffer: Toggle `markview.nvim` preview
- Custom key mappings
  - `<M-h>`, `<M-j>`, `<M-k>`, `<M-l>`: Move between windows, like `<C-W>h`, `<C-W>j`, `<C-W>k`, and `<C-W>l`
  - `<C-J>`, `<C-K>`: Move between tabs, like `gT` and `gt`
  - `<Space>q`: Close window, like `:q<CR>`
  - `<Leader>db`: Change current window working directory to folder containing current current buffer. Equivalent of `:lcd %:h<CR>`.
  - `<M-1>`: Switch to last tab
  - `<Leader>ts`: Open terminal in split
  - `<Leader>tt`: Open terminal in new tab
- Terminal key mappings
  - `<M-F1>`: Escape terminal mode to normal mode
  - `<M-r>`: Paste from register

## TODO

- [ ] Add full plugin dependencies
- [ ] Add provider plugin for dependencies
- [x] Add [nvim-dap](https://github.com/mfussenegger/nvim-dap) and related plugins.
- [ ] Add description to key mappings
- [ ] Add description to LuaSnip snippets
- [ ] Add noice.nvim
- [ ] Add other terminal plugin, like [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim), and change overseer.nvim strategy to toggleterm.
- [ ] Replace `nvim-cmp` with `blink.cmp`

## Deprecated

Vim specific config is removed, but you can use `vim` branch to access them.
Packer specific config is removed, but you can use `packer` branch to access them.

## Resources

- [rockerBOO/awesome-neovim Collections of awesome neovim plugins.](https://github.com/rockerBOO/awesome-neovim)
- [Dotfyle | Neovim Plugins & Neovim News](https://dotfyle.com/)
- [LazyVim/LazyVim Neovim config for the lazy](https://github.com/LazyVim/LazyVim)
- [AstroNvim/AstroNvim AstroNvim is an aesthetic and feature-rich neovim config that is extensible and easy to use with a great set of plugins](https://github.com/AstroNvim/AstroNvim)
- [NvChad/NvChad Blazing fast Neovim config providing solid defaults and a beautiful UI, enhancing your neovim experience.](https://github.com/NvChad/NvChad)
