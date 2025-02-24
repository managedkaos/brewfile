outdated:
	@echo "Outdated formulas and casks:"
	@brew outdated --greedy --verbose \
		| sort \
		| tr -d '()' \
		| sed -r 's/, +/,/g' \
		| column -t

check-uninstalled:
	./scripts/check-uninstalled.sh

upgrade:
	brew upgrade

casks:
	brew upgrade --cask --greedy

strata:
	brew bundle dump --force
	brew bundle dump --force --file=./Brewfile
	grep -E "^brew" ./Brewfile | sort > ./Brewfile.formulas
	grep -E "^tap"  ./Brewfile | sort > ./Brewfile.taps
	grep -E "^cask" ./Brewfile | sort > ./Brewfile.casks
	grep -E "^vsco" ./Brewfile | sort > ./Brewfile.vscode

backups:
	./scripts/backup_chrome_profiles.sh
	./scripts/backup_bash.sh
	./scripts/backup_node_packages.sh
	./scripts/backup_dotfiles.sh
	./scripts/backup_zoom_chats.sh
	./scripts/mac-backup.sh ./scripts/backup-targets.txt

DOCKER_TARGETS := image container network volume
prune: $(patsubst %,prune-%, $(DOCKER_TARGETS))

prune-%:
	docker $* prune --force

all:
	brew update
	$(MAKE) check-uninstalled
	$(MAKE) outdated
	-$(MAKE) upgrade
	$(MAKE) casks
	$(MAKE) strata
	npm update -g
	tldr --update
	-brew cleanup
	-brew doctor

.PHONY: outdated check-uninstalled upgrade casks strata all

