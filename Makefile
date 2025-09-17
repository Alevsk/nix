.PHONY: fmt fmt-check check

fmt:
	alejandra .

fmt-check:
	alejandra -c .

check: fmt-check
	nix flake check

