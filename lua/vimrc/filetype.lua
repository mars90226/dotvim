local filetype = {}

filetype.setup = function()
  -- NOTE: filetype.lua need to be loaded before syntax.lua as ":syntax on" will also execute ":filetype on"
  -- NOTE: enable filetype.lua
  vim.g.do_filetype_lua = 1

  vim.filetype.add({
    extension = {
      -- bash
      bashrc = "sh",

      -- c/c++ build
      build = "cerr",

      -- config
      cf = "conf",

      -- gdb
      gdbinit = "gdb",

      -- ruby
      ru = "ruby",

      -- sieve
      sieve = "sieve",

      -- upstart
      upstart = "upstart",
    },
    filename = {
      -- git
      [".gitignore"] = "conf",

      -- config
      [".ignore"] = "conf",

      -- just
      ["justfile"] = "make",

      -- make
      ["Makefile.inc"] = "make",

      -- postfix
      ["main.cf"] = "pfmain",

      -- project
      ["depends"] = "dosini",
      ["settings"] = "dosini",
      ["strings"] = "dosini",
      ["PKG_DEPS"] = "dosini",
      ["config.define"] = "json",
      ["config.define.cfg"] = "json",
      ["config.debug"] = "json",
      ["config.debug.cfg"] = "json",

      -- python
      [".pylintrc"] = "dosini",
      [".flake8"] = "dosini",

      -- vim
      [".plugin_config_cache"] = "vim",

      -- syslog-ng
      ["syslog-ng.conf"] = "syslog-ng",

      -- tmux
      [".tmux.conf"] = "tmux",
    },
    pattern = {
      -- config
      [".*conf"] = "conf",
      [".*conf%.local"] = "conf",
      [".*conf%.local%.override"] = "conf",
      [".*/conf/template/.*"] = "conf",
      [".*/.*%.template"] = "conf",

      -- git
      ["%.gitconfig-.*"] = "gitconfig",

      -- maillog
      [".*maillog"] = "messages",
      [".*maillog%.%d+"] = "messages",
      [".*maillog%.%d+%.xz"] = "messages",

      -- project
      ["depends-virutal-.*"] = "dosini",
      ["settings-virutal-.*"] = "dosini",
      ["strings-virutal-.*"] = "dosini",
      [".*/conf/resource.*"] = { "json", { priority = 10 } },
      [".*/conf/privilege.*"] = { "json", { priority = 10 } },
      [".*/backup/export"] = "sh",
      [".*/backup/import"] = "sh",
      [".*/backup/can_export"] = "sh",
      [".*/backup/can_import"] = "sh",
      [".*/backup/info"] = "json",
      [".*/backup/info.dynamic"] = "sh",

      -- rspamd
      ["conf/rspamd.conf.*"] = { "rspamd", { priority = 10 } },
      [".*/rspamd/.*%.inc"] = { "rspamd", { priority = 10 } },
      ["conf/modules.d/.*%.conf"] = { "rspamd", { priority = 10 } },
      ["conf/local.d/.*%.conf"] = { "rspamd", { priority = 10 } },

      -- spamassassin
      ["sa-update-rules/.*%.cf"] = "spamassassin",

      -- syslog-ng
      ["patterndb.d/.*%.conf"] = { "syslog-ng", { priority = 10 } },

      -- upstart
      [".*/upstart/.*conf"] = { "upstart", { priority = 10 } },
    },
  })

  vim.cmd([[filetype on]])
  vim.cmd([[filetype plugin on]])
  vim.cmd([[filetype indent on]])
end

return filetype
