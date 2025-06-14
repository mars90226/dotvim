update_plugins:
	@echo 'Update plugins'
	git add lazy-lock.json
	git commit -m 'chore(lazy.nvim): update plugins'

test:
	@busted
