#!/usr/bin/env bash

# Compare prompt styles between Powerlevel10k and Starship engines
# This script captures actual rendered prompts for comparison

set -e

STYLES=(
    "lean"
    "classic"
    "pure"
    "powerline"
    "developer"
    "unix"
    "minimal"
    "boxed"
    "capsule"
    "slanted"
    "starship"
    "hacker"
    "arrow"
    "soft"
    "rainbow"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/tests/comparison"
mkdir -p "$OUTPUT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           Prompt Style Comparison: P10k vs Starship           ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo

# Function to capture starship prompt for a given style
capture_starship_prompt() {
    local style="$1"
    local output_file="$OUTPUT_DIR/starship_${style}.txt"
    local output_raw="$OUTPUT_DIR/starship_${style}_raw.txt"

    # Switch to starship engine with this style
    "$SCRIPT_DIR/switch-theme-test.sh" nord "$style" starship > /dev/null 2>&1

    # Wait for config to be applied
    sleep 1

    # Capture the starship prompt
    cd ~/nix
    STARSHIP_CONFIG=~/.config/starship.toml starship prompt > "$output_raw" 2>&1

    # Also capture cleaned version (strip ANSI)
    cat "$output_raw" | sed 's/\x1b\[[0-9;]*m//g' > "$output_file"

    echo "$output_file"
}

# Function to capture p10k prompt
capture_p10k_prompt() {
    local style="$1"
    local output_file="$OUTPUT_DIR/p10k_${style}.txt"
    local output_raw="$OUTPUT_DIR/p10k_${style}_raw.txt"

    # Switch to p10k engine with this style
    "$SCRIPT_DIR/switch-theme-test.sh" nord "$style" powerlevel10k > /dev/null 2>&1

    # Wait for config to be applied
    sleep 1

    # Capture p10k prompt by starting a subshell
    # Use script command to capture with pseudo-tty
    cd ~/nix
    script -q "$output_raw" /bin/zsh -i -c 'print -P "$PROMPT"; exit' 2>/dev/null || true

    # Clean the output
    cat "$output_raw" | sed 's/\x1b\[[0-9;]*m//g' | grep -v "^Script" | grep -v "^$" > "$output_file" 2>/dev/null || true

    echo "$output_file"
}

# Test a single style
test_style() {
    local style="$1"
    echo -e "${YELLOW}Testing style: ${style}${NC}"

    # Capture Starship
    echo -n "  Starship: "
    starship_file=$(capture_starship_prompt "$style")
    echo -e "${GREEN}captured${NC}"

    # Capture P10k
    echo -n "  P10k:     "
    p10k_file=$(capture_p10k_prompt "$style")
    echo -e "${GREEN}captured${NC}"

    # Show comparison
    echo -e "  ${BLUE}Starship output:${NC}"
    cat "$OUTPUT_DIR/starship_${style}.txt" | head -5 | sed 's/^/    /'
    echo -e "  ${BLUE}P10k output:${NC}"
    cat "$OUTPUT_DIR/p10k_${style}.txt" | head -5 | sed 's/^/    /'
    echo
}

# If a specific style is provided, test only that one
if [ -n "$1" ]; then
    if [[ " ${STYLES[*]} " =~ " $1 " ]]; then
        test_style "$1"
    else
        echo -e "${RED}Unknown style: $1${NC}"
        echo "Available styles: ${STYLES[*]}"
        exit 1
    fi
else
    # Test all styles
    for style in "${STYLES[@]}"; do
        test_style "$style"
    done
fi

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Comparison complete. Results saved to: $OUTPUT_DIR${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
