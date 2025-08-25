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
THEMES=("nord" "dracula" "tokyonight" "ocean" "default")
PROMPT_STYLES=("lean" "classic" "rainbow")

# Function to get theme description
get_theme_desc() {
    case "$1" in
        "nord") echo "Nord - Arctic, north-bluish color palette" ;;
        "dracula") echo "Dracula - Dark theme with vibrant colors" ;;
        "tokyonight") echo "Tokyo Night - Dark theme inspired by Tokyo's neon lights" ;;
        "ocean") echo "Ocean - Deep blue oceanic color scheme" ;;
        "default") echo "Catppuccin Mocha - Warm, cozy color palette" ;;
        *) echo "Unknown theme" ;;
    esac
}

# Function to get prompt description
get_prompt_desc() {
    case "$1" in
        "lean") echo "Lean - Minimal single line with essential info" ;;
        "classic") echo "Classic - Multi-line with decorations and full info" ;;
        "rainbow") echo "Rainbow - Colorful with many elements and system info" ;;
        *) echo "Unknown prompt style" ;;
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
        echo -e "  ${PURPLE}$num)${NC} ${THEMES[$i]} - $(get_theme_desc "${THEMES[$i]}")"
    done
    echo
}

# Function to show prompt style menu
show_prompt_menu() {
    echo -e "${BLUE}Available Prompt Styles:${NC}"
    for i in "${!PROMPT_STYLES[@]}"; do
        local num=$((i + 1))
        echo -e "  ${PURPLE}$num)${NC} ${PROMPT_STYLES[$i]} - $(get_prompt_desc "${PROMPT_STYLES[$i]}")"
    done
    echo
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
        echo -e "${YELLOW}Please restart your terminal or source your shell to see changes.${NC}"
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
        if [[ "$theme_choice" =~ ^[1-${#THEMES[@]}]$ ]]; then
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
        if [[ "$prompt_choice" =~ ^[1-${#PROMPT_STYLES[@]}]$ ]]; then
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
