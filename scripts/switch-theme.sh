#!/usr/bin/env bash

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Available themes and prompt styles
THEMES=(
    "nord"
    "dracula"
    "tokyonight"
    "ocean"
    "catppuccin"
    "gruvbox"
    "gruvbox-light"
    "solarized-dark"
    "solarized-light"
    "onedark"
    "monokai"
    "rose-pine"
    "rose-pine-moon"
    "everforest"
    "kanagawa"
)

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

# Function to get theme description
get_theme_desc() {
    case "$1" in
        "nord") echo "Arctic, north-bluish color palette" ;;
        "dracula") echo "Dark theme with vibrant colors" ;;
        "tokyonight") echo "Dark theme inspired by Tokyo's neon lights" ;;
        "ocean") echo "Deep blue oceanic color scheme" ;;
        "catppuccin") echo "Warm, cozy pastel color palette" ;;
        "gruvbox") echo "Retro groove, warm earthy colors" ;;
        "gruvbox-light") echo "Gruvbox light variant" ;;
        "solarized-dark") echo "Scientific precision, dark variant" ;;
        "solarized-light") echo "Scientific precision, light variant" ;;
        "onedark") echo "Atom's iconic dark theme" ;;
        "monokai") echo "Sublime Text's classic theme" ;;
        "rose-pine") echo "Modern aesthetic, all natural pine" ;;
        "rose-pine-moon") echo "Rose Pine, darker moon variant" ;;
        "everforest") echo "Soft green, comfortable forest theme" ;;
        "kanagawa") echo "Japanese art inspired, wave theme" ;;
        *) echo "Unknown theme" ;;
    esac
}

# Function to get prompt description (short)
get_prompt_desc() {
    case "$1" in
        "lean") echo "Minimal single-line" ;;
        "classic") echo "Clean two-line" ;;
        "pure") echo "Pure-style two-line" ;;
        "powerline") echo "Filled segments" ;;
        "developer") echo "Two-line with langs" ;;
        "unix") echo "Classic UNIX style" ;;
        "minimal") echo "Ultra-minimal" ;;
        "boxed") echo "ASCII box frame" ;;
        "capsule") echo "Rounded capsules" ;;
        "slanted") echo "Slanted segments" ;;
        "starship") echo "Info-rich Starship" ;;
        "hacker") echo "Matrix cyber" ;;
        "arrow") echo "Arrow separator" ;;
        "soft") echo "Soft aesthetic" ;;
        "rainbow") echo "Colorful segments" ;;
        *) echo "Unknown" ;;
    esac
}

# Git branch icon
GIT_ICON=$'\uF126'

