local plugin_utils = require("vimrc.plugin_utils")

local job = {}

job.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/job",
    -- TODO: which-key.nvim will not show these key mappings
    -- keys = {'<Leader>x', '<Leader>b', '<Leader>k'},
    config = function()
      local execute_prefix = "<Leader>x"
      local open_url_prefix = "<Leader>b"
      local search_keyword_prefix = "<Leader>k"

      -- TODO: Only define client browser command if $SSH_CLIENT_HOST exists
      local browser_maps = {
        OpenUrl = { "current", "open_url", open_url_prefix, "b" },
        SearchKeyword = { "current", "search_keyword", search_keyword_prefix, "k" },
        ClientOpenUrl = { "client", "open_url", open_url_prefix, "c" },
        ClientSearchKeyword = { "client", "search_keyword", search_keyword_prefix, "c" },
      }
      -- TODO: Refactor
      -- TODO: Should be automatically choosing client or current browser
      local search_engine_maps = {
        SearchKeywordGoogle = { "current", "google", search_keyword_prefix, "g" },
        SearchKeywordDdg = { "current", "duckduckgo", search_keyword_prefix, "d" },
        SearchKeywordDevDocs = { "current", "devdocs", search_keyword_prefix, "e" },
        SearchKeywordMdn = { "current", "mdn", search_keyword_prefix, "m" },
        ClientSearchKeywordGoogle = { "client", "google", search_keyword_prefix, "h" },
        ClientSearchKeywordDdg = { "client", "duckduckgo", search_keyword_prefix, "v" },
        ClientSearchKeywordDevDocs = { "client", "devdocs", search_keyword_prefix, "b" },
        ClientSearchKeywordMdn = { "client", "mdn", search_keyword_prefix, "m" },
      }
      local execute_maps = {
      -- Required by fugitive :GBrowse
        Browse = { "current", "open", execute_prefix, "x" },
        BrowseKeyword = { "current", "open_keyword", execute_prefix, "x" },
      }

      for command, definition in pairs(browser_maps) do
        local browser = definition[1]
        local type = definition[2]
        local prefix = definition[3]
        local suffix = definition[4]

        vim.fn["vimrc#browser#define_command"](command, browser, type, prefix, suffix)
      end

      for command, definition in pairs(search_engine_maps) do
        local browser = definition[1]
        local search_engine = definition[2]
        local prefix = definition[3]
        local suffix = definition[4]

        vim.fn["vimrc#search_engine#define_command"](command, browser, search_engine, prefix, suffix)
      end

      for command, definition in pairs(execute_maps) do
        local browser = definition[1]
        local type = definition[2]
        local prefix = definition[3]
        local suffix = definition[4]

        vim.fn["vimrc#browser#define_command"](command, browser, type, prefix, suffix)
      end
    end,
  })
end

return job
