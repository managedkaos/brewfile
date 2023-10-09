check-uninstalled:
	./scripts/check-uninstalled.sh

upgradecasks:
	./scripts/brew-cask-upgrade.sh

strata:
	grep -E "^brew" ./Brewfile | sort > ./Brewfile.formulas
	grep -E "^tap"  ./Brewfile | sort > ./Brewfile.taps
	grep -E "^cask" ./Brewfile | sort > ./Brewfile.casks
	grep -E "^vsco" ./Brewfile | sort > ./Brewfile.vscode
