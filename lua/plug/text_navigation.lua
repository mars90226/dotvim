local text_navigation = {}

text_navigation.startup = function(use)
  -- Match
  use({
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = {
        method = "status_manual", -- we already have nvim-treesitter-context
      }

      nnoremap("<Leader>mk", [[<Cmd>MatchupWhereAmI?<CR>]])

      if vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-treesitter") == 1 then
        require("nvim-treesitter.configs").setup({
          matchup = {
            enable = true, -- mandatory, false will disable the whole extension
            -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
          },
        })
      end
    end,
  })

  -- Jump
  use({
    "easymotion/vim-easymotion",
    disable = true,
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
    setup = function()
      vim.g.EasyMotion_leader_key = "<Space>"
      vim.g.EasyMotion_smartcase = 1
    end,
    config = function()
      map([[\w]], "<Plug>(easymotion-bd-wl)")
      map([[\f]], "<Plug>(easymotion-bd-fl)")
      map([[\s]], "<Plug>(easymotion-sl2)")

      map("<Space><Space>t", "<Plug>(easymotion-bd-t)")
      map("<Plug>(easymotion-prefix)s", "<Plug>(easymotion-bd-f2)")
      map("<Plug>(easymotion-prefix)w", "<Plug>(easymotion-bd-w)")
      map("<Plug>(easymotion-prefix)W", "<Plug>(easymotion-bd-W)")
      map("<Plug>(easymotion-prefix)e", "<Plug>(easymotion-bd-e)")
      map("<Plug>(easymotion-prefix)E", "<Plug>(easymotion-bd-E)")

      nmap("<Leader>'", "<Plug>(easymotion-next)")
      nmap("<Leader>;", "<Plug>(easymotion-prev)")
      nmap("<Leader>.", "<Plug>(easymotion-repeat)")

      map("<Plug>(easymotion-prefix)J", "<Plug>(easymotion-eol-j)")
      map("<Plug>(easymotion-prefix)K", "<Plug>(easymotion-eol-k)")

      map("<Plug>(easymotion-prefix);", "<Plug>(easymotion-jumptoanywhere)")
    end,
  })
  use({
    "phaazon/hop.nvim",
    config = function()
      map("<Space>w", "<Cmd>HopWord<CR>")
      map("<Space>e", [[<Cmd>lua require('hop').hint_patterns({}, '\\k\\>')<CR>]])
      map("<Space>;", "<Cmd>HopPattern<CR>")
      map("<Space><Space>f", "<Cmd>HopChar1<CR>")
      map("<Space><Space>l", "<Cmd>HopLine<CR>")
      map("<Space>j", "<Cmd>HopLineAC<CR>")
      map("<Space>k", "<Cmd>HopLineBC<CR>")

      require("hop").setup({})
    end,
  })
  if vim.fn["vimrc#plugin#is_enabled_plugin"]("nvim-treesitter") == 1 then
    -- FIXME: Broken in neovim v0.7.0, commit 297ff97647
    -- Ref: https://github.com/neovim/neovim/pull/16745
    use({
      "indianboy42/hop-extensions",
      config = function()
        -- Treesitter
        map("<Space>hl", [[<Cmd>lua require('hop-extensions').hint_locals()<CR>]])
        map("<Space>hd", [[<Cmd>lua require('hop-extensions').hint_definitions()<CR>]])
        map("<Space>hr", [[<Cmd>lua require('hop-extensions').hint_references()<CR>]])
        map("<Space>hs", [[<Cmd>lua require('hop-extensions').hint_scopes()<CR>]])
        map("<Space>ht", [[<Cmd>lua require('hop-extensions').hint_textobjects()<CR>]])

        -- LSP
        -- TODO: LSP functions is incomplete
      end,
    })
  end
  use({
    "ggandor/lightspeed.nvim",
    config = function()
      map(";", "<Plug>Lightspeed_s")
      map("<M-;>", "<Plug>Lightspeed_S")
    end,
  })

  -- Search
  use("haya14busa/vim-asterisk")
  use({
    "kevinhwang91/nvim-hlslens",
    config = function()
      noremap("n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], "silent")
      noremap("N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], "silent")

      -- vim-asterisk
      map("*", [[<Plug>(asterisk-*)<Cmd>lua require('hlslens').start()<CR>]])
      map("#", [[<Plug>(asterisk-#)<Cmd>lua require('hlslens').start()<CR>]])
      map("g*", [[<Plug>(asterisk-g*)<Cmd>lua require('hlslens').start()<CR>]])
      map("g#", [[<Plug>(asterisk-g#)<Cmd>lua require('hlslens').start()<CR>]])
      map("z*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]])
      map("gz*", [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]])
      map("z#", [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]])
      map("gz#", [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]])

      -- Search within visual selection
      xnoremap("<M-/>", [[<Esc>/\%V]])
      xnoremap("<M-?>", [[<Esc>?\%V]])
    end,
  })

  -- Marks
  use({
    "chentau/marks.nvim",
    config = function()
      require("marks").setup({})
    end,
  })

  -- Motion
  use({
    "bkad/CamelCaseMotion",
    config = function()
      map("<Leader>mw", "<Plug>CamelCaseMotion_w")
      map("<Leader>mb", "<Plug>CamelCaseMotion_b")
      map("<Leader>me", "<Plug>CamelCaseMotion_e")
      map("<Leader>mge", "<Plug>CamelCaseMotion_ge")

      omap("imw", "<Plug>CamelCaseMotion_iw", "silent")
      xmap("imw", "<Plug>CamelCaseMotion_iw", "silent")
      omap("imb", "<Plug>CamelCaseMotion_ib", "silent")
      xmap("imb", "<Plug>CamelCaseMotion_ib", "silent")
      omap("ime", "<Plug>CamelCaseMotion_ie", "silent")
      xmap("ime", "<Plug>CamelCaseMotion_ie", "silent")
    end,
  })

  use({
    "haya14busa/vim-edgemotion",
    config = function()
      map("<Space><Space>j", "<Plug>(edgemotion-j)")
      map("<Space><Space>k", "<Plug>(edgemotion-k)")
    end,
  })

  use({ "jeetsukumaran/vim-indentwise", event = { "FocusLost", "CursorHold", "CursorHoldI" } })
end

return text_navigation
