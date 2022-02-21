SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
HOSTNAME := $(hostname)

DATE 		:= $(shell date +"%a %b %d %T %Y")
UNAME_S 	:= $(shell uname -s | tr A-Z a-z)
HOSTNAME := $(shell hostname)

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[/.a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: system
system: ## Build system
	nixos-rebuild-pretty switch

.PHONY: home
home: ## Build home-manager
	hm-$(HOSTNAME)

.PHONY: update
update: ## Update nixpkgs
	niv update nixpkgs && touch .envrc

.PHONY:
vnet: ## Push configs to machines on home network
	@ops/home/push

.PHONY:
diff: ## Show latest commit history available to pull (make sure nixpkgs is up to date)
	@current=$(shell nixos-version --json | jq -r .nixpkgsRevision)
	@latest=$(shell curl --silent https://channels.nix.gsc.io/nixos-unstable/latest | cut -f1 -d" ")
	@pushd $$PROJECTS/nixpkgs > /dev/null
	@git log --oneline --ancestry-path $$current..$$latest | grep -v "Merge pull request" | less
	@popd > /dev/null
