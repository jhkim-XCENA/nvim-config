#!/bin/bash

# Color Variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Neovim Configuration Setup ===${NC}"

# 1. Dependency Check and Installation
REQUIRED_PACKAGES=""

# Check for Neovim (using the ppa version is often best for latest features)
if ! command -v nvim &> /dev/null; then
    REQUIRED_PACKAGES+="neovim "
fi

# Check for Git (essential for Packer)
if ! command -v git &> /dev/null; then
    REQUIRED_PACKAGES+="git "
fi

# Check for clangd
if ! command -v clangd &> /dev/null; then
    REQUIRED_PACKAGES+="clangd"
fi

# dynamically check the permissions
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
    SUDO="sudo"
fi



if [ -n "$REQUIRED_PACKAGES" ]; then
    echo -e "${YELLOW}The following essential packages are missing: ${REQUIRED_PACKAGES}${NC}"
    read -r -p "Do you agree to install these packages using '$SUDO apt install'? (y/N) " response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${BLUE}Installing dependencies...${NC}"

        # Try adding Neovim PPA first for the latest stable version
        if [[ "$REQUIRED_PACKAGES" =~ "neovim" ]]; then
            echo "Attempting to add Neovim PPA..."
            if ! $SUDO add-apt-repository -y ppa:neovim-ppa/unstable &> /dev/null; then
                echo -e "${RED}Warning: Could not add Neovim PPA. Installing potentially older version from main repos.${NC}"
            else
                $SUDO apt update
            fi
        fi

        # Install all required packages
        if $SUDO apt install -y $REQUIRED_PACKAGES; then
            echo -e "${GREEN}Dependencies installed successfully!${NC}"
        else
            echo -e "${RED}Error: Failed to install required packages. Please install them manually and try again.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Installation aborted by user due to missing dependencies.${NC}"
        exit 1
    fi
fi

# 2. Define paths
CONFIG_DIR="$HOME/.config/nvim"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 3. Backup and link existing Neovim configuration
if [ -d "$CONFIG_DIR" ]; then
    # Skip if it's already a symbolic link
    if [ -L "$CONFIG_DIR" ]; then
        echo "Configuration is already linked."
    else
        echo "Backing up existing configuration: ${CONFIG_DIR}.backup"
        mv "$CONFIG_DIR" "${CONFIG_DIR}.backup_$(date +%Y%m%d_%H%M%S)"
        echo "Linking configuration files..."
        mkdir -p "$HOME/.config"
        ln -sf "$SCRIPT_DIR" "$CONFIG_DIR"
    fi
else
    echo "Linking configuration files..."
    mkdir -p "$HOME/.config"
    ln -sf "$SCRIPT_DIR" "$CONFIG_DIR"
fi

# 4. Replace vi/vim commands with nvim (Alias Setup)
setup_alias() {
    local shell_rc="$1"
    local shell_name="$2"
    local alias_config="# --- Added by nvim-config install script ---
alias vi='nvim'
alias vim='nvim'
# -------------------------------------------"

    if [ -f "$shell_rc" ]; then
        # Check if the alias already exists to prevent duplication
        if grep -q "alias vi='nvim'" "$shell_rc"; then
            echo -e "${YELLOW}[Skip] Alias already exists in $shell_name configuration file.${NC}"
        else
            echo "-> Adding aliases to $shell_name configuration file ($shell_rc)..."
            echo "" >> "$shell_rc"
            echo "$alias_config" >> "$shell_rc"
            echo -e "${GREEN}[OK] $shell_name configuration complete!${NC}"
        fi
    fi
}

# Check and add Alias to bashrc and zshrc
setup_alias "$HOME/.bashrc" "Bash"
# setup_alias "$HOME/.zshrc" "Zsh"

echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo "Run 'nvim' to automatically install plugins."
echo -e "${YELLOW}To apply the changes immediately, restart your terminal or run:${NC}"
echo "source ~/.bashrc  (or source ~/.zshrc)"
