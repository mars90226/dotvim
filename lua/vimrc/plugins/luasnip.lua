local ls = require("luasnip")
local types = require("luasnip.util.types")

local has_secret_luasnip, secret_luasnip = pcall(require, "secret.luasnip")

local luasnip = {}

-- Ref: https://github.com/L3MON4D3/LuaSnip/wiki/Misc#choicenode-popup
local current_nsid = vim.api.nvim_create_namespace("LuaSnipChoiceListSelections")
local current_win = nil

local function window_for_choice_node(choice_node)
  local buf = vim.api.nvim_create_buf(false, true)
  local buf_text = {}
  local row_selection = 0
  local row_offset = 0
  local text
  for _, node in ipairs(choice_node.choices) do
    text = node:get_docstring()
    -- find one that is currently showing
    if node == choice_node.active_choice then
      -- current line is starter from buffer list which is length usually
      row_selection = #buf_text
      -- finding how many lines total within a choice selection
      row_offset = #text
    end
    vim.list_extend(buf_text, text)
  end

  vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, buf_text)
  local w, h = vim.lsp.util._make_floating_popup_size(buf_text)
  -- NOTE: function node may have 0 width initially and is expanded on select.
  w = w > 0 and w or 1

  -- adding highlight so we can see which one is been selected.
  local extmark = vim.api.nvim_buf_set_extmark(
    buf,
    current_nsid,
    row_selection,
    0,
    { hl_group = "incsearch", end_line = row_selection + row_offset }
  )

  -- shows window at a beginning of choice_node.
  local win = vim.api.nvim_open_win(buf, false, {
    relative = "win",
    width = w,
    height = h,
    bufpos = choice_node.mark:pos_begin_end(),
    style = "minimal",
    border = "rounded",
  })

  -- return with 3 main important so we can use them again
  return { win_id = win, extmark = extmark, buf = buf }
end

luasnip.exclude_filetypes = {}

luasnip.is_exclude_filetype = function(filetype)
  return vim.tbl_contains(luasnip.exclude_filetypes, filetype)
end

luasnip.choice_popup = function(choice_node)
  if luasnip.is_exclude_filetype(vim.bo.ft) then
    return
  end

  -- build stack for nested choice_nodes.
  if current_win then
    vim.api.nvim_win_close(current_win.win_id, true)
    vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  end
  local create_win = window_for_choice_node(choice_node)
  current_win = {
    win_id = create_win.win_id,
    prev = current_win,
    node = choice_node,
    extmark = create_win.extmark,
    buf = create_win.buf,
  }
end

luasnip.update_choice_popup = function(choice_node)
  if luasnip.is_exclude_filetype(vim.bo.ft) then
    return
  end

  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  local create_win = window_for_choice_node(choice_node)
  current_win.win_id = create_win.win_id
  current_win.extmark = create_win.extmark
  current_win.buf = create_win.buf
end

luasnip.choice_popup_close = function()
  if luasnip.is_exclude_filetype(vim.bo.ft) then
    return
  end

  vim.api.nvim_win_close(current_win.win_id, true)
  vim.api.nvim_buf_del_extmark(current_win.buf, current_nsid, current_win.extmark)
  -- now we are checking if we still have previous choice we were in after exit nested choice
  current_win = current_win.prev
  if current_win then
    -- reopen window further down in the stack.
    local create_win = window_for_choice_node(current_win.node)
    current_win.win_id = create_win.win_id
    current_win.extmark = create_win.extmark
    current_win.buf = create_win.buf
  end
end

luasnip.setup_choice_popup = function()
  vim.cmd([[
    augroup choice_popup
      autocmd!
      autocmd User LuasnipChoiceNodeEnter lua require("vimrc.plugins.luasnip").choice_popup(require("luasnip").session.event_node)
      autocmd User LuasnipChoiceNodeLeave lua require("vimrc.plugins.luasnip").choice_popup_close()
      autocmd User LuasnipChangeChoice lua require("vimrc.plugins.luasnip").update_choice_popup(require("luasnip").session.event_node)
    augroup END
  ]])
end

