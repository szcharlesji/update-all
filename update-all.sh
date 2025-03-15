#!/bin/bash

VERSION="1.0.0"

# ASCII Art
LOGO="
 _   _           _       _              _    _ _ 
| | | |_ __   __| | __ _| |_ ___       / \  | | |
| | | | '_ \ / _\` |/ _\` | __/ _ \     / _ \ | | |
| |_| | |_) | (_| | (_| | ||  __/    / ___ \| | |
 \___/| .__/ \__,_|\__,_|\__\___|   /_/   \_\_|_|
      |_|                                        
"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default options
SILENT_MODE=false
SHOW_HELP=false
SHOW_VERSION=false
DRY_RUN=false

# Function to display help
show_help() {
    echo -e "${CYAN}$LOGO${NC}"
    echo -e "${GREEN}Update All - A comprehensive system update tool${NC}"
    echo -e "${YELLOW}Version: $VERSION${NC}"
    echo ""
    echo "Usage: update-all [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -v, --version   Show version information and exit"
    echo "  -s, --silent    Run in silent mode (suppress output, good for background tasks)"
    echo "  -d, --dry-run   Show what would be updated without making changes"
    echo "  -l, --list      List all configured update tasks"
    echo ""
    echo "Configuration:"
    echo "  ~/.update-all.conf  Edit this file to customize which package managers to update"
    echo ""
    echo "Examples:"
    echo "  update-all           # Run all updates with output"
    echo "  update-all --silent  # Run updates silently"
    echo "  update-all --list    # List all configured update tasks"
    echo "  ua                   # Short alias for update-all"
    echo ""
}

# Function to display version
show_version() {
    echo "update-all version $VERSION"
}

# Function to handle errors
handle_error() {
    if [[ "$SILENT_MODE" == "false" ]]; then
        echo -e "${RED}Error: $1 failed with exit code $2${NC}"
    fi
}

# Function to print messages (respects silent mode)
print_msg() {
    if [[ "$SILENT_MODE" == "false" ]]; then
        echo -e "$1"
    fi
}

# Function to print section headers
print_section() {
    if [[ "$SILENT_MODE" == "false" ]]; then
        echo -e "\n${BLUE}=== $1 ===${NC}"
    fi
}

# Function to run a command or simulate in dry-run mode
run_command() {
    local cmd="$1"
    local name="$2"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_msg "${YELLOW}Would run: $cmd${NC}"
        return 0
    else
        if [[ "$SILENT_MODE" == "true" ]]; then
            eval "$cmd" >/dev/null 2>&1 || handle_error "$name" $?
        else
            eval "$cmd" || handle_error "$name" $?
        fi
    fi
}

# Function to list configured tasks
list_tasks() {
    echo -e "${CYAN}$LOGO${NC}"
    echo -e "${GREEN}Configured Update Tasks:${NC}"
    echo ""
    
    # Source configuration file to get current settings
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
    
    # List standard tasks
    echo -e "${YELLOW}Standard Tasks:${NC}"
    [[ "$UPDATE_HOMEBREW" == "true" ]] && echo -e "${GREEN}✓${NC} Homebrew" || echo -e "${RED}✗${NC} Homebrew (disabled)"
    [[ "$UPDATE_NEOVIM_PLUGINS" == "true" ]] && echo -e "${GREEN}✓${NC} Neovim Plugins" || echo -e "${RED}✗${NC} Neovim Plugins (disabled)"
    [[ "$UPDATE_NEOVIM_MASON" == "true" ]] && echo -e "${GREEN}✓${NC} Neovim Mason" || echo -e "${RED}✗${NC} Neovim Mason (disabled)"
    [[ "$UPDATE_CARGO" == "true" ]] && echo -e "${GREEN}✓${NC} Cargo" || echo -e "${RED}✗${NC} Cargo (disabled)"
    [[ "$UPDATE_BUN" == "true" ]] && echo -e "${GREEN}✓${NC} Bun" || echo -e "${RED}✗${NC} Bun (disabled)"
    [[ "$UPDATE_NPM" == "true" ]] && echo -e "${GREEN}✓${NC} NPM" || echo -e "${RED}✗${NC} NPM (disabled)"
    [[ "$UPDATE_RUBY" == "true" ]] && echo -e "${GREEN}✓${NC} Ruby Gems" || echo -e "${RED}✗${NC} Ruby Gems (disabled)"
    
    # List custom commands
    if [[ ${#CUSTOM_COMMANDS[@]} -gt 0 ]]; then
        echo -e "\n${YELLOW}Custom Commands:${NC}"
        for cmd in "${CUSTOM_COMMANDS[@]}"; do
            echo -e "${GREEN}✓${NC} $cmd"
        done
    fi
    
    echo -e "\nEdit ${CYAN}~/.update-all.conf${NC} to customize these settings."
    exit 0
}

# Handle CTRL+C gracefully
cleanup() {
    print_msg "\n${YELLOW}Update process interrupted. Exiting...${NC}"
    exit 1
}

# Set up trap for CTRL+C
trap cleanup INT

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            SHOW_HELP=true
            shift
            ;;
        -v|--version)
            SHOW_VERSION=true
            shift
            ;;
        -s|--silent)
            SILENT_MODE=true
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -l|--list)
            CONFIG_FILE="$HOME/.update-all.conf"
            list_tasks
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help to see available options."
            exit 1
            ;;
    esac
done

# Show help and exit if requested
if [[ "$SHOW_HELP" == "true" ]]; then
    show_help
    exit 0
fi

# Show version and exit if requested
if [[ "$SHOW_VERSION" == "true" ]]; then
    show_version
    exit 0
fi

# Default configuration
UPDATE_HOMEBREW=true
UPDATE_NEOVIM_PLUGINS=true
UPDATE_NEOVIM_MASON=true
UPDATE_CARGO=true
UPDATE_BUN=true
UPDATE_NPM=true
UPDATE_RUBY=true
CUSTOM_COMMANDS=()

# Create default config if it doesn't exist
CONFIG_FILE="$HOME/.update-all.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
    print_msg "${YELLOW}Creating default configuration at $CONFIG_FILE${NC}"
    echo "# Configuration file for update-all" > "$CONFIG_FILE"
    echo "# Set to false to disable updating specific package managers" >> "$CONFIG_FILE"
    echo "UPDATE_HOMEBREW=true" >> "$CONFIG_FILE"
    echo "UPDATE_NEOVIM_PLUGINS=true" >> "$CONFIG_FILE"
    echo "UPDATE_NEOVIM_MASON=true" >> "$CONFIG_FILE"
    echo "UPDATE_CARGO=true" >> "$CONFIG_FILE"
    echo "UPDATE_BUN=true" >> "$CONFIG_FILE"
    echo "UPDATE_NPM=true" >> "$CONFIG_FILE"
    echo "UPDATE_RUBY=true" >> "$CONFIG_FILE"
    echo "" >> "$CONFIG_FILE"
    echo "# Add custom update commands (one per line)" >> "$CONFIG_FILE"
    echo "# CUSTOM_COMMANDS+=(\"echo 'Hello, World!'\")" >> "$CONFIG_FILE"
fi

# Source configuration file
source "$CONFIG_FILE"

# Display header
if [[ "$SILENT_MODE" == "false" ]]; then
    echo -e "${CYAN}$LOGO${NC}"
    echo -e "${GREEN}Update All - Version $VERSION${NC}"
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}[DRY RUN MODE - No changes will be made]${NC}"
    fi
    echo -e "${BLUE}Starting updates at $(date)${NC}"
    echo ""
fi

# Update Homebrew
if [[ "$UPDATE_HOMEBREW" == "true" ]]; then
    print_section "Updating Homebrew"
    run_command "brew update" "brew update"
    run_command "brew upgrade --greedy" "brew upgrade"
    run_command "brew cleanup" "brew cleanup"
fi

# Update Neovim plugins
if [[ "$UPDATE_NEOVIM_PLUGINS" == "true" ]]; then
    print_section "Updating Neovim plugins"
    run_command "nvim --headless \"+Lazy! sync\" +qa" "nvim plugin update"
fi

# Update Mason packages in Neovim
if [[ "$UPDATE_NEOVIM_MASON" == "true" ]]; then
    print_section "Updating Mason packages"
    run_command "nvim --headless \"+MasonUpdate\" +qa" "mason update"
fi

# Update Cargo packages
if [[ "$UPDATE_CARGO" == "true" ]]; then
    print_section "Updating Cargo packages"
    run_command "cargo install-update -a" "cargo update"
fi

# Update Bun packages
if [[ "$UPDATE_BUN" == "true" ]]; then
    print_section "Updating Bun"
    run_command "bun upgrade" "bun upgrade"
    run_command "bun update -g --latest" "bun global update"
fi

# Update NPM packages
if [[ "$UPDATE_NPM" == "true" ]]; then
    print_section "Updating NPM and global packages"
    run_command "npm install npm -g" "npm update"
    run_command "npm update -g" "npm global update"
fi

# Update Ruby gems
if [[ "$UPDATE_RUBY" == "true" ]]; then
    print_section "Updating Ruby gems"
    run_command "sudo gem update --system" "gem system update"
    run_command "sudo gem update" "gem update"
fi

# Run custom commands
if [[ ${#CUSTOM_COMMANDS[@]} -gt 0 ]]; then
    print_section "Running custom commands"
    for cmd in "${CUSTOM_COMMANDS[@]}"; do
        print_msg "${CYAN}Executing: $cmd${NC}"
        run_command "$cmd" "custom command: $cmd"
    done
fi

if [[ "$DRY_RUN" == "true" ]]; then
    print_msg "\n${YELLOW}Dry run completed. No changes were made.${NC}"
else
    print_msg "\n${GREEN}All updates completed successfully!${NC}"
fi

print_msg "${BLUE}Finished at $(date)${NC}"
