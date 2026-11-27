update_plugins:
	@echo 'Update plugins'
	git add lazy-lock.json
	git commit -m 'chore(lazy.nvim): update plugins'

test:
	@busted
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-fzf-sync.XXXXXX)" timeout 15 nvim --headless -u NONE -i NONE -S spec/fzf_sync_spec.vim
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-palette.XXXXXX)" timeout 10 nvim --headless -u NONE -i NONE -c 'luafile spec/command_palette_check.lua'
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-provider.XXXXXX)" timeout 30 nvim -u NONE -i NONE -n --headless -l spec/python_provider_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-codesettings.XXXXXX)" timeout 30 nvim -u NONE -i NONE -n --headless -l spec/codesettings_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-mason-install.XXXXXX)" timeout 10 nvim -u spec/mason_install_check.lua -i NONE -n --headless --noplugin
	@MASON_INSTALL_CASE=takeover XDG_STATE_HOME="$(mktemp -d /tmp/nvim-mason-install.XXXXXX)" timeout 10 nvim -u spec/mason_install_check.lua -i NONE -n --headless --noplugin
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-which-key.XXXXXX)" timeout 10 nvim -u NONE -i NONE -n --headless -l spec/which_key_timeout_check.lua
	@gitlab_test_home="$(mktemp -d /tmp/nvim-gitlab-browser.XXXXXX)" && \
	  XDG_STATE_HOME="$gitlab_test_home/state" XDG_CACHE_HOME="$gitlab_test_home/cache" \
	  timeout -k 2 10 nvim -u NONE -i NONE -n --headless -l spec/gitlab_browser_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-emmylua.XXXXXX)" timeout 10 nvim -u NONE -i NONE -n --headless -l spec/emmylua_bridge_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-smart-open.XXXXXX)" nvim -u NONE -i NONE -n --headless -l spec/smart_open_sqlite_check.lua
	@diffview_test_home="$(mktemp -d /tmp/nvim-diffview-other.XXXXXX)" && \
	  XDG_STATE_HOME="$diffview_test_home/state" XDG_CACHE_HOME="$diffview_test_home/cache" \
	  timeout -k 2 15 nvim --headless -u NONE -i NONE -n -l spec/diffview_other_check.lua
