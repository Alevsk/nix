.PHONY: help fmt fmt-check check

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format nix files with alejandra
	alejandra .

fmt-check: ## Check formatting (no changes)
	alejandra -c .

check: fmt-check ## Run fmt-check and nix flake check
	nix flake check

rebuild-system: ## Rebuild Darwin system configuration
	sudo darwin-rebuild switch --flake .#cloud

rebuild-home: ## Rebuild home-manager configuration
	home-manager switch --flake .#alevsk

rebuild-all: ## Rebuild both Darwin system and home-manager
	sudo darwin-rebuild switch --flake .#cloud && home-manager switch --flake .#alevsk

nix-update: ## Update flake inputs
	nix flake update

nix-upgrade: ## Update flake and rebuild everything
	nix flake update && sudo darwin-rebuild switch --flake .#cloud && home-manager switch --flake .#alevsk

nix-gc: ## Garbage collect old generations
	nix-collect-garbage -d