# Function to get visual prompt example
# Returns multi-line string for multi-line prompts
get_prompt_example() {
    local style="$1"
    # Using cyan for path, green for git info, yellow for status
    local P_CYAN='\033[0;36m'
    local P_GREEN='\033[0;32m'
    local P_YELLOW='\033[1;33m'
    local P_BLUE='\033[0;34m'
    local P_MAGENTA='\033[0;35m'
    local P_RED='\033[0;31m'
    local P_WHITE='\033[1;37m'
    local P_GRAY='\033[0;90m'
    local P_NC='\033[0m'

    case "$style" in
        "lean")
            # Single line: ~/nix  main ! λ
            echo -e "${P_BLUE}~/nix${P_NC}  ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC} ${P_MAGENTA}λ${P_NC}"
            ;;
        "classic")
            # Two-line: ~/nix  main ! (newline) λ
            echo -e "${P_BLUE}~/nix${P_NC}  ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "pure")
            # Two-line Pure style: ~/nix  main (newline) λ
            echo -e "${P_BLUE}~/nix${P_NC}  ${P_CYAN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "powerline")
            # Powerline with filled segments
            echo -e "${P_BLUE}  ~/nix ${P_NC}${P_GREEN}  ${GIT_ICON} main ! ${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "developer")
            # Developer: dir, git, language versions
            echo -e "${P_BLUE}~/nix${P_NC}  ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC}  ${P_CYAN} 3.11${P_NC}  ${P_GREEN} 20${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "unix")
            # Classic UNIX: user@host dir  branch ! λ
            echo -e "${P_GREEN}alevsk${P_NC}@${P_CYAN}cloud${P_NC} ${P_BLUE}nix${P_NC}  ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC} ${P_MAGENTA}λ${P_NC}"
            ;;
        "minimal")
            # Ultra-minimal: ~ λ
            echo -e "${P_BLUE}~${P_NC} ${P_MAGENTA}λ${P_NC}"
            ;;
        "boxed")
            # ASCII box frame
            echo -e "${P_GRAY}┌─${P_NC} ${P_CYAN}alevsk${P_NC} ${P_GRAY}in${P_NC} ${P_BLUE}~/nix${P_NC} ${P_GRAY}on${P_NC} ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC}"
            echo -e "${P_GRAY}└─${P_NC}${P_MAGENTA}λ${P_NC}"
            ;;
        "capsule")
            # Rounded capsule segments
            echo -e "${P_BLUE}  ~/nix ${P_NC} ${P_GREEN}  ${GIT_ICON} main ! ${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "slanted")
            # Slanted powerline separators
            echo -e "${P_BLUE}◢ ~/nix ${P_NC}${P_GREEN}◢ ${GIT_ICON} main ! ${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "starship")
            # Starship-style info-rich
            echo -e "${P_BLUE}~/nix${P_NC} ${P_GRAY}on${P_NC} ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC} ${P_GRAY}via${P_NC} ${P_CYAN} v3.11${P_NC}"
            echo -e "${P_GREEN}❯${P_NC}"
            ;;
        "hacker")
            # Matrix/cyber hacker style
            echo -e "${P_GREEN}▶${P_NC} ${P_CYAN}nix${P_NC} ${P_GREEN}:: main${P_NC} ${P_YELLOW}!${P_NC} ${P_GREEN}λ${P_NC}"
            ;;
        "arrow")
            # Arrow separators: user@host:dir →  branch ! λ
            echo -e "${P_GREEN}alevsk${P_NC}@${P_CYAN}cloud${P_NC}:${P_BLUE}~/nix${P_NC} → ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC} ${P_MAGENTA}λ${P_NC}"
            ;;
        "soft")
            # Soft aesthetic with diamond
            echo -e "${P_MAGENTA}◆${P_NC} ${P_BLUE}~/nix${P_NC}  ${P_GREEN}${GIT_ICON} main${P_NC} ${P_YELLOW}!${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        "rainbow")
            # Rainbow colored segments
            echo -e "${P_RED} ~ ${P_NC}${P_YELLOW} nix ${P_NC}${P_GREEN} ${GIT_ICON} main ! ${P_NC}"
            echo -e "${P_MAGENTA}λ${P_NC}"
            ;;
        *)
            echo "Unknown prompt style"
            ;;
    esac
}

HOME_NIX_FILE="$HOME/nix/home.nix"

# Function to display header
show_header() {
    echo -e "${CYAN}╭─────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│           🎨 Theme Switcher             │${NC}"
    echo -e "${CYAN}╰─────────────────────────────────────────╯${NC}"
    echo
}

# Function to get current settings
get_current_settings() {
    local current_theme=$(grep 'currentThemeName = ' "$HOME_NIX_FILE" | sed 's/.*= "\([^"]*\)".*/\1/')
    local current_prompt=$(grep 'promptStyle = ' "$HOME_NIX_FILE" | sed 's/.*= "\([^"]*\)".*/\1/')
    echo -e "${YELLOW}Current Settings:${NC}"
    echo -e "  Theme: ${GREEN}$current_theme${NC}"
    echo -e "  Prompt: ${GREEN}$current_prompt${NC}"
    echo
}

# Function to show theme menu
show_theme_menu() {
    echo -e "${BLUE}Available Themes:${NC}"
    for i in "${!THEMES[@]}"; do
        local num=$((i + 1))
        printf "  ${PURPLE}%2d)${NC} %-18s %s\n" "$num" "${THEMES[$i]}" "$(get_theme_desc "${THEMES[$i]}")"
    done
    echo
}

