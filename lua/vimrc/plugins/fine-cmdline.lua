local cmp = require("cmp")
local luasnip = require("luasnip")

local fine_cmdline = {}

fine_cmdline.related_bufnr = 0

fine_cmdline.get_related_bufnr = function()
  return fine_cmdline.related_bufnr
end

fine_cmdline.set_related_bufnr = function(related_bufnr)
  fine_cmdline.related_bufnr = related_bufnr
end

fine_cmdline.setup = function()
  -- TODO: Check if tab variable is needed
  local related_bufnr = 0

  require("fine-cmdline").setup({
    popup = {
      buf_options = {
        ft = "fine-cmdline",
      },
    },
    hooks = {
      before_mount = function(_)
        fine_cmdline.set_related_bufnr(vim.api.nvim_get_current_buf())
      end,
      set_keymaps = function(imap, feedkeys)
        -- TODO: Refactor
        local max_buffer_size = 1024 * 1024 -- 1 Megabyte max

        local buffer_source = {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local buf = fine_cmdline.get_related_bufnr()
              local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              if byte_size > max_buffer_size then
                return {}
              end
              return { buf }
            end,
          },
        }

        -- NOTE: cmp-cmdline seems not working in insert mode
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "path" },
            { name = "luasnip" },
          }, {
            buffer_source,
          }),
          -- NOTE: Use native_menu to make cmp.visible() work.
          -- As cmp custom menu will draw outside of fine-line and is considered not "visible"?
          view = {
            entries = "native",
          },
        })

        -- Ref: cmp.mapping.preset.cmdline without fallback
        local keymaps = {
          -- nvim-cmp
          -- NOTE: Use <C-/> & <M-/> to trigger cmp to preserve fine-cmdline original completion
          -- <C-_> for <C-/>
          ["<C-_>"] = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
          ["<M-/>"] = function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end,
          ["<C-E>"] = function()
            if not cmp.close() then
              feedkeys("<C-E>")
            end
          end,

          -- LuaSnip
          ["<C-J>"] = function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end,
          ["<C-K>"] = function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end,
          ["<M-j>"] = function()
            if luasnip.choice_active() then
              luasnip.change_choice(1)
            end
          end,
          ["<M-k>"] = function()
            if luasnip.choice_active() then
              luasnip.change_choice(-1)
            end
          end,
        }

        for key, mapping in pairs(keymaps) do
          imap(key, mapping)
        end
      end,
    },
  })

  nnoremap("<C-P>", [[<Cmd>lua require('fine-cmdline').open()<CR>]])
end

return fine_cmdline
