SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

DATE 		:= $(shell date +"%a %b %d %T %Y")
UNAME_S 	:= $(shell uname -s | tr A-Z a-z)
HOSTNAME := $(shell hostname)

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[/.a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: system
system: ## Build system
	nixos-rebuild --use-remote-sudo switch --flake .

.PHONY: system-install-bootloader
system-install-bootloader: ## Build system && allow downgrading bootloader
	sudo nixos-rebuild --install-bootloader switch --flake .

.PHONY: home
home: ## Build home-manager configuration for the current system
	# --impure is for $NIXPKGS_ALLOW_UNFREE env var..for some reason nix config not overriding anymore
	home-manager switch --impure --flake .#${HOSTNAME}

.PHONY: update
update: ## Update all flakes
	nix flake update
	#nix flake update nixpkgs

.PHONY: bocana
bocana: ## Deploy bocana
	deploy '.#bocana'

.PHONY: diff
diff: ## Show latest commit history available to pull (make sure nixpkgs is up to date)
	@current=$(shell nixos-version --json | jq -r .nixpkgsRevision)
	@latest=$(shell curl --silent https://channels.nix.gsc.io/nixos-unstable/latest | cut -f1 -d" ")
	@pushd $$PROJECTS/nixpkgs > /dev/null
	@git log --oneline --ancestry-path $$current..$$latest | grep -v "Merge pull request" | less
	@popd > /dev/null
