local ls = require("luasnip")
local types = require("luasnip.util.types")

local has_secret_luasnip, secret_luasnip = pcall(require, "secret.luasnip")

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

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt

local cc_gitmessage = function(type)
  return fmt(type .. "({}): {}", { i(1, "module"), i(2, "message") })
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

local fine_cmdline_exp = function(modifier)
  return f(function()
    local fine_cmdline = require("vimrc.plugins.fine-cmdline")
    local filename = vim.api.nvim_buf_get_name(fine_cmdline.get_related_bufnr())

    return vim.fn.fnamemodify(filename, modifier)
  end)
end

ls.add_snippets("fine-cmdline", {
  s(
    "exp",
    c(1, {
      fine_cmdline_exp(":t"),
      fine_cmdline_exp(":t:r"),
      fine_cmdline_exp(":p"),
      fine_cmdline_exp(":h"),
    })
  )
})

if has_secret_luasnip then
  secret_luasnip.setup()
end

local utils = require("vimrc.utils")

local load_opts = {
  paths = vim.tbl_filter(function(path)
    return vim.fn.isdirectory(path) > 0
  end, {
    utils.get_packer_start_dir() .. "/friendly-snippets",
    vim.env.HOME .. "/.vim",
    vim.env.HOME .. "/.vim_secret",
  }),
}

require("luasnip.loaders.from_vscode").lazy_load(load_opts)

require("vimrc.plugins.luasnip").setup_choice_popup()
