# Brewfile

This repository tracks Homebrew-managed packages and related local maintenance
tasks for a macOS workstation. The `Brewfile` is the primary package inventory,
with generated snapshot files for formulas, taps, casks, and VS Code extensions.

The `Makefile` provides shortcuts for routine Homebrew updates, package checks,
Docker cleanup, and local backup scripts.

## Files

- `Brewfile`: Homebrew bundle definition.
- `Brewfile.formulas`: Sorted formula entries generated from `Brewfile`.
- `Brewfile.taps`: Sorted tap entries generated from `Brewfile`.
- `Brewfile.casks`: Sorted cask entries generated from `Brewfile`.
- `Brewfile.vscode`: Sorted VS Code extension entries generated from `Brewfile`.
- `uninstalled-casks.md`: Casks intentionally tracked as uninstalled.
- `scripts/`: Helper scripts used by Make targets.

## Usage

Run `make help` to list available targets.

```sh
make help
```

Run the full Homebrew maintenance workflow with:

```sh
make all
```

## Make Targets

| Target | Description |
| --- | --- |
| `help` | Display this help message |
| `outdated` | List outdated Homebrew formulas and casks |
| `check-uninstalled` | Check Brewfile entries against uninstalled casks |
| `update` | Update Homebrew package metadata |
| `upgrade` | Upgrade installed Homebrew formulas |
| `casks` | Upgrade installed Homebrew casks |
| `strata` | Regenerate Brewfile category snapshots |
| `backups` | Back up local profiles, packages, dotfiles, chats, and files |
| `npm` | Update global npm packages |
| `prune` | Prune unused Docker images, containers, networks, and volumes |
| `prune-%` | Prune unused Docker resources by type |
| `nocask` | Update Homebrew and upgrade formulas without casks |
| `all` | Run full Homebrew maintenance |
