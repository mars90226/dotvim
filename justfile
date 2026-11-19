update_plugins:
	@echo 'Update plugins'
	git add lazy-lock.json
	git commit -m 'chore(lazy.nvim): update plugins'

test:
	@busted
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-fzf-sync.XXXXXX)" nvim --headless -u NONE -i NONE -S spec/fzf_sync_spec.vim
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-palette.XXXXXX)" timeout 10 nvim --headless -u NONE -i NONE -c 'luafile spec/command_palette_check.lua'
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-provider.XXXXXX)" timeout 30 nvim -u NONE -i NONE -n --headless -l spec/python_provider_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-codesettings.XXXXXX)" timeout 30 nvim -u NONE -i NONE -n --headless -l spec/codesettings_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-which-key.XXXXXX)" timeout 10 nvim -u NONE -i NONE -n --headless -l spec/which_key_timeout_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-emmylua.XXXXXX)" timeout 10 nvim -u NONE -i NONE -n --headless -l spec/emmylua_bridge_check.lua
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-smart-open.XXXXXX)" nvim -u NONE -i NONE -n --headless -l spec/smart_open_sqlite_check.lua
