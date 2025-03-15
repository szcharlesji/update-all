#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error: $1 failed with exit code $2"
}

# Update Homebrew
echo "Updating Homebrew..."
brew update || handle_error "brew update" $?
brew upgrade --greedy || handle_error "brew upgrade" $?
brew cleanup || handle_error "brew cleanup" $?

# Update Neovim plugins
echo "Updating Neovim plugins..."
nvim --headless "+Lazy! sync" +qa || handle_error "nvim plugin update" $?

# Update Mason packages in Neovim
echo "Updating Mason packages..."
nvim --headless "+MasonUpdate" +qa || handle_error "mason update" $?

# Update Cargo packages
echo "Updating Cargo packages..."
cargo install-update -a || handle_error "cargo update" $?

# Update Bun packages
echo "Updating Bun..."
bun upgrade || handle_error "bun upgrade" $?
bun update -g --latest || handle_error "bun global update" $?

# Update NPM and global packages
echo "Updating NPM and global packages..."
npm install npm -g || handle_error "npm update" $?
npm update -g --latest || handle_error "npm global update" $?

# Update Ruby gems
echo "Updating Ruby gems..."
sudo gem update --system || handle_error "gem system update" $?
sudo gem update || handle_error "gem update" $?

echo "==================================="
echo "All updates completed successfully!"
