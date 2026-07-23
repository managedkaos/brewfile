help: ## Display this help message
	@grep -E '^[a-zA-Z0-9_%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

outdated: ## List outdated Homebrew formulas and casks
	@echo "Outdated formulas and casks:"
	@brew outdated --greedy --verbose \
		| sort \
		| tr -d '()' \
		| sed -r 's/, +/,/g' \
		| column -t

check-uninstalled: ## Check Brewfile entries against uninstalled casks
	./scripts/check-uninstalled.sh

update: ## Update Homebrew package metadata
	-brew update --yes

upgrade: ## Upgrade installed Homebrew formulas
	-brew upgrade --yes

casks: ## Upgrade installed Homebrew casks
	-brew upgrade --cask --greedy --yes

strata: ## Regenerate Brewfile category snapshots
	brew bundle dump --force
	brew bundle dump --force --file=./Brewfile
	grep -E "^brew" ./Brewfile | sort > ./Brewfile.formulas
	grep -E "^tap"  ./Brewfile | sort > ./Brewfile.taps
	grep -E "^cask" ./Brewfile | sort > ./Brewfile.casks
	grep -E "^vsco" ./Brewfile | sort > ./Brewfile.vscode

backups: ## Back up local profiles, packages, dotfiles, chats, and files
	time (./scripts/backup_chrome_profiles.sh && \
	./scripts/backup_node_packages.sh && \
	./scripts/backup_dotfiles.sh && \
	./scripts/backup_zoom_chats.sh && \
	./scripts/mac-backup.sh ./scripts/backup-targets.txt)
	#./scripts/backup_bash.sh && \

npm: ## Update global npm packages
	/opt/homebrew/bin/npm update -g

DOCKER_TARGETS := image container network volume
prune: $(patsubst %,prune-%, $(DOCKER_TARGETS)) ## Prune unused Docker images, containers, networks, and volumes

prune-%: ## Prune unused Docker resources by type
	docker $* prune --force

nocask: update upgrade ## Update Homebrew and upgrade formulas without casks

all: update check-uninstalled outdated upgrade casks strata ## Run full Homebrew maintenance
	brew link --overwrite node
	tldr --update
	-brew cleanup
	-brew doctor

.PHONY: outdated check-uninstalled upgrade casks strata all
