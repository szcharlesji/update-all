# Update All

A comprehensive system update tool that keeps all your package managers and tools up to date with a single command.

```
 _   _           _       _              _    _ _
| | | |_ __   __| | __ _| |_ ___       / \  | | |
| | | | '_ \ / _` |/ _` | __/ _ \     / _ \ | | |
| |_| | |_) | (_| | (_| | ||  __/    / ___ \| | |
 \___/| .__/ \__,_|\__,_|\__\___|   /_/   \_\_|_|
      |_|
```

## Features

- **One Command**: Update all your package managers and tools with a single command
- **Configurable**: Easily enable/disable specific update tasks
- **Custom Commands**: Add your own update commands
- **Silent Mode**: Run updates in the background without output
- **Dry Run**: Preview what would be updated without making changes
- **Error Handling**: Graceful error handling and reporting
- **Colorful Output**: Clear, colorful terminal output

## Supported Package Managers

- Homebrew
- Neovim (Lazy plugin manager)
- Neovim Mason
- Cargo (Rust)
- Bun
- NPM
- Ruby Gems
- Custom commands (add your own!)

## Installation

### Using Homebrew

```bash
# Install
brew tap szcharlesji/formulae
brew install update-all

# Update
brew upgrade update-all
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/szcharlesji/update-all.git
cd update-all

# Make the script executable
chmod +x update-all.sh

# Optional: Create a symlink to make it available system-wide
sudo ln -s "$(pwd)/update-all.sh" /usr/local/bin/update-all
sudo ln -s "$(pwd)/update-all.sh" /usr/local/bin/ua
```

## Usage

```bash
# Run all updates
update-all

# Use the short alias
ua

# Show help
update-all --help
ua -h

# Run silently (good for cron jobs or background tasks)
update-all --silent
ua -s

# Show what would be updated without making changes
update-all --dry-run
ua -d

# List all configured update tasks
update-all --list
ua -l
```

## Configuration

Update All creates a configuration file at `~/.update-all.conf` on first run. You can edit this file to customize which package managers to update and add your own custom update commands.

Example configuration:

```bash
# Configuration file for update-all
# Set to false to disable updating specific package managers
UPDATE_HOMEBREW=true
UPDATE_NEOVIM_PLUGINS=true
UPDATE_NEOVIM_MASON=true
UPDATE_CARGO=true
UPDATE_BUN=true
UPDATE_NPM=true
UPDATE_RUBY=true

# Add custom update commands (one per line)
CUSTOM_COMMANDS+=("pip install --upgrade pip")
CUSTOM_COMMANDS+=("rustup update")
```

## Options

- `-h, --help`: Show help message and exit
- `-v, --version`: Show version information and exit
- `-s, --silent`: Run in silent mode (suppress output, good for background tasks)
- `-d, --dry-run`: Show what would be updated without making changes
- `-l, --list`: List all configured update tasks

## Automated Updates

You can set up a cron job to run updates automatically:

```bash
# Edit your crontab
crontab -e

# Add a line to run updates daily at 3 AM
0 3 * * * /usr/local/bin/update-all --silent
```

## Requirements

- Bash 4.0 or later
- The respective package managers you want to update (Homebrew, Cargo, Bun, etc.)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Author

- [Charles Ji](https://github.com/szcharlesji)
