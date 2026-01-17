#!/bin/bash
# Test a specific prompt style
STYLE=$1
ENGINE=$2
OUTPUT_DIR=~/nix/scripts/tests/comparison/${ENGINE}_engine

mkdir -p "$OUTPUT_DIR"

# Update home.nix
sed -i '' "s/promptStyle = \"[^\"]*\"/promptStyle = \"$STYLE\"/" ~/nix/home.nix
sed -i '' "s/promptEngine = \"[^\"]*\"/promptEngine = \"$ENGINE\"/" ~/nix/home.nix

# Rebuild
home-manager switch --flake ~/nix#alevsk 2>&1 | tail -1

# Show what the prompt looks like
echo "=== $STYLE with $ENGINE ==="
cd ~/nix && /Users/alevsk/.nix-profile/bin/starship prompt 2>/dev/null | cat -v
echo ""
