update_plugins:
	@echo 'Update plugins'
	git add lazy-lock.json
	git commit -m 'chore(lazy.nvim): update plugins'

test:
	@busted
	@XDG_STATE_HOME="$(mktemp -d /tmp/nvim-fzf-sync.XXXXXX)" nvim --headless -u NONE -i NONE -S spec/fzf_sync_spec.vim
