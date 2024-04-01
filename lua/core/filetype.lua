local plugin_utils = require("vimrc.plugin_utils")

local filetype = {}

filetype.setup = function()
  local use_config = function(plugin_spec)
    plugin_spec.config()
  end

  use_config({
    "mars90226/filetype",
    config = function()
      local has_secret_filetype, secret_filetype = pcall(require, "secret.filetype")

      vim.filetype.add({
        extension = {
          -- bash
          bashrc = "bash",

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

          -- UltiSnips
          snippets = "snippets",

          -- todo
          todo = "todo",

          -- upstart
          upstart = "upstart",
        },
        filename = {
          -- git
          [".gitignore"] = "conf",

          -- config
          [".ignore"] = "conf",

          -- doxygen
          ["Doxyfile"] = "dosini",

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
          ["app.config"] = "json",

          -- python
          [".pylintrc"] = "dosini",
          [".flake8"] = "dosini",

          -- vim
          [".config_cache"] = "vim",

          -- syslog-ng
          ["syslog-ng.conf"] = "syslog-ng",

          -- tmux
          [".tmux.conf"] = "tmux",
        },
        -- NOTE: pattern match full path & tail, so do not use relative path to git root
        pattern = {
          -- bash
          -- TODO: Remove this when neovim 0.10 is released
          -- Fixed in https://github.com/neovim/neovim/commit/fdf5013e218c55ca8f9bdb7cf5f16f8596330ea2
          ["bash%-fc.*"] = { "bash", { priority = -10 } },

          -- config
          [".*conf"] = { "conf", { priority = -10 } },
          [".*conf%.local"] = { "conf", { priority = -10 } },
          [".*conf%.local%.override"] = { "conf", { priority = -10 } },
          [".*/conf/template/.*"] = { "conf", { priority = -10 } },
          [".*/.*%.template"] = { "conf", { priority = -10 } },

          -- git
          ["%.gitconfig%-.*"] = "gitconfig",

          -- logrotate
          [".*%.logrotate"] = "logrotate",

          -- maillog
          [".*maillog"] = "messages",
          [".*maillog%.%d+"] = "messages",
          [".*maillog%.%d+%.xz"] = "messages",

          -- nginx
          [".*/www/.*%.conf"] = { "nginx", { priority = 10 } },

          -- project
          ["depends%-virtual%-.*"] = "dosini",
          ["settings%-virtual%-.*"] = "dosini",
          ["strings%-virtual%-.*"] = "dosini",
          [".*/conf/resource.*"] = { "json", { priority = 10 } },
          [".*/conf/privilege.*"] = { "json", { priority = 10 } },
          [".*/conf/PKG_DEPS.*"] = { "dosini", { priority = 10 } },
          [".*/backup/export"] = "bash",
          [".*/backup/import"] = "bash",
          [".*/backup/can_export"] = "bash",
          [".*/backup/can_import"] = "bash",
          [".*/backup/info"] = "json",
          [".*/backup/info.dynamic"] = "bash",

          -- rspamd
          [".*/conf/rspamd%.conf.*"] = { "rspamd", { priority = 10 } },
          [".*/rspamd/.*%.inc"] = { "rspamd", { priority = 10 } },
          [".*/conf/modules%.d/.*%.conf"] = { "rspamd", { priority = 10 } },
          [".*/conf/local%.d/.*%.conf"] = { "rspamd", { priority = 10 } },

          -- spamassassin
          [".*/sa%-update%-rules/.*%.cf"] = { "spamassassin", { priority = 10 } },
          [".*/spamassassin/.*%.cf"] = { "spamassassin", { priority = 10 } },

          -- syslog-ng
          [".*/syslog%-ng/.*%.conf"] = { "syslog-ng", { priority = 10 } },
          [".*/patterndb%.d/.*%.conf"] = { "syslog-ng", { priority = 10 } },

          -- upstart
          [".*/upstart/.*conf"] = { "upstart", { priority = 10 } },
        },
      })

      if has_secret_filetype then
        secret_filetype.setup()
      end

      vim.cmd([[filetype on]])
      vim.cmd([[filetype plugin on]])
      vim.cmd([[filetype indent on]])
    end,
  })
end

return filetype
