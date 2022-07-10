local text_manipulation = {}

text_manipulation.startup = function(use)
  -- Comment
  use({
    "numToStr/Comment.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    config = function()
      require("Comment").setup()
    end,
  })

  use({
    "junegunn/vim-easy-align",
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      xmap("ga", "<Plug>(EasyAlign)")

      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      nmap("ga", "<Plug>(EasyAlign)")

      nmap("<Leader>ga", "<Plug>(LiveEasyAlign)")
      xmap("<Leader>ga", "<Plug>(LiveEasyAlign)")
    end,
  })

  use({
    "vim-scripts/eraseSubword",
    config = function()
      vim.g.EraseSubword_insertMap = "<C-B>"
    end,
  })

  -- Substitute & Exchange
  use({
    "gbprod/substitute.nvim",
    config = function()
      -- TODO: Create issue for substitute not change cursor position back to original position for expand('<cword>')
      require("substitute").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })

      -- Substitute
      nnoremap("ss", "<Cmd>lua require('substitute').operator()<CR>")
      nnoremap("sS", "<Cmd>lua require('substitute').line()<CR>")
      nnoremap("sl", "<Cmd>lua require('substitute').eol()<CR>")
      xnoremap("ss", "<Cmd>lua require('substitute').visual()<CR>")

      -- Substitute using system clipboard
      nnoremap("=ss", "<Cmd>lua require('substitute').operator({ register = '+' })<CR>")
      nnoremap("=sS", "<Cmd>lua require('substitute').line({ register = '+' })<CR>")
      nnoremap("=sl", "<Cmd>lua require('substitute').eol({ register = '+' })<CR>")
      xnoremap("=ss", "<Cmd>lua require('substitute').visual({ register = '+' })<CR>")

      -- Substitute over range
      nnoremap("<Leader>s", "<Cmd>lua require('substitute.range').operator()<CR>")
      xnoremap("<Leader>s", "<Cmd>lua require('substitute.range').visual()<CR>")
      nnoremap("<Leader>ss", "<Cmd>lua require('substitute.range').word()<CR>")

      -- Substitute over range confirm
      nnoremap("scr", "<Cmd>lua require('substitute.range').operator({ confirm = true })<CR>")
      xnoremap("scr", "<Cmd>lua require('substitute.range').visual({ confirm = true })<CR>")
      nnoremap("scrr", "<Cmd>lua require('substitute.range').word({ confirm = true })<CR>")

      -- Substitute over range Subvert (depends on vim-abolish)
      nnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').operator({ prefix = 'S' })<CR>")
      xnoremap("<Leader><Leader>s", "<Cmd>lua require('substitute.range').visual({ prefix = 'S' })<CR>")
      nnoremap("<Leader><Leader>ss", "<Cmd>lua require('substitute.range').word({ prefix = 'S' })<CR>")

      -- Exchange
      nnoremap("cx", "<Cmd>lua require('substitute.exchange').operator()<CR>")
      nnoremap("cxx", "<Cmd>lua require('substitute.exchange').line()<CR>")
      xnoremap("X", "<Cmd>lua require('substitute.exchange').visual()<CR>")
      nnoremap("cxc", "<Cmd>lua require('substitute.exchange').cancel()<CR>")
    end,
  })

  -- Surround
  use({
    "machakann/vim-sandwich",
    config = function()
      local utils = require("vimrc.utils")

      xmap("iss", "<Plug>(textobj-sandwich-auto-i)")
      xmap("ass", "<Plug>(textobj-sandwich-auto-a)")
      omap("iss", "<Plug>(textobj-sandwich-auto-i)")
      omap("ass", "<Plug>(textobj-sandwich-auto-a)")

      xmap("iy", "<Plug>(textobj-sandwich-literal-query-i)")
      xmap("ay", "<Plug>(textobj-sandwich-literal-query-a)")
      omap("iy", "<Plug>(textobj-sandwich-literal-query-i)")
      omap("ay", "<Plug>(textobj-sandwich-literal-query-a)")

      -- Seems bundled vim-textobj-functioncall does not work
      -- xmap ad <Plug>(textobject-sandwich-function-a)
      -- xmap id <Plug>(textobject-sandwich-function-i)
      -- omap ad <Plug>(textobject-sandwich-function-a)
      -- omap id <Plug>(textobject-sandwich-function-i)

      -- Add vim-surround key mapping for vim-visual-multi
      -- Borrowed from vim-sandwich/macros/sandwich/keymap/surround.vim
      nmap("ys", "<Plug>(operator-sandwich-add)")
      -- TODO: May conflict with vim-sandwich
      onoremap("<Plug>(operator-sandwich-custom-line)", ":normal! ^vg_<CR>")
      nmap("yss", "<Plug>(operator-sandwich-add)<Plug>(operator-sandwich-custom-line)", "silent")
      -- TODO: May conflict with vim-sandwich
      onoremap("<Plug>(operator-sandwich-custom-gul)", "g_")
      nmap("yS", "ys<Plug>(operator-sandwich-custom-gul)")

      nmap(
        "ds",
        "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)"
      )
      nmap(
        "dss",
        "<Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)"
      )
      nmap(
        "cs",
        "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)"
      )
      nmap(
        "css",
        "<Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)"
      )

      -- To avoid mis-deleting character when cancelling sandwich operator
      nnoremap("s<Esc>", "<NOP>")

      -- if you have not copied default recipes
      local sandwich_recipes = vim.fn.deepcopy(vim.g["sandwich#default_recipes"])

      -- add spaces inside bracket
      utils.table_concat(sandwich_recipes, {
        {
          buns = { "{ ", " }" },
          nesting = 1,
          match_syntax = 1,
          kind = { "add", "replace" },
          action = { "add" },
          input = {
            "}",
          },
        },
        {
          buns = { "[ ", " ]" },
          nesting = 1,
          match_syntax = 1,
          kind = { "add", "replace" },
          action = { "add" },
          input = {
            "]",
          },
        },
        {
          buns = { "( ", " )" },
          nesting = 1,
          match_syntax = 1,
          kind = { "add", "replace" },
          action = { "add" },
          input = {
            ")",
          },
        },
        {
          buns = { "{\\s*", "\\s*}" },
          nesting = 1,
          regex = 1,
          match_syntax = 1,
          kind = { "delete", "replace", "textobj" },
          action = { "delete" },
          input = { "}" },
        },
        {
          buns = { "\\[\\s*", "\\s*\\]" },
          nesting = 1,
          regex = 1,
          match_syntax = 1,
          kind = { "delete", "replace", "textobj" },
          action = { "delete" },
          input = { "]" },
        },
        {
          buns = { "(\\s*", "\\s*)" },
          nesting = 1,
          regex = 1,
          match_syntax = 1,
          kind = { "delete", "replace", "textobj" },
          action = { "delete" },
          input = { ")" },
        },
      })

      vim.g["sandwich#recipes"] = sandwich_recipes
    end,
  })

  -- imap <BS> & <CR> is overwritten, need to be careful of bugs
  use({
    "mg979/vim-visual-multi",
    config = function()
      -- nvim-hlslens integration
      vim.cmd([[augroup vmlens_settings]])
      vim.cmd([[  autocmd!]])
      vim.cmd([[  autocmd User visual_multi_start lua require('vimrc.plugins.vmlens').start()]])
      vim.cmd([[  autocmd User visual_multi_exit lua require('vimrc.plugins.vmlens').exit()]])
      vim.cmd([[augroup END]])
    end,
  })

  -- For vim-markdown :TableFormat
  use({
    "godlygeek/tabular",
    cmd = "Tabularize",
  })

  use("editorconfig/editorconfig-vim")
  use("AndrewRadev/splitjoin.vim")
  use("tpope/vim-repeat")
end

return text_manipulation
