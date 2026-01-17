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

PROMPT_ENGINES=(
    "powerlevel10k"
    "starship"
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

# Function to get engine description
get_engine_desc() {
    case "$1" in
        "powerlevel10k") echo "Zsh theme, fast, highly configurable" ;;
        "starship") echo "Cross-shell, Rust-based, minimal config" ;;
        *) echo "Unknown engine" ;;
    esac
}

# Git branch icon
GIT_ICON=$'\uE0A0'

# Function to get visual prompt example
# Returns multi-line string for multi-line prompts
get_prompt_example() {
    local style="$1"
    # Foreground colors
    local P_CYAN='\033[0;36m'
    local P_GREEN='\033[0;32m'
    local P_YELLOW='\033[1;33m'
    local P_BLUE='\033[0;34m'
    local P_MAGENTA='\033[0;35m'
    local P_RED='\033[0;31m'
    local P_WHITE='\033[1;37m'
    local P_GRAY='\033[0;90m'
    local P_ORANGE='\033[38;5;208m'
    local P_NC='\033[0m'

    # Background colors for filled segments
    local BG_BLUE='\033[44m'
    local BG_GREEN='\033[42m'
    local BG_CYAN='\033[46m'
    local BG_MAGENTA='\033[45m'
    local BG_BLACK='\033[40m'
    local FG_BLACK='\033[30m'

    # Combined styles for powerline segments (black text on colored bg)
    local SEG_BLUE='\033[1;30;44m'      # Bold black on blue
    local SEG_GREEN='\033[1;30;42m'     # Bold black on green
    local SEG_CYAN='\033[1;30;46m'      # Bold black on cyan
    local SEG_MAGENTA='\033[1;30;45m'   # Bold black on magenta

    # Foreground only (for arrows)
    local FG_BLUE='\033[34m'
    local FG_GREEN='\033[32m'
    local FG_CYAN='\033[36m'
    local FG_MAGENTA='\033[35m'

    # Powerline characters
    local PL_ARROW=$'\uE0B0'      # Right arrow (transitions/end)
    local PL_LARROW=$'\uE0B2'     # Left arrow (opening cap)
    local PL_ROUND_R=$'\uE0B4'    # Right round (transitions/end)
    local PL_ROUND_L=$'\uE0B6'    # Left round (opening cap)
    local PL_SLANT_R=$'\uE0BC'    # Right slant (transitions/end)
    local PL_SLANT_L=$'\uE0BE'    # Left slant (opening cap)

    case "$style" in
        "minimal")
            # Ultra-minimal: ~ ›
            echo -e "${P_GRAY}~${P_NC} ${P_GRAY}›${P_NC}"
            ;;
        "lean")
            # Single line: nix main ❯
            echo -e "${P_BLUE}nix${P_NC} ${P_MAGENTA}main${P_NC}${P_ORANGE}*${P_NC} ${P_GREEN}❯${P_NC}"
            ;;
        "pure")
            # Two-line Pure style: ~/nix main * (newline) ❯
            echo -e "${P_BLUE}~/nix${P_NC} ${P_GRAY}main${P_NC}${P_YELLOW}*${P_NC}"
            echo -e "${P_MAGENTA}❯${P_NC}"
            ;;
        "classic")
            # Two-line: ~/nix  main (!+?) (newline) ❯
            echo -e "${P_BLUE}~/nix${P_NC} ${P_GREEN}${GIT_ICON} main${P_NC}${P_YELLOW}(!+?)${P_NC}"
            echo -e "${P_MAGENTA}❯${P_NC}"
            ;;
        "powerline")
            # Powerline with filled arrow segments
            echo -e "${FG_BLUE}${PL_LARROW}${SEG_BLUE} ~/nix ${P_NC}${BG_GREEN}${FG_BLUE}${PL_ARROW}${SEG_GREEN} ${GIT_ICON} main ! ${P_NC}${FG_GREEN}${PL_ARROW}${P_NC}"
            echo -e "${P_GREEN}❯${P_NC}"
            ;;
        "capsule")
            # Rounded pill segments with backgrounds
            echo -e "${FG_CYAN}${PL_ROUND_L}${SEG_CYAN} ~/nix ${P_NC}${BG_GREEN}${FG_CYAN}${PL_ROUND_R}${SEG_GREEN} ${GIT_ICON} main ! ${P_NC}${FG_GREEN}${PL_ROUND_R}${P_NC}"
            echo -e "${P_GREEN}❯${P_NC}"
            ;;
        "slanted")
            # Slanted powerline separators with backgrounds
            echo -e "${FG_BLUE}${PL_SLANT_L}${SEG_BLUE} ~/nix ${P_NC}${BG_MAGENTA}${FG_BLUE}${PL_SLANT_R}${SEG_MAGENTA} ${GIT_ICON} main ! ${P_NC}${FG_MAGENTA}${PL_SLANT_R}${P_NC}"
            echo -e "${P_MAGENTA}❯${P_NC}"
            ;;
        "rainbow")
            # Rainbow: spectrum color progression with backgrounds
            echo -e "${FG_MAGENTA}${PL_LARROW}${SEG_MAGENTA} user ${P_NC}${BG_BLUE}${FG_MAGENTA}${PL_ARROW}${SEG_BLUE} nix ${P_NC}${BG_CYAN}${FG_BLUE}${PL_ARROW}${SEG_CYAN} ${GIT_ICON} main ${P_NC}${BG_GREEN}${FG_CYAN}${PL_ARROW}${SEG_GREEN} ! ${P_NC}${FG_GREEN}${PL_ARROW}${P_NC}"
            echo -e "${P_GREEN}❯${P_NC}"
            ;;
        "hacker")
            # Terminal operator: [nix:main*] ▸
            echo -e "${P_GRAY}[${P_NC}${P_CYAN}nix${P_NC}${P_MAGENTA}:main${P_NC}${P_ORANGE}*${P_NC}${P_GRAY}]${P_NC} ${P_CYAN}▸${P_NC}"
            ;;
        "boxed")
            # Elegant box drawing
            echo -e "${P_GRAY}╭─${P_NC} ${P_BLUE}~/nix${P_NC} ${P_GRAY}on${P_NC} ${P_GREEN}${GIT_ICON} main${P_NC}${P_YELLOW}!${P_NC}"
            echo -e "${P_GRAY}╰─${P_NC} ${P_GREEN}❯${P_NC}"
            ;;
        "developer")
            # IDE status bar: dir  main  v22  v1.21 (newline) λ
            echo -e "${P_BLUE}~/nix${P_NC} ${P_MAGENTA}${GIT_ICON} main${P_NC}${P_YELLOW}!${P_NC} ${P_GREEN} v22${P_NC} ${P_CYAN} v1.21${P_NC}"
            echo -e "${P_GREEN}λ${P_NC}"
            ;;
        "unix")
            # Classic PS1: user@host:~/nix (main)$
            echo -e "${P_GREEN}alevsk${P_NC}@${P_CYAN}cloud${P_NC}:${P_BLUE}~/nix${P_NC} ${P_MAGENTA}(main)${P_NC}${P_YELLOW}*${P_NC}${P_GRAY}\$${P_NC}"
            ;;
        "starship")
            # Official Starship look: nix on  main via  v22
            echo -e "${P_CYAN}nix${P_NC} ${P_GRAY}on${P_NC} ${P_MAGENTA}${GIT_ICON} main${P_NC}${P_RED}!${P_NC} ${P_GRAY}via${P_NC} ${P_GREEN} v22${P_NC}"
            echo -e "${P_GREEN}❯${P_NC}"
            ;;
        "soft")
            # Pastel dreams: ● ~/nix  main
            echo -e "${P_MAGENTA}●${P_NC} ${P_MAGENTA}~/nix${P_NC} ${P_GREEN}${GIT_ICON} main${P_NC}${P_YELLOW}~${P_NC}"
            echo -e "${P_MAGENTA}❯${P_NC}"
            ;;
        "arrow")
            # Flow state: user → nix → main →
            echo -e "${P_MAGENTA}alevsk${P_NC} ${P_GRAY}→${P_NC} ${P_BLUE}nix${P_NC} ${P_GRAY}→${P_NC} ${P_GREEN}main${P_NC}${P_YELLOW}*${P_NC} ${P_GREEN}→${P_NC}"
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
    # Match only lines with quoted values (= "value") to avoid _module.args lines
    local current_theme=$(grep 'currentThemeName = "' "$HOME_NIX_FILE" | sed 's/.*= "\([^"]*\)".*/\1/')
    local current_prompt=$(grep 'promptStyle = "' "$HOME_NIX_FILE" | sed 's/.*= "\([^"]*\)".*/\1/')
    local current_engine=$(grep 'promptEngine = "' "$HOME_NIX_FILE" | sed 's/.*= "\([^"]*\)".*/\1/')
    echo -e "${YELLOW}Current Settings:${NC}"
    echo -e "  Theme:  ${GREEN}$current_theme${NC}"
    echo -e "  Prompt: ${GREEN}$current_prompt${NC}"
    echo -e "  Engine: ${GREEN}$current_engine${NC}"
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