luasnip.setup_snippet = function()
  local s = ls.snippet
  local sn = ls.snippet_node
  local t = ls.text_node
  local i = ls.insert_node
  local c = ls.choice_node
  local f = ls.function_node

  local fmt = require("luasnip.extras.fmt").fmt

  local same = function(index)
    return f(function(args)
      return args[1]
    end, { index })
  end

  -- TODO: Add index
  -- TODO: Add dynamic node
  local fzf_tmux_choice = function(choices)
    return f(function()
      return vim.fn["vimrc#fzf#choices_in_commandline"](choices)
    end)
  end

  local chinese_punctuation_snippets = {
    s(
      "cp",
      c(1, {
        t("，"),
        t("。"),
        t("、"),
        t("："),
        t("；"),
        t("！"),
        t("？"),
        t("「"),
        t("」"),
      })
    ),
    s("cp,", t("，")),
    s("cp.", t("。")),
    s("cp'", t("、")),
    s("cp:", t("：")),
    s("cp;", t("；")),
    s("cp!", t("！")),
    s("cp?", t("？")),
    s("cp[", t("「")),
    s("cp]", t("」")),
    s(
      "cpf",
      fzf_tmux_choice({
        "，",
        "。",
        "、",
        "：",
        "；",
        "！",
        "？",
        "「",
        "」",
      })
    ),
  }

  ls.add_snippets("gitcommit", {
    s(
      "cc",
      fmt("{type}({module}): {message}", {
        type = c(1, {
          t("feat"),
          t("fix"),
          t("docs"),
          t("style"),
          t("refactor"),
          t("perf"),
          t("test"),
          t("build"),
          t("ci"),
          t("chore"),
          t("revert"),
        }),
        module = i(2, "module"),
        message = i(3, "message"),
      })
    ),
  })

  ls.add_snippets("markdown", chinese_punctuation_snippets)
  ls.add_snippets("vimwiki", chinese_punctuation_snippets)

  ls.add_snippets("markdown", {
    -- emmet
    s("el", fmt("<{}>{}</{}>", { i(1, "div"), i(0), same(1) })),

    -- description
    s("desc", t("**[Description]**")),
    s("htf", t("**[How to fix]**")),
    s("htv", t("**[How to verify]**")),
  })

  ls.add_snippets("lua", {
    s(
      "mod",
      fmt(
        [[
        local {} = {{}}

        {}.setup = function()
          {}
        end

        return {}
        ]],
        {
          i(1, "module"),
          same(1),
          i(0),
          same(1),
        }
      )
    ),
  })

  local exp_generator = function(get_bufnr_fn)
    return function(modifier)
      return f(function()
        local filename = vim.api.nvim_buf_get_name(get_bufnr_fn())

        return vim.fn.fnamemodify(filename, modifier)
      end)
    end
  end
  local insert_exp = exp_generator(function()
    return vim.api.nvim_get_current_buf()
  end)
  local fine_cmdline_exp = exp_generator(function()
    return require("vimrc.plugins.fine-cmdline").get_related_bufnr()
  end)

  ls.add_snippets("all", {
    s(
      "exp",
      c(1, {
        insert_exp(":t"),
        insert_exp(":t:r"),
        insert_exp(":p"),
        insert_exp(":h"),
      })
    ),
  })
  ls.add_snippets("fine-cmdline", {
    s(
      "exp",
      c(1, {
        fine_cmdline_exp(":t"),
        fine_cmdline_exp(":t:r"),
        fine_cmdline_exp(":p"),
        fine_cmdline_exp(":h"),
      })
    ),
  })

  ls.add_snippets("all", {
    s(
      "gf",
      f(function()
        return vim.fn["vimrc#fzf#files_in_commandline"]()
      end)
    ),
    s(
      "gm",
      f(function()
        return vim.fn["vimrc#fzf#mru#mru_in_commandline"]()
      end)
    ),
    s(
      "gd",
      f(function()
        return vim.fn["vimrc#fzf#mru#directory_mru_in_commandline"]()
      end)
    ),
    s(
      "gy",
      f(function()
        return vim.fn["vimrc#fugitive#commit_sha"]()
      end)
    ),
    s(
      "gc",
      f(function()
        return vim.fn["vimrc#git#get_current_branch"]()
      end)
    ),
    s(
      "gi",
      f(function()
        return vim.fn["vimrc#fzf#git#commits_in_commandline"]()
      end)
    ),
    s(
      "gb",
      f(function()
        return vim.fn["vimrc#fzf#git#branches_in_commandline"]()
      end)
    ),
    s(
      "gt",
      f(function()
        return vim.fn["vimrc#fzf#git#tags_in_commandline"]()
      end)
    ),
    s(
      "ge",
      f(function()
        return vim.fn["vimrc#git#get_email"]()
      end)
    ),
    s("cd", t(vim.g.company_domain)),
    s("ce", t(vim.g.company_email)),
    s(
      "xx",
      f(function()
        return vim.fn["vimrc#fzf#shell_outputs_in_commandline"]()
      end)
    ),
  })
end

luasnip.setup = function()
  -- Borrowed from TJ's dotfile: https://github.com/tjdevries/config_manager
  ls.config.setup({
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,

    -- This one is cool cause if you have dynamic snippets, it updates as you type!
    updateevents = "TextChanged,TextChangedI",

    -- Autosnippets:
    enable_autosnippets = true,

    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<-", "Error" } },
        },
      },
    },
  })

  luasnip.setup_snippet()

  if has_secret_luasnip then
    secret_luasnip.setup()
  end

  local utils = require("vimrc.utils")

  -- TODO: Remove this, use default lazy_load()/
  local load_opts = {
    paths = vim.tbl_filter(function(path)
      return vim.fn.isdirectory(path) > 0
    end, {
      utils.get_lazy_dir() .. "/friendly-snippets",
      vim.env.HOME .. "/.vim",
      vim.env.HOME .. "/.vim_secret",
    }),
  }

  require("luasnip.loaders.from_vscode").lazy_load(load_opts)

  luasnip.setup_choice_popup()
end

return luasnip
