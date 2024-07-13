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
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: system-install-bootloader
system-install-bootloader: ## Build system && allow downgrading bootloader
	sudo nixos-rebuild --install-bootloader switch --flake .

.PHONY: update
update: ## Update all flakes
	nix flake update

.PHONY: home-test
home-test: ## Build home-manager configuration for the current system using a local version of home-manager
	home-manager --override-input home-manager ~/Projects/home-manager switch --show-trace --flake .#${HOSTNAME}

##@ Deploy host
.PHONY: bocana
bocana: ## Deploy bocana
	deploy '.#bocana'


##@ Common

.PHONY: home
home: ## Build home-manager configuration for the current system
	home-manager switch --show-trace --flake .#${HOSTNAME}

.PHONY: system
system: ## Build system
	nixos-rebuild --use-remote-sudo switch --flake .
