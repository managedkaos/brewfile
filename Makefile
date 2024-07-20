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
	#./scripts/brew-cask-upgrade.sh

strata:
	brew bundle dump --force --file=./Brewfile
	grep -E "^brew" ./Brewfile | sort > ./Brewfile.formulas
	grep -E "^tap"  ./Brewfile | sort > ./Brewfile.taps
	grep -E "^cask" ./Brewfile | sort > ./Brewfile.casks
	grep -E "^vsco" ./Brewfile | sort > ./Brewfile.vscode

all:
	brew update
	$(MAKE) check-uninstalled
	$(MAKE) outdated
	$(MAKE) upgrade
	$(MAKE) casks
	-brew cleanup
	-brew doctor
	$(MAKE) strata
	npm update -g
	tldr --update
	./scripts/backup_chrome_profiles.sh
	./scripts/backup_bash.sh
	./scripts/backup_node_packages.sh
	./scripts/backup_dotfiles.sh
