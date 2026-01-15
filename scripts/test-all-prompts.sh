#!/usr/bin/env bash
# Automated Prompt Style Tester
# Tests all prompt styles and captures output for analysis

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$SCRIPT_DIR/tests"
NIX_DIR="$HOME/nix"

# All prompt styles to test
PROMPT_STYLES=(
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

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Ensure test directory exists
mkdir -p "$TEST_DIR"

# Function to run test commands and capture output
test_prompt_style() {
    local style="$1"
    local output_file="$TEST_DIR/${style}.txt"
    local raw_file="$TEST_DIR/${style}_raw.txt"

    echo -e "${CYAN}Testing prompt style: ${YELLOW}$style${NC}"

    # Switch to this prompt style
    echo -e "  ${GREEN}Switching to $style...${NC}"
    "$SCRIPT_DIR/switch-theme-test.sh" nord "$style" > /dev/null 2>&1

    # Wait a moment for the switch to complete
    sleep 1

    echo -e "  ${GREEN}Capturing prompt output...${NC}"

    # Create test commands file
    local test_cmds=$(mktemp)
    cat > "$test_cmds" << 'TESTCMDS'
# Test 1: Basic prompt in home directory
cd ~
echo "=== TEST: Home Directory ==="

# Test 2: Navigate to nix directory (git repo)
cd ~/nix
echo "=== TEST: Git Repository (~/nix) ==="

# Test 3: Show git status to trigger git segment
git status --short 2>/dev/null || true

# Test 4: Successful command
echo "=== TEST: After Successful Command ==="
true

# Test 5: Failed command to test error state
echo "=== TEST: After Failed Command ==="
false || true

# Test 6: Navigate to subdirectory
cd ~/nix/scripts
echo "=== TEST: Subdirectory (~/nix/scripts) ==="

# Test 7: Back to a non-git directory
cd /tmp
echo "=== TEST: Non-Git Directory (/tmp) ==="

# Test 8: Long path test
mkdir -p /tmp/test-prompt/deeply/nested/directory 2>/dev/null || true
cd /tmp/test-prompt/deeply/nested/directory
echo "=== TEST: Deep Directory Path ==="

# Test 9: Back to git repo with changes
cd ~/nix
echo "=== TEST: Back to Git Repo ==="

# Done
echo "=== TESTS COMPLETE ==="
exit 0
TESTCMDS

    # Use script command to capture terminal output including prompts
    # TERM must be set for proper rendering
    export TERM=xterm-256color

    # Capture raw output with script command
    script -q "$raw_file" zsh -i < "$test_cmds" 2>&1 || true

    # Clean up test commands file
    rm -f "$test_cmds"

    # Create cleaned version (strip most control characters but keep structure)
    # Remove carriage returns, escape sequences, but preserve newlines
    if [[ -f "$raw_file" ]]; then
        # Strip ANSI escape codes and control characters for analysis
        sed 's/\x1b\[[0-9;]*[a-zA-Z]//g; s/\x1b\][^\x07]*\x07//g; s/\r//g' "$raw_file" > "$output_file"

        # Also create a version with visible escape codes for debugging
        cat -v "$raw_file" > "$TEST_DIR/${style}_debug.txt"
    fi

    echo -e "  ${GREEN}Saved to: $output_file${NC}"
    echo ""
}

# Function to analyze a single prompt output
analyze_prompt() {
    local style="$1"
    local output_file="$TEST_DIR/${style}.txt"

    if [[ ! -f "$output_file" ]]; then
        echo "  ERROR: Output file not found"
        return 1
    fi

    echo "Analysis for: $style"
    echo "----------------------------------------"

    # Count lines
    local line_count=$(wc -l < "$output_file")
    echo "  Total lines: $line_count"

    # Check for common issues
    # 1. Double spaces (potential spacing issues)
    local double_spaces=$(grep -c '  ' "$output_file" 2>/dev/null || echo "0")
    echo "  Lines with double spaces: $double_spaces"

    # 2. Check for unrendered escape sequences
    local escape_issues=$(grep -c '\[' "$output_file" 2>/dev/null || echo "0")
    echo "  Potential escape sequence artifacts: $escape_issues"

    # 3. Check for consistent prompt character (lambda)
    local lambda_count=$(grep -c 'λ' "$output_file" 2>/dev/null || echo "0")
    echo "  Lambda prompt chars found: $lambda_count"

    # 4. Look for the test markers
    local test_markers=$(grep -c '=== TEST:' "$output_file" 2>/dev/null || echo "0")
    echo "  Test markers found: $test_markers (expected: 9)"

    echo ""
}

# Main execution
main() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}   Automated Prompt Style Tester${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""

    local mode="${1:-test}"

    case "$mode" in
        "test")
            echo -e "${YELLOW}Running tests for all ${#PROMPT_STYLES[@]} prompt styles...${NC}"
            echo ""

            for style in "${PROMPT_STYLES[@]}"; do
                test_prompt_style "$style"
            done

            echo -e "${GREEN}All tests complete!${NC}"
            echo -e "Output files saved to: ${CYAN}$TEST_DIR${NC}"
            ;;

        "analyze")
            echo -e "${YELLOW}Analyzing all prompt outputs...${NC}"
            echo ""

            for style in "${PROMPT_STYLES[@]}"; do
                analyze_prompt "$style"
            done
            ;;

        "single")
            local target_style="${2:-lean}"
            echo -e "${YELLOW}Testing single style: $target_style${NC}"
            test_prompt_style "$target_style"
            analyze_prompt "$target_style"
            ;;

        *)
            echo "Usage: $0 [test|analyze|single <style>]"
            echo "  test    - Run tests for all prompt styles"
            echo "  analyze - Analyze existing test outputs"
            echo "  single  - Test a single style"
            exit 1
            ;;
    esac
}

main "$@"