# Function to show prompt style menu with visual examples
show_prompt_menu() {
    echo -e "${BLUE}Available Prompt Styles:${NC}"
    echo
    for i in "${!PROMPT_STYLES[@]}"; do
        local num=$((i + 1))
        local style="${PROMPT_STYLES[$i]}"
        local desc="$(get_prompt_desc "$style")"

        # Print style header
        printf "  ${PURPLE}%2d)${NC} ${CYAN}%-12s${NC} ${YELLOW}%s${NC}\n" "$num" "$style" "$desc"

        # Print visual example in a box
        echo -e "      ${PURPLE}┌──────────────────────────────────────────────────────${NC}"

        # Get the example and indent each line
        while IFS= read -r line; do
            echo -e "      ${PURPLE}│${NC} $line"
        done <<< "$(get_prompt_example "$style")"

        echo -e "      ${PURPLE}└──────────────────────────────────────────────────────${NC}"
        echo
    done
}

# Function to update home.nix
update_home_nix() {
    local new_theme="$1"
    local new_prompt="$2"

    # Create backup
    cp "$HOME_NIX_FILE" "$HOME_NIX_FILE.backup"

    # Update theme
    sed -i '' "s/currentThemeName = \"[^\"]*\"/currentThemeName = \"$new_theme\"/" "$HOME_NIX_FILE"

    # Update prompt style
    sed -i '' "s/promptStyle = \"[^\"]*\"/promptStyle = \"$new_prompt\"/" "$HOME_NIX_FILE"

    echo -e "${GREEN}✓ Updated configuration:${NC}"
    echo -e "  Theme: ${CYAN}$new_theme${NC}"
    echo -e "  Prompt: ${CYAN}$new_prompt${NC}"
    echo
}

# Function to rebuild home manager
rebuild_home() {
    echo -e "${YELLOW}🔄 Rebuilding Home Manager configuration...${NC}"
    echo

    if home-manager switch --flake ~/nix#alevsk; then
        echo
        echo -e "${GREEN}✅ Theme switch completed successfully!${NC}"
        echo
        echo -e "${YELLOW}⚠️  IMPORTANT: Open a NEW terminal window to see the changes.${NC}"
        echo -e "${YELLOW}   Existing shells will not reflect the new theme.${NC}"
    else
        echo
        echo -e "${RED}❌ Failed to rebuild configuration. Restoring backup...${NC}"
        mv "$HOME_NIX_FILE.backup" "$HOME_NIX_FILE"
        exit 1
    fi
}

# Main script
main() {
    show_header
    get_current_settings

    # Theme selection
    show_theme_menu
    while true; do
        read -p "$(echo -e "${YELLOW}Select theme (1-${#THEMES[@]}): ${NC}")" theme_choice
        if [[ "$theme_choice" =~ ^[0-9]+$ ]] && (( theme_choice >= 1 && theme_choice <= ${#THEMES[@]} )); then
            selected_theme="${THEMES[$((theme_choice - 1))]}"
            break
        else
            echo -e "${RED}Invalid choice. Please select 1-${#THEMES[@]}.${NC}"
        fi
    done

    echo

    # Prompt style selection
    show_prompt_menu
    while true; do
        read -p "$(echo -e "${YELLOW}Select prompt style (1-${#PROMPT_STYLES[@]}): ${NC}")" prompt_choice
        if [[ "$prompt_choice" =~ ^[0-9]+$ ]] && (( prompt_choice >= 1 && prompt_choice <= ${#PROMPT_STYLES[@]} )); then
            selected_prompt="${PROMPT_STYLES[$((prompt_choice - 1))]}"
            break
        else
            echo -e "${RED}Invalid choice. Please select 1-${#PROMPT_STYLES[@]}.${NC}"
        fi
    done

    echo

    # Confirmation
    echo -e "${YELLOW}You selected:${NC}"
    echo -e "  Theme: ${CYAN}$selected_theme${NC} - $(get_theme_desc "$selected_theme")"
    echo -e "  Prompt: ${CYAN}$selected_prompt${NC} - $(get_prompt_desc "$selected_prompt")"
    echo

    read -p "$(echo -e "${YELLOW}Apply these changes? (y/N): ${NC}")" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        update_home_nix "$selected_theme" "$selected_prompt"
        rebuild_home
    else
        echo -e "${YELLOW}Theme switch cancelled.${NC}"
        exit 0
    fi
}

# Check if home.nix exists
if [[ ! -f "$HOME_NIX_FILE" ]]; then
    echo -e "${RED}Error: $HOME_NIX_FILE not found!${NC}"
    exit 1
fi

main "$@"
