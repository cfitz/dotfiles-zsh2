# Dotfiles

Modern shell configuration and development environment setup.

## Quick Start

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Installation

### First Time Setup

```bash
./install.sh
```

This will:
- Create symlinks from `home/` directory to `$HOME`
- Prompt you if files already exist
- Automatically backup conflicting files
- Initialize git submodules (Oh-My-Zsh, Vim plugins)

### Dry Run (See What Would Happen)

```bash
./install.sh --dry-run
```

### Force Install (Overwrite Everything)

```bash
./install.sh --force
```

### Skip Git Submodules

```bash
./install.sh --skip-submodules
```

### Uninstall

Remove all installed symlinks:

```bash
./install.sh --uninstall
```

Backups of replaced files are stored in `~/.dotfiles-backup-YYYYMMDD-HHMMSS/`

## What's Included

### Shell Configuration

- **`.zshrc`** - Zsh configuration with Oh-My-Zsh, Powerlevel10k, and modern tooling
- **`.p10k.zsh`** - Powerlevel10k theme configuration
- **`.gitconfig`** - Git configuration with useful aliases
- **`.gitignore_global`** (optional) - Global git ignore patterns

### Terminal & Editor

- **`.tmux.conf`** - Tmux configuration with sensible defaults
- **`.vimrc`** - Vim configuration with modern plugins
- **`.vim/bundles.vim`** - Vim plugin manager (vim-plug) and plugins

### Version Managers

The setup assumes you have one of these installed for version management:

- **fnm** - Fast Node.js version manager (instead of nvm)
  ```bash
  curl -fsSL https://fnm.io/install | bash
  ```

- **asdf** - Unified version manager for multiple languages
  ```bash
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
  ~/.asdf/bin/asdf --version
  ```

## Post-Installation Steps

### 1. Install Oh-My-Zsh Plugins

Some plugins require manual installation:

```bash
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# FZF (if not already installed)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 2. Create Vim Undo Directory

```bash
mkdir -p ~/.vim/undo
```

### 3. Install Vim Plugins

On first Vim launch, will prompt to install plugins:

```bash
vim
:PlugInstall
```

### 4. Install CoC LSP Extensions (optional)

For language support in Vim/Neovim with CoC:

```vim
:CocInstall coc-python coc-json coc-html coc-css coc-yaml coc-rust-analyzer
```

## Structure

```
dotfiles/
├── home/                      # Symlinked to $HOME
│   ├── .zshrc               # Shell configuration
│   ├── .tmux.conf           # Tmux configuration
│   ├── .vimrc               # Vim configuration
│   ├── .vim/
│   │   ├── bundles.vim      # Vim plugins (vim-plug)
│   │   └── colors/          # Color schemes
│   ├── .gitconfig           # Git configuration
│   └── .p10k.zsh            # Powerlevel10k theme
├── install.sh               # Installation script
└── README.md                # This file
```

## File Locations

| File | Purpose |
|------|---------|
| `.zshrc` | Main shell configuration |
| `.tmux.conf` | Terminal multiplexer setup |
| `.vimrc` | Text editor configuration |
| `.gitconfig` | Git user and alias configuration |
| `.p10k.zsh` | Prompt theme configuration |

## Customization

### Changing Plugins

Edit `home/.vim/bundles.vim` to add/remove Vim plugins, then run `:PlugInstall` in Vim.

### Changing Shell Aliases

Edit `home/.zshrc` and look for the "Aliases" section.

### Changing Git Aliases

Edit `home/.gitconfig` in the `[alias]` section.

### Customizing Powerlevel10k

Run the interactive configuration wizard:

```bash
p10k configure
```

This updates `~/.p10k.zsh`.

## Maintenance

### Update Installed Tools

```bash
# Update fnm
fnm self-update

# Update asdf
cd ~/.asdf && git pull origin master

# Update Vim plugins
vim
:PlugUpdate

# Update Oh-My-Zsh
upgrade_oh_my_zsh
```

### Backup/Restore

Automatic backups are created when files conflict during installation:

```bash
# Find recent backup
ls ~/.dotfiles-backup-*/

# Restore if needed
cp ~/.dotfiles-backup-YYYYMMDD-HHMMSS/.zshrc ~/.zshrc
```

## Troubleshooting

### Installation script won't execute

Make sure it's executable:

```bash
chmod +x install.sh
```

### Old symlinks pointing to wrong location

Run with `--force` to update:

```bash
./install.sh --force
```

### Submodules not initialized

Initialize manually:

```bash
git submodule update --init --recursive
```

### Vim plugins not working

Install vim-plug and plugins:

```bash
./install.sh  # sets up symlinks
vim           # opens vim
:PlugInstall  # installs plugins
```

## Migration from Homesick

This replaces the old Homesick-based management. The `install.sh` script:

- ✓ Handles symlink creation like Homesick
- ✓ Backs up conflicting files
- ✓ Initializes git submodules
- ✓ No Ruby dependency required
- ✓ Cross-platform (works on macOS, Linux, WSL)

Simply run `./install.sh` to set up your dotfiles.

## License

Feel free to adapt and modify for your own use.
