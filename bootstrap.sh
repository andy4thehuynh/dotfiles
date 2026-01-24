#!/bin/bash

# Dotfiles bootstrap script
# This script sets up a bare git repository for managing dotfiles as described in:
# https://www.atlassian.com/git/tutorials/dotfiles

set -e

REPO_URL="https://github.com/andy4thehuynh/dotfiles.git"
CFG_DIR="$HOME/.cfg"

function config {
   /usr/bin/git --git-dir="$CFG_DIR" --work-tree="$HOME" "$@"
}

# 1. Clone the repository if it doesn't exist
if [ ! -d "$CFG_DIR" ]; then
    echo "Cloning dotfiles bare repository..."
    git clone --bare "$REPO_URL" "$CFG_DIR"
fi

# 2. Checkout the files to $HOME
echo "Checking out dotfiles..."
# Attempt checkout; if it fails, it's likely due to existing files
if ! config checkout; then
    echo "Backing up pre-existing dotfiles to ~/.dotfiles-backup"
    mkdir -p "$HOME/.dotfiles-backup"
    
    # Extract list of files that would be overwritten
    FILES_TO_BACKUP=$(config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}')
    
    for file in $FILES_TO_BACKUP; do
        if [ -e "$HOME/$file" ]; then
            echo "Moving $file to ~/.dotfiles-backup/"
            mkdir -p "$HOME/.dotfiles-backup/$(dirname "$file")"
            mv "$HOME/$file" "$HOME/.dotfiles-backup/$file"
        fi
    done
    
    # Try checking out again
    config checkout
fi

# 3. Configure the repository
echo "Configuring repository..."
config config --local status.showUntrackedFiles no

# 4. Set up the alias in shell configuration
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "alias config=" "$SHELL_CONFIG"; then
        echo "Adding 'config' alias to $SHELL_CONFIG"
        echo "" >> "$SHELL_CONFIG"
        echo "# Dotfiles bare repo alias" >> "$SHELL_CONFIG"
        echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> "$SHELL_CONFIG"
        echo "Successfully added alias. Restart your shell or run 'source $SHELL_CONFIG' to use it."
    fi
else
    echo "Warning: Could not find .zshrc or .bashrc to add alias. Please add it manually:"
    echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'"
fi

# 5. macOS Specific Setup
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected. Running system setup..."
    
    # Install Homebrew if missing
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install from Brewfile if it exists
    if [ -f "$HOME/Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file="$HOME/Brewfile"
    fi
    
    # Run additional macOS setup script if it exists
    if [ -f "$HOME/.system/macos/setup.sh" ]; then
        echo "Running macOS system settings setup..."
        bash "$HOME/.system/macos/setup.sh"
    fi
fi

# 6. VSCode Setup (Symlinking settings)
echo "Setting up VSCode configuration..."
VSCODE_SRC="$HOME/.config/vscode"
if [ -d "$VSCODE_SRC" ]; then
    if [[ "$(uname)" == "Darwin" ]]; then
        VSCODE_DEST="$HOME/Library/Application Support/Code/User"
    elif [[ "$(uname)" == "Linux" ]]; then
        VSCODE_DEST="$HOME/.config/Code/User"
    fi

    if [ -n "$VSCODE_DEST" ]; then
        mkdir -p "$VSCODE_DEST"
        for file in settings.json keybindings.json tasks.json; do
            if [ -f "$VSCODE_SRC/$file" ]; then
                ln -sf "$VSCODE_SRC/$file" "$VSCODE_DEST/$file"
            fi
        done
        echo "VSCode settings symlinked."
    fi
fi

echo "Bootstrap complete!"