# Function to show engine menu
show_engine_menu() {
    echo -e "${BLUE}Available Prompt Engines:${NC}"
    for i in "${!PROMPT_ENGINES[@]}"; do
        local num=$((i + 1))
        printf "  ${PURPLE}%2d)${NC} %-15s %s\n" "$num" "${PROMPT_ENGINES[$i]}" "$(get_engine_desc "${PROMPT_ENGINES[$i]}")"
    done
    echo
}

# Function to update home.nix
update_home_nix() {
    local new_theme="$1"
    local new_prompt="$2"
    local new_engine="$3"

    # Create backup
    cp "$HOME_NIX_FILE" "$HOME_NIX_FILE.backup"

    # Update theme
    sed -i '' "s/currentThemeName = \"[^\"]*\"/currentThemeName = \"$new_theme\"/" "$HOME_NIX_FILE"

    # Update prompt style
    sed -i '' "s/promptStyle = \"[^\"]*\"/promptStyle = \"$new_prompt\"/" "$HOME_NIX_FILE"

    # Update engine
    sed -i '' "s/promptEngine = \"[^\"]*\"/promptEngine = \"$new_engine\"/" "$HOME_NIX_FILE"

    echo -e "${GREEN}✓ Updated configuration:${NC}"
    echo -e "  Theme:  ${CYAN}$new_theme${NC}"
    echo -e "  Prompt: ${CYAN}$new_prompt${NC}"
    echo -e "  Engine: ${CYAN}$new_engine${NC}"
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

    # Engine selection
    show_engine_menu
    while true; do
        read -p "$(echo -e "${YELLOW}Select prompt engine (1-${#PROMPT_ENGINES[@]}): ${NC}")" engine_choice
        if [[ "$engine_choice" =~ ^[0-9]+$ ]] && (( engine_choice >= 1 && engine_choice <= ${#PROMPT_ENGINES[@]} )); then
            selected_engine="${PROMPT_ENGINES[$((engine_choice - 1))]}"
            break
        else
            echo -e "${RED}Invalid choice. Please select 1-${#PROMPT_ENGINES[@]}.${NC}"
        fi
    done

    echo

    # Confirmation
    echo -e "${YELLOW}You selected:${NC}"
    echo -e "  Theme:  ${CYAN}$selected_theme${NC} - $(get_theme_desc "$selected_theme")"
    echo -e "  Prompt: ${CYAN}$selected_prompt${NC} - $(get_prompt_desc "$selected_prompt")"
    echo -e "  Engine: ${CYAN}$selected_engine${NC} - $(get_engine_desc "$selected_engine")"
    echo

    read -p "$(echo -e "${YELLOW}Apply these changes? (y/N): ${NC}")" confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        update_home_nix "$selected_theme" "$selected_prompt" "$selected_engine"
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
