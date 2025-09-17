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
