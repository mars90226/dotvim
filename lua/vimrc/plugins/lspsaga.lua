local saga = require("lspsaga")
local choose = require("vimrc.choose")

local lspsaga = {}

lspsaga.on_attach = function(client)
  -- TODO: ignore some key mapping if it's none-ls.nvim lsp
  nnoremap("gd", "<Cmd>Lspsaga finder<CR>", "silent", "buffer")
  nnoremap("gi", "<Cmd>Lspsaga implement<CR>", "silent", "buffer")
  nnoremap("gpp", "<Cmd>Lspsaga peek_definition<CR>", "silent", "buffer")
  nnoremap("gr", "<Cmd>Lspsaga rename<CR>", "silent", "buffer")
  nnoremap("gx", "<Cmd>Lspsaga code_action<CR>", "silent", "buffer")
  xnoremap("gx", ":<C-U>Lspsaga range_code_action<CR>", "silent", "buffer")
  nnoremap("go", "<Cmd>Lspsaga show_line_diagnostics<CR>", "silent", "buffer")
  nnoremap("gC", "<Cmd>Lspsaga show_cursor_dianostics<CR>", "silent", "buffer")
  nnoremap("<Space><F7>", "<Cmd>Lspsaga outline<CR>", "silent", "buffer")
  nnoremap("<Plug>(diff-prev)", "[c", "silent", "buffer")
  nnoremap("<Plug>(diff-next)", "]c", "silent", "buffer")
  -- Avoid conflict with mini.bracketed
  nmap("[z", [[&diff ? "\<Plug>(diff-prev)" : "\<Cmd>Lspsaga diagnostic_jump_prev\<CR>"]], "silent", "buffer", "expr")
  nmap("]z", [[&diff ? "\<Plug>(diff-next)" : "\<Cmd>Lspsaga diagnostic_jump_next\<CR>"]], "silent", "buffer", "expr")

  -- Remap for K
  local maparg
  maparg = vim.fn.maparg("gK", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("gK", "K", "buffer")
  end
  -- Remap for gi
  maparg = vim.fn.maparg("gI", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("gI", "gi", "buffer")
  end
  -- Remap for gI
  maparg = vim.fn.maparg("g<C-I>", "n", false, true)
  if maparg == {} or maparg["buffer"] ~= 1 then
    nnoremap("g<C-I>", "gI", "buffer")
  end
end

lspsaga.setup = function()
  saga.setup({
    diagnostic = {
      on_insert = false,
    },
    finder = {
      max_height = 0.8,
      left_width = 0.45,
      right_width = 0.45,
    },
    lightbulb = {
      enable = true, -- NOTE: lspsaga will show error once when lsp not support codeAction
      enable_in_insert = true,
      sign = true,
      sign_priority = 40,
      virtual_text = false,
      debounce = 150, -- Same as LSP debounce
    },
    -- TODO: Check if lspsaga.nvim symbol is greater than nvim-navic
    symbol_in_winbar = {
      enable = choose.is_enabled_plugin("lspsaga.nvim-winbar") and choose.is_enabled_plugin("lspsaga.nvim-context"),
      click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
        local st = node.range.start
        local en = node.range["end"]
        if button == "l" then
          if clicks == 2 then
            -- double left click to do nothing
          else -- jump to node's starting line+char
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == "r" then
          if modifiers == "s" then
            print("lspsaga") -- shift right click to print "lspsaga"
          end -- jump to node's ending line+char
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == "m" then
          -- middle click to visual select node
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd("normal v")
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end,
    },
    -- NOTE: This should use 'winblend' to fade-out, but the terminal emulator doesn't support
    -- 'winblend', so raise frequency to 15 to get the total beacon time = 60 / 15 * 0.1s = 0.4s
    -- Ref: https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/libs.lua#L321-L341
    beacon = {
      enable = true,
      frequency = 7, -- default is 7
    }
  })
end

return lspsaga
