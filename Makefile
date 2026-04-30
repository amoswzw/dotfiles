.PHONY: bootstrap install backup help
.DEFAULT_GOAL := backup

bootstrap: ## One-shot bootstrap on a fresh macOS machine (Homebrew + brews + dotfiles)
	bash bootstrap.sh

install: ## Apply dotfiles from this repo to $HOME
	bash tools/install.sh

backup: ## Capture current $HOME config and Brewfile back into this repo
	bash tools/backup.sh

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
