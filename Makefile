.PHONY: bootstrap install backup hooks help
.DEFAULT_GOAL := backup

bootstrap: ## One-shot bootstrap on a fresh macOS machine (Homebrew + brews + dotfiles)
	bash bootstrap.sh

install: ## Apply dotfiles from this repo to $HOME
	bash tools/install.sh

backup: ## Capture current $HOME config and Brewfile back into this repo
	bash tools/backup.sh

hooks: ## Install git hooks (pre-commit secret scanner) into .git/hooks
	ln -sfn ../../tools/pre-commit.sh .git/hooks/pre-commit
	@echo "  [ OK ] pre-commit hook installed"

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
